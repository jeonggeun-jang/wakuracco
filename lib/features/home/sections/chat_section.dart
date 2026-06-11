import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/models.dart';
import 'package:waku/features/home/providers.dart';
import 'package:waku/shared/reveal_on_scroll.dart';
import 'package:waku/shared/widgets.dart';

/// 단톡방 분위기를 보여주는 채팅 미리보기 섹션.
/// 버블이 실제 채팅처럼 순차적으로 떠오른다.
class ChatSection extends ConsumerWidget {
  const ChatSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(homeContentProvider).chatMessages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RevealOnScroll(
          child: StationSign(
            code: 'W5',
            name: '단톡방 엿보기',
            jp: 'チャット',
            lineColor: AppColors.lineTeal,
            subtitle: '와쿠와쿠 단톡방의 어느 평화로운 저녁. 매일 이런 분위기예요.',
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFBACEE0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu, size: 16, color: Colors.black45),
                    const SizedBox(width: 10),
                    Text(
                      '와쿠와쿠 ワクワク 🌸',
                      style: AppTextStyles.display(fontSize: 15),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '128',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const Spacer(),
                    const Icon(Icons.search, size: 16, color: Colors.black45),
                  ],
                ),
                const SizedBox(height: 16),
                for (final (i, m) in messages.indexed)
                  RevealOnScroll(
                    delay: Duration(milliseconds: i * 130),
                    child: _ChatBubble(message: m),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(message.avatar, style: const TextStyle(fontSize: 19)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.nickname,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      message.time,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.navy.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
                if (message.reaction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        message.reaction!,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
