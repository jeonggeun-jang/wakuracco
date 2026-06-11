import 'package:flutter/material.dart';

import 'package:waku/app/theme.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const List<Color> _lineColors = [
    AppColors.lineGreen,
    AppColors.sakura,
    AppColors.lineBlue,
    AppColors.linePurple,
    AppColors.lineTeal,
    AppColors.lineOrange,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 44),
      child: Column(
        children: [
          // 노선도 점 장식
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final c in _lineColors)
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: c),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '🌸 와쿠와쿠 ワクワク',
            style: AppTextStyles.display(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '일본여행 · 애니 · JPOP · 일본 문화를 사랑하는 사람들의 모임',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 WakuWaku Line. Made with Flutter 💙',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}
