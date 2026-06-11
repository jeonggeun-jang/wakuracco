import 'package:flutter/material.dart';

import 'package:waku/app/theme.dart';

/// 가로 폭 제한(1080px) + 상하 여백을 주는 섹션 래퍼
class Section extends StatelessWidget {
  const Section({required this.child, this.background, super.key});

  final Color? background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: child,
        ),
      ),
    );
  }
}

/// 일본 기차역 역명판(駅名標) 스타일의 섹션 타이틀.
/// 노선 색 띠 + 역 번호 배지 + 역 이름으로 구성된다.
class StationSign extends StatelessWidget {
  const StationSign({
    required this.code,
    required this.name,
    required this.jp,
    required this.lineColor,
    this.subtitle,
    super.key,
  });

  final String code;
  final String name;
  final String jp;
  final Color lineColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.navy.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 12, 30, 18),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: lineColor, width: 3.5),
                          ),
                          child: Text(
                            code,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: lineColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.display(fontSize: 26),
                            ),
                            Text(
                              jp,
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 노선 색 띠
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 6,
                    child: ColoredBox(color: lineColor),
                  ),
                ],
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 둥근 알약 모양 태그
class TagChip extends StatelessWidget {
  const TagChip(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? AppColors.sakuraLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
