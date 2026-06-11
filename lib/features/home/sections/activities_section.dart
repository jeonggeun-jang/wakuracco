import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/models.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/widgets.dart';

class ActivitiesSection extends ConsumerWidget {
  const ActivitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(homeContentProvider).activities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          jp: '活動',
          title: '우리는 이런 걸 해요',
          subtitle: '온라인과 오프라인을 오가며 일본을 즐기는 여섯 가지 방법.',
        ),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            for (final a in activities)
              SizedBox(width: 330, child: _ActivityCard(a)),
          ],
        ),
      ],
    );
  }
}

class _ActivityCard extends StatefulWidget {
  const _ActivityCard(this.activity);

  final Activity activity;

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _hover ? AppColors.sakura : AppColors.line),
          boxShadow: [
            BoxShadow(
              color: _hover
                  ? AppColors.sakura.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: _hover ? 24 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: a.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(a.emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 16),
            Text(
              a.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              a.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.navy.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final t in a.tags) TagChip(t)],
            ),
          ],
        ),
      ),
    );
  }
}
