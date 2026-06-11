import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/widgets.dart';

class PicksSection extends ConsumerWidget {
  const PicksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(homeContentProvider).pickCategories;
    final tab = ref.watch(picksTabProvider);
    final picks = categories[tab].picks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          jp: '今月のおすすめ',
          title: '이달의 추천',
          subtitle: '매달 멤버 투표로 뽑는 와쿠와쿠 추천 리스트예요. 탭을 눌러 구경해 보세요!',
        ),
        Wrap(
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
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Container(
            key: ValueKey(tab),
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
                              fontWeight: FontWeight.w800,
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
        ),
      ],
    );
  }
}
