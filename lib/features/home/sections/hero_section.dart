import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/shared/widgets.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    required this.onExplore,
    required this.onJoin,
    super.key,
  });

  final VoidCallback onExplore;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return ClipRect(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.sakuraLight, AppColors.cream],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: wide ? 100 : 60,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -30,
                  top: -40,
                  child: IgnorePointer(
                    child: Text(
                      'ワクワク',
                      style: TextStyle(
                        fontSize: wide ? 150 : 80,
                        fontWeight: FontWeight.w900,
                        color: AppColors.sakura.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      [
                            const TagChip(
                              '🌸 since 2024 · 멤버 128명 · 오늘도 와쿠와쿠!',
                              color: Colors.white,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '일본을 사랑하는 사람들의\n두근두근 아지트, 와쿠와쿠',
                              style: TextStyle(
                                fontSize: wide ? 48 : 30,
                                height: 1.3,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 560),
                              child: Text(
                                '벚꽃 시즌 항공권 특가부터 이번 분기 신작 애니, '
                                '출근길 JPOP 플레이리스트까지 — 일본이 좋다면 그걸로 충분한 모임입니다.',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: AppColors.navy.withValues(alpha: 0.65),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
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
                            const SizedBox(height: 36),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton(
                                  onPressed: onExplore,
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
                                  child: const Text('활동 구경하기 →'),
                                ),
                                OutlinedButton(
                                  onPressed: onJoin,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.navy,
                                    side: const BorderSide(
                                      color: AppColors.navy,
                                    ),
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
                          ]
                          .animate(interval: 80.ms)
                          .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                          .moveY(
                            begin: 14,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
