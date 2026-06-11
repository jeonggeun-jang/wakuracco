import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/widgets.dart';

class IntroSection extends ConsumerWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlights = ref.watch(homeContentProvider).highlights;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StationSign(
          code: 'W1',
          name: '소개',
          jp: 'コミュニティ紹介',
          lineColor: AppColors.lineGreen,
          subtitle:
              '와쿠와쿠(ワクワク)는 "두근두근, 설렘"을 뜻하는 일본어예요. '
              '이름 그대로, 일본 이야기만 나오면 두근거리는 사람들이 모였습니다.',
        ),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            for (final h in highlights)
              SizedBox(
                width: 330,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(h.title, style: AppTextStyles.display(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                        h.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.7,
                          color: AppColors.navy.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
