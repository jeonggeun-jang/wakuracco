import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:waku/app/app.dart';

/// 벚꽃잎·전광판 등 무한 반복 애니메이션이 있어 pumpAndSettle 대신
/// 고정 시간 펌프로 진행한다.
Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: WakuWakuApp()));
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
}

Future<void> _revealAndSettle(WidgetTester tester, Finder finder) async {
  // 첫 ensureVisible 후 등장 애니메이션이 위치를 옮기므로 한 번 더 정렬한다.
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 900));
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 900));
}

void main() {
  setUpAll(() {
    // 테스트 환경에서는 폰트를 네트워크로 받지 않도록 차단
    GoogleFonts.config.allowRuntimeFetching = false;
    // VisibilityDetector가 타이머로 보고를 미루지 않도록 즉시 보고
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('와쿠와쿠 홈페이지가 렌더링된다', (tester) async {
    await _pumpApp(tester);

    expect(find.textContaining('와쿠와쿠'), findsWidgets);
    expect(find.text('가입하기'), findsOneWidget);
    expect(find.text('단톡방 엿보기'), findsOneWidget);
  });

  testWidgets('이달의 추천 탭을 누르면 내용이 바뀐다', (tester) async {
    await _pumpApp(tester);

    // 기본 탭(애니) 내용 확인
    expect(find.text('장송의 프리렌'), findsOneWidget);

    // 여행지 탭으로 전환
    await _revealAndSettle(tester, find.text('⛩️ 이달의 여행지'));
    await tester.tap(find.text('⛩️ 이달의 여행지'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('교토 · 아라시야마'), findsOneWidget);
  });

  testWidgets('오미쿠지를 뽑으면 추천 결과가 나온다', (tester) async {
    await _pumpApp(tester);

    await _revealAndSettle(tester, find.text('🎋 운세 뽑기'));
    await tester.tap(find.text('🎋 운세 뽑기'));
    await tester.pump(const Duration(milliseconds: 800)); // 뽑기 딜레이
    await tester.pump(const Duration(milliseconds: 500)); // 결과 카드 전환

    expect(find.text('🎋 다시 뽑기'), findsOneWidget);
  });
}
