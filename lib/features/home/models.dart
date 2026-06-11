import 'dart:ui' show Color;

/// 소개 섹션 카드
class IntroHighlight {
  const IntroHighlight({
    required this.emoji,
    required this.title,
    required this.description,
  });

  final String emoji;
  final String title;
  final String description;
}

/// 활동 카드
class Activity {
  const Activity({
    required this.emoji,
    required this.title,
    required this.description,
    required this.tags,
    required this.color,
  });

  final String emoji;
  final String title;
  final String description;
  final List<String> tags;
  final Color color;
}

/// 모임 일정
class MeetupEvent {
  const MeetupEvent({
    required this.date,
    required this.title,
    required this.place,
    required this.tag,
  });

  final DateTime date;
  final String title;
  final String place;
  final String tag;
}

/// 추천 항목
class Pick {
  const Pick({required this.title, required this.note});

  final String title;
  final String note;
}

/// 추천 카테고리 (탭 하나)
class PickCategory {
  const PickCategory({required this.label, required this.picks});

  final String label;
  final List<Pick> picks;
}

/// 히어로 통계 (카운트업 애니메이션용)
class Stat {
  const Stat({required this.label, required this.value, required this.suffix});

  final String label;
  final int value;
  final String suffix;
}

/// 단톡방 엿보기 메시지
class ChatMessage {
  const ChatMessage({
    required this.avatar,
    required this.nickname,
    required this.text,
    required this.time,
    this.reaction,
  });

  final String avatar;
  final String nickname;
  final String text;
  final String time;
  final String? reaction;
}

/// 일정에 D-day 계산을 얹은 뷰 모델
class EventCountdown {
  const EventCountdown({required this.event, required this.daysLeft});

  final MeetupEvent event;
  final int daysLeft;

  bool get isOver => daysLeft < 0;

  String get label =>
      daysLeft == 0 ? 'D-DAY' : (daysLeft > 0 ? 'D-$daysLeft' : '종료');
}
