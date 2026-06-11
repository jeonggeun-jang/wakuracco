import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/models.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/widgets.dart';

/// 오미쿠지(제비뽑기) + 이달의 추천 리스트 섹션
class PicksSection extends ConsumerStatefulWidget {
  const PicksSection({super.key});

  @override
  ConsumerState<PicksSection> createState() => _PicksSectionState();
}

class _PicksSectionState extends ConsumerState<PicksSection> {
  /// (한자 등급, 한글 등급, 운세 코멘트)
  static const _grades = [
    ('大吉', '대길', '미루면 손해! 오늘 바로 시작하세요'),
    ('中吉', '중길', '같이 할 멤버를 단톡방에서 구해보세요'),
    ('吉', '길', '천천히 음미할수록 더 좋은 운세예요'),
    ('小吉', '소길', '가볍게 맛보기로 시작해 보세요'),
  ];

  final _random = Random();
  int _shakeTick = 0;
  bool _drawing = false;
  (String, String, String)? _grade;
  String? _category;
  Pick? _drawn;

  Future<void> _draw(List<PickCategory> categories) async {
    if (_drawing) return;
    setState(() {
      _drawing = true;
      _drawn = null;
      _shakeTick++;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final category = categories[_random.nextInt(categories.length)];
    setState(() {
      _category = category.label;
      _drawn = category.picks[_random.nextInt(category.picks.length)];
      _grade = _grades[_random.nextInt(_grades.length)];
      _drawing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(homeContentProvider).pickCategories;
    final tab = ref.watch(picksTabProvider);
    final wide = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StationSign(
          code: 'W4',
          name: '이달의 추천',
          jp: '今月のおすすめ',
          lineColor: AppColors.linePurple,
          subtitle:
              '뭘 볼지, 뭘 들을지, 어디로 갈지 고민된다면 — '
              '오미쿠지에게 맡겨 보세요.',
        ),
        Flex(
          direction: wide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOmikujiBox(categories),
            SizedBox(width: wide ? 28 : 0, height: wide ? 0 : 24),
            if (wide) Expanded(child: _buildResult()) else _buildResult(),
          ],
        ),
        const SizedBox(height: 44),
        Text('전체 추천 리스트', style: AppTextStyles.display(fontSize: 20)),
        const SizedBox(height: 14),
        _buildTabs(categories, tab),
        const SizedBox(height: 18),
        _buildRankList(categories[tab].picks),
      ],
    );
  }

  Widget _buildOmikujiBox(List<PickCategory> categories) {
    return Column(
      children: [
        Animate(
          key: ValueKey(_shakeTick),
          effects: const [
            ShakeEffect(
              duration: Duration(milliseconds: 700),
              hz: 5,
              rotation: 0.045,
            ),
          ],
          child: Container(
            width: 180,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFF7E8D7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.navy.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final ch in '御神籤'.characters)
                  Text(
                    ch,
                    style: AppTextStyles.display(
                      color: AppColors.navy.withValues(alpha: 0.75),
                    ),
                  ),
                const SizedBox(height: 12),
                Container(
                  width: 54,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: _drawing ? null : () => unawaited(_draw(categories)),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.linePurple,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 16,
            ),
          ),
          child: Text(_drawn == null ? '🎋 운세 뽑기' : '🎋 다시 뽑기'),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final Widget content;
    if (_drawing) {
      content = Container(
        key: const ValueKey('drawing'),
        height: 200,
        alignment: Alignment.center,
        child: Text(
          '운세를 고르는 중… 🎋',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.navy.withValues(alpha: 0.5),
          ),
        ),
      );
    } else if (_drawn == null) {
      content = Container(
        key: const ValueKey('empty'),
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line, width: 2),
        ),
        child: Text(
          '오미쿠지를 뽑으면\n오늘의 추천이 나와요!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.navy.withValues(alpha: 0.45),
          ),
        ),
      );
    } else {
      final grade = _grade;
      content = Container(
        key: ValueKey(_drawn),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.linePurple, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.linePurple.withValues(alpha: 0.15),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  grade?.$1 ?? '',
                  style: AppTextStyles.display(
                    fontSize: 36,
                    color: AppColors.sakura,
                  ),
                ),
                Text(
                  grade?.$2 ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _category ?? '',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.linePurple.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _drawn?.title ?? '',
                    style: AppTextStyles.display(fontSize: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _drawn?.note ?? '',
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.6,
                      color: AppColors.navy.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '💡 ${grade?.$3 ?? ''}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation.drive(
          Tween<double>(
            begin: 0.88,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeOutBack)),
        ),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: content,
    );
  }

  Widget _buildTabs(List<PickCategory> categories, int tab) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < categories.length; i++)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => ref.read(picksTabProvider.notifier).selected = i,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: tab == i ? AppColors.sakura : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: tab == i ? AppColors.sakura : AppColors.line,
                ),
              ),
              child: Text(
                categories[i].label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: tab == i ? Colors.white : AppColors.navy,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRankList(List<Pick> picks) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(picks),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            for (final (i, pick) in picks.indexed) ...[
              if (i > 0) const Divider(height: 1, color: AppColors.line),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.sakuraLight,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.sakura,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pick.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pick.note,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.navy.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
