import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/models.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/widgets.dart';

/// 공항 출발 안내 전광판 스타일의 모임 일정 섹션
class EventsSection extends ConsumerWidget {
  const EventsSection({super.key});

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countdowns = ref.watch(eventCountdownsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StationSign(
          code: 'W3',
          name: '모임 일정',
          jp: 'スケジュール',
          lineColor: AppColors.lineBlue,
          subtitle: '참여는 언제나 자유! 단톡방 공지에서 신청만 하면 끝이에요.',
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          decoration: BoxDecoration(
            color: AppColors.boardBg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Blink(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.boardAmber,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'DEPARTURES · 出発のご案内',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                      color: AppColors.boardAmber,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'WAKU LINE',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
              for (final c in countdowns) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 86,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dateLabel(c.event.date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.boardAmber,
                              ),
                            ),
                            Text(
                              '${_weekdays[c.event.date.weekday - 1]}요일',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.event.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${c.event.tag} · ${c.event.place}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _StatusChip(countdown: c),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white.withValues(alpha: 0.08),
                  height: 1,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _dateLabel(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '$mm.$dd';
  }
}

/// 일정 상태 칩 (운행 종료 / 출발 임박 / 탑승 수속)
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.countdown});

  final EventCountdown countdown;

  @override
  Widget build(BuildContext context) {
    final c = countdown;
    if (c.isOver) {
      return _chip(
        '운행 종료',
        Colors.white.withValues(alpha: 0.08),
        Colors.white.withValues(alpha: 0.35),
      );
    }
    if (c.daysLeft == 0) {
      return _Blink(
        child: _chip(
          '🚨 출발 임박',
          AppColors.boardRed.withValues(alpha: 0.18),
          AppColors.boardRed,
        ),
      );
    }
    if (c.daysLeft <= 3) {
      return _chip(
        '곧 출발 D-${c.daysLeft}',
        AppColors.boardAmber.withValues(alpha: 0.14),
        AppColors.boardAmber,
      );
    }
    return _chip(
      '탑승 수속 D-${c.daysLeft}',
      AppColors.boardGreen.withValues(alpha: 0.13),
      AppColors.boardGreen,
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

/// 전광판처럼 깜빡이는 효과
class _Blink extends StatefulWidget {
  const _Blink({required this.child});

  final Widget child;

  @override
  State<_Blink> createState() => _BlinkState();
}

class _BlinkState extends State<_Blink> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.25, end: 1).animate(_controller),
      child: widget.child,
    );
  }
}
