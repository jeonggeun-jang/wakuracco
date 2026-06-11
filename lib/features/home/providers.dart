import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waku/features/home/data/home_content.dart';
import 'package:waku/features/home/models.dart';

/// 홈 콘텐츠 저장소
final homeContentProvider = Provider<HomeContentRepository>(
  (ref) => const HomeContentRepository(),
);

/// 일정 목록 + D-day 계산
final eventCountdownsProvider = Provider<List<EventCountdown>>((ref) {
  final events = ref.watch(homeContentProvider).events;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return [
    for (final e in events)
      EventCountdown(event: e, daysLeft: e.date.difference(today).inDays),
  ];
});

/// '이달의 추천'에서 현재 선택된 탭 인덱스
final picksTabProvider = NotifierProvider<PicksTabNotifier, int>(
  PicksTabNotifier.new,
);

class PicksTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  int get selected => state;

  set selected(int index) => state = index;
}
