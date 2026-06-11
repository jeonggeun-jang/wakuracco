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

/// 일본어 머리말 + 한글 제목 + 부제로 구성된 섹션 타이틀
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.jp,
    required this.title,
    this.subtitle,
    super.key,
  });

  final String jp;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jp,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.sakura,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
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
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
