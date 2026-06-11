import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:waku/app/theme.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌸', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            const Text(
              '404 — 페이지를 찾을 수 없어요',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '주소가 바뀌었거나 없는 페이지예요.',
              style: TextStyle(color: AppColors.navy.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.sakura),
              onPressed: () => context.go('/'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
