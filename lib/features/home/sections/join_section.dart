import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/providers.dart';

class JoinSection extends ConsumerWidget {
  const JoinSection({super.key});

  Future<void> _openChat(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    if (url.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('오픈채팅 링크는 추후 연결 예정이에요! 모임방 공지를 확인해 주세요 🌸'),
        ),
      );
      return;
    }
    final launched = await launchUrl(Uri.parse(url));
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('링크를 열 수 없어요. 잠시 후 다시 시도해 주세요 🙏'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(homeContentProvider);
    final wide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.sakura, Color(0xFFFF8E6E)],
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              const Text(
                '終点 · 종착역',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '와쿠와쿠에 어서 오세요! 🌸',
                textAlign: TextAlign.center,
                style: AppTextStyles.display(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '일본이 좋다면 그걸로 충분해요.\n여행 계획이 없어도, 덕질 경력이 짧아도 누구나 환영합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in content.rules)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        r,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () =>
                    unawaited(_openChat(context, content.openChatUrl)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.kakaoYellow,
                  foregroundColor: AppColors.kakaoText,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('💬 카카오톡 오픈채팅 참여하기'),
              ),
            ],
          ),
        ),
        // 여권 도장 느낌의 스탬프
        if (wide)
          Positioned(
            top: 18,
            right: 26,
            child: Transform.rotate(angle: -0.22, child: const _Stamp()),
          ),
      ],
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp();

  @override
  Widget build(BuildContext context) {
    final ink = Colors.white.withValues(alpha: 0.6);
    return Container(
      width: 106,
      height: 106,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ink, width: 3),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ink, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '入会歓迎',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
            Text(
              'WAKU²',
              style: AppTextStyles.display(fontSize: 21, color: Colors.white),
            ),
            Text(
              'EST. 2024',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
