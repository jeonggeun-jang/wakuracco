import 'dart:ui' show Color;

import 'package:waku/features/home/models.dart';

/// 홈 화면 콘텐츠 저장소.
/// 지금은 정적 데이터지만, 추후 API나 CMS 연동 시 이 클래스만 교체하면 된다.
class HomeContentRepository {
  const HomeContentRepository();

  /// 카카오톡 오픈채팅 초대 링크.
  /// 실제 링크를 받으면 여기에 넣는다 — 비어 있으면 버튼이 안내 메시지를 띄운다.
  String get openChatUrl => '';

  List<IntroHighlight> get highlights => const [
    IntroHighlight(
      emoji: '🗾',
      title: '함께라서 더 즐거운 일본',
      description:
          '혼자 준비하던 일본 여행, 이제 같이 가요. 항공권 특가 알림부터 동행 모집, 지역별 꿀팁 공유까지 모두 이곳에서.',
    ),
    IntroHighlight(
      emoji: '📣',
      title: '취향이 통하는 사람들',
      description:
          '애니, JPOP, 드라마, 성지순례… 어떤 덕질이든 "어, 그거 나도 좋아해!"라는 대답이 돌아오는 곳이에요.',
    ),
    IntroHighlight(
      emoji: '💬',
      title: '매일 살아있는 채팅방',
      description: '신작 애니 후기, 오늘의 플레이리스트, 라멘 맛집 인증까지. 하루도 조용할 날 없는 우리 단톡방.',
    ),
  ];

  List<Activity> get activities => const [
    Activity(
      emoji: '✈️',
      title: '일본 여행 정보 & 동행',
      description: '항공권 특가 공유, 지역별 추천 코스, 동행 구하기까지. 1년에 두 번은 단체 여행도 떠나요.',
      tags: ['#특가알림', '#동행모집'],
      color: Color(0xFFE3F2FD),
    ),
    Activity(
      emoji: '📺',
      title: '같이 보는 애니',
      description: '분기마다 신작을 같이 정주행하고, 명작은 온라인 상영회로 다시 봐요. 스포는 스포 태그 필수!',
      tags: ['#신작정주행', '#상영회'],
      color: Color(0xFFFFE3EA),
    ),
    Activity(
      emoji: '🎧',
      title: 'JPOP 플레이리스트',
      description: '매달 멤버들이 함께 만드는 공유 플리. 분기마다 JPOP 노래방 정모에서 목청을 풀어요.',
      tags: ['#월간플리', '#노래방정모'],
      color: Color(0xFFF3E5F5),
    ),
    Activity(
      emoji: '🗣️',
      title: '일본어 스터디',
      description: '히라가나 왕초보반부터 JLPT 대비반까지. 좋아하는 애니 대사로 배우니까 더 재밌어요.',
      tags: ['#왕초보환영', '#JLPT'],
      color: Color(0xFFE8F5E9),
    ),
    Activity(
      emoji: '🍜',
      title: '일본 맛집 탐방',
      description: '라멘, 스시, 이자카야… 한국에서 즐기는 일본의 맛. 부담 없는 번개 모임으로 만나요.',
      tags: ['#라멘투어', '#번개모임'],
      color: Color(0xFFFFF3E0),
    ),
    Activity(
      emoji: '🎁',
      title: '굿즈 & 덕질 나눔',
      description: '굿즈 교환과 나눔, 공동구매, 그리고 마음껏 최애 자랑. 어떤 덕질이든 환영이에요.',
      tags: ['#굿즈교환', '#공구'],
      color: Color(0xFFFFF8E1),
    ),
  ];

  List<MeetupEvent> get events => [
    MeetupEvent(
      date: DateTime(2026, 6, 13),
      title: '6월 정기모임 · 이자카야 번개',
      place: '홍대입구역 2번 출구',
      tag: '🍻 오프라인',
    ),
    MeetupEvent(
      date: DateTime(2026, 6, 20),
      title: '분기 신작 애니 같이보기',
      place: '온라인 (디스코드)',
      tag: '📺 온라인',
    ),
    MeetupEvent(
      date: DateTime(2026, 6, 27),
      title: 'JPOP 노래방 정모',
      place: '강남역 코인노래방',
      tag: '🎤 오프라인',
    ),
    MeetupEvent(
      date: DateTime(2026, 7, 11),
      title: '여름 도쿄 여행 (3박 4일) 출발',
      place: '인천공항 T1',
      tag: '✈️ 여행',
    ),
  ];

  List<PickCategory> get pickCategories => const [
    PickCategory(
      label: '📺 이달의 애니',
      picks: [
        Pick(title: '장송의 프리렌', note: '잔잔한데 눈물이 나는 인생작, 멤버 만장일치 추천'),
        Pick(title: '스파이 패밀리', note: '아냐 보면서 힐링하고 싶은 분 모두 모여라'),
        Pick(title: '주술회전', note: '작화가 미쳤다는 말밖에… 정주행 필수'),
        Pick(title: '최애의 아이', note: 'OST 「아이돌」까지 완벽한 화제작'),
      ],
    ),
    PickCategory(
      label: '🎧 이달의 JPOP',
      picks: [
        Pick(title: 'YOASOBI — アイドル', note: '무한 반복 주의보, 이번 달 공유 플리 1위'),
        Pick(title: '요네즈 켄시 — Lemon', note: '들을 때마다 새로운 명곡 중의 명곡'),
        Pick(title: 'Official髭男dism — Pretender', note: '노래방 정모 단골 애창곡'),
        Pick(title: 'Ado — 新時代', note: '원피스 필름 레드 보고 온 사람 손!'),
      ],
    ),
    PickCategory(
      label: '⛩️ 이달의 여행지',
      picks: [
        Pick(title: '교토 · 아라시야마', note: '대나무숲 산책로와 강변 풍경, 가을 단풍 맛집'),
        Pick(title: '가마쿠라 · 에노시마', note: '슬램덩크 건널목 성지순례 필수 코스'),
        Pick(title: '오사카 · 도톤보리', note: '먹방 여행의 성지, 글리코상 앞 인증샷은 국룰'),
        Pick(title: '야마나시 · 가와구치코', note: '후지산 뷰 온천 료칸에서 즐기는 힐링'),
      ],
    ),
  ];

  List<String> get rules => const [
    '서로 존중하기 🤝',
    '광고 · 홍보 금지 🚫',
    '스포일러는 태그 달기 ⚠️',
    '덕질에 진심일 것 💕',
  ];
}
