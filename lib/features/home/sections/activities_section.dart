import 'package:flutter/gestures.dart';
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
        const StationSign(
          code: 'W2',
          name: '활동',
          jp: '活動',
          lineColor: AppColors.sakura,
          subtitle:
              '온라인과 오프라인을 오가며 일본을 즐기는 여섯 가지 방법. '
              '카드에 마우스를 올려 보세요!',
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

/// 마우스를 따라 3D로 기울어지는 활동 카드
class _ActivityCard extends StatefulWidget {
  const _ActivityCard(this.activity);

  final Activity activity;

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool _hover = false;
  Offset _tilt = Offset.zero;

  void _updateTilt(PointerHoverEvent event) {
    final render = context.findRenderObject();
    if (render is! RenderBox) return;
    final local = render.globalToLocal(event.position);
    setState(() {
      _hover = true;
      _tilt = Offset(
        (local.dx / render.size.width - 0.5).clamp(-0.5, 0.5),
        (local.dy / render.size.height - 0.5).clamp(-0.5, 0.5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0014)
      ..rotateX(-_tilt.dy * 0.22)
      ..rotateY(_tilt.dx * 0.22);

    return MouseRegion(
      onHover: _updateTilt,
      onExit: (_) => setState(() {
        _hover = false;
        _tilt = Offset.zero;
      }),
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hover ? AppColors.sakura : AppColors.line,
            ),
            boxShadow: [
              BoxShadow(
                color: _hover
                    ? AppColors.sakura.withValues(alpha: 0.22)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _hover ? 28 : 10,
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
              Text(a.title, style: AppTextStyles.display(fontSize: 19)),
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
      ),
    );
  }
}
