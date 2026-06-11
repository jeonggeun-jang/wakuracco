import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/models.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/sakura_petals.dart';
import 'package:waku/shared/widgets.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({
    required this.onExplore,
    required this.onJoin,
    super.key,
  });

  final VoidCallback onExplore;
  final VoidCallback onJoin;

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> {
  /// 마우스 위치 기반 패럴랙스 (-0.5 ~ 0.5)
  final ValueNotifier<Offset> _parallax = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _parallax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final stats = ref.watch(homeContentProvider).stats;

    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.sizeOf(context);
        _parallax.value = Offset(
          event.position.dx / size.width - 0.5,
          event.position.dy / size.height - 0.5,
        );
      },
      child: ClipRect(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.sakuraLight, AppColors.cream],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: SakuraPetals(count: wide ? 26 : 14)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 110,
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _SeigaihaPainter(
                      color: AppColors.sakura.withValues(alpha: 0.07),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: wide ? 88 : 56,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Row(
                      children: [
                        Expanded(child: _buildCopy(wide, stats)),
                        if (wide) ...[
                          const SizedBox(width: 32),
                          _ToriiArt(parallax: _parallax),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopy(bool wide, List<Stat> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          [
                const TagChip(
                  '🚃 와쿠와쿠선 출발합니다 · since 2024',
                  color: Colors.white,
                ),
                const SizedBox(height: 22),
                Text(
                  '일본을 사랑하는 사람들의\n두근두근 아지트, 와쿠와쿠',
                  style: AppTextStyles.display(
                    fontSize: wide ? 52 : 32,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Text(
                    '벚꽃 시즌 항공권 특가부터 이번 분기 신작 애니, '
                    '출근길 JPOP 플레이리스트까지 — '
                    '일본이 좋다면 그걸로 충분한 모임입니다.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: AppColors.navy.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TagChip('#일본여행'),
                    TagChip('#애니'),
                    TagChip('#JPOP'),
                    TagChip('#일본어스터디'),
                    TagChip('#맛집탐방'),
                    TagChip('#굿즈나눔'),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: widget.onExplore,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.sakura,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                        textStyle: GoogleFonts.notoSansKr(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('노선 따라 구경하기 🚃'),
                    ),
                    OutlinedButton(
                      onPressed: widget.onJoin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.navy,
                        side: const BorderSide(color: AppColors.navy),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                        textStyle: GoogleFonts.notoSansKr(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('가입 안내'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 36,
                  runSpacing: 16,
                  children: [
                    for (final s in stats)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CountUp(value: s.value, suffix: s.suffix),
                          Text(
                            s.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.navy.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ]
              .animate(interval: 80.ms)
              .fadeIn(duration: 500.ms, curve: Curves.easeOut)
              .moveY(
                begin: 14,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}

/// 숫자가 0부터 차오르는 카운트업 텍스트
class _CountUp extends StatelessWidget {
  const _CountUp({required this.value, required this.suffix});

  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(
        '${v.round()}$suffix',
        style: AppTextStyles.display(fontSize: 24, color: AppColors.sakura),
      ),
    );
  }
}

/// 토리이(신사 문) + 세로 ワクワク 일러스트. 마우스를 따라 살짝 움직인다.
class _ToriiArt extends StatelessWidget {
  const _ToriiArt({required this.parallax});

  final ValueListenable<Offset> parallax;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: parallax,
      builder: (context, offset, child) => Transform.translate(
        offset: Offset(offset.dx * -16, offset.dy * -12),
        child: child,
      ),
      child: SizedBox(
        width: 300,
        height: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 떠오르는 해
            Positioned(
              top: 4,
              child: Container(
                width: 215,
                height: 215,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sakura.withValues(alpha: 0.12),
                ),
              ),
            ),
            CustomPaint(
              size: const Size(225, 235),
              painter: _ToriiPainter(),
            ),
            Positioned(
              right: 2,
              top: 14,
              child: Column(
                children: [
                  for (final ch in 'ワクワク'.characters)
                    Text(
                      ch,
                      style: AppTextStyles.display(
                        color: AppColors.sakura.withValues(alpha: 0.4),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                'ようこそ、いらっしゃい',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 3,
                  color: AppColors.navy.withValues(alpha: 0.45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 토리이 실루엣
class _ToriiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()..color = AppColors.torii;
    final w = size.width;
    final h = size.height;

    canvas
      // 카사기 (맨 위 가로보)
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, h * 0.05, w, h * 0.075),
          const Radius.circular(5),
        ),
        brush,
      )
      // 시마키 (두 번째 가로보)
      ..drawRect(
        Rect.fromLTWH(w * 0.07, h * 0.15, w * 0.86, h * 0.05),
        brush,
      )
      // 누키 (아래 가로보)
      ..drawRect(
        Rect.fromLTWH(w * 0.03, h * 0.34, w * 0.94, h * 0.055),
        brush,
      )
      // 기둥 두 개
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.15, h * 0.16, w * 0.085, h * 0.84),
          const Radius.circular(3),
        ),
        brush,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.765, h * 0.16, w * 0.085, h * 0.84),
          const Radius.circular(3),
        ),
        brush,
      )
      // 가쿠즈카 (가운데 짧은 기둥)
      ..drawRect(
        Rect.fromLTWH(w * 0.465, h * 0.16, w * 0.07, h * 0.18),
        brush,
      );
  }

  @override
  bool shouldRepaint(_ToriiPainter oldDelegate) => false;
}

/// 세이가이하(青海波) 물결 무늬
class _SeigaihaPainter extends CustomPainter {
  _SeigaihaPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = color;
    const r = 26.0;
    var row = 0;
    for (var y = size.height + r; y > -r; y -= r * 0.6) {
      final offsetX = row.isEven ? 0.0 : r;
      for (var x = -r + offsetX; x < size.width + r; x += r * 2) {
        for (var k = 0; k < 3; k++) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(x, y), radius: r - k * 7),
            3.14159,
            3.14159,
            false,
            brush,
          );
        }
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(_SeigaihaPainter oldDelegate) =>
      oldDelegate.color != color;
}
