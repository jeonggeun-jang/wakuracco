import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:waku/app/app.dart';

void main() {
  setUpAll(() {
    // 테스트 환경에서는 폰트를 네트워크로 받지 않도록 차단
    GoogleFonts.config.allowRuntimeFetching = false;
    // VisibilityDetector가 타이머로 보고를 미루면 테스트가 불안정해지므로 즉시 보고
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('와쿠와쿠 홈페이지가 렌더링된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: WakuWakuApp()));
    await tester.pumpAndSettle();

    expect(find.textContaining('와쿠와쿠'), findsWidgets);
    expect(find.text('우리는 이런 걸 해요'), findsOneWidget);
    expect(find.text('가입하기'), findsOneWidget);
  });

  testWidgets('이달의 추천 탭을 누르면 내용이 바뀐다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: WakuWakuApp()));
    await tester.pumpAndSettle();

    // 기본 탭(애니) 내용 확인
    expect(find.text('장송의 프리렌'), findsOneWidget);

    // 여행지 탭으로 전환.
    // 첫 ensureVisible 후 등장 애니메이션이 위치를 위로 옮기므로 한 번 더 정렬한다.
    await tester.ensureVisible(find.text('⛩️ 이달의 여행지'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('⛩️ 이달의 여행지'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('⛩️ 이달의 여행지'));
    await tester.pumpAndSettle();

    expect(find.text('교토 · 아라시야마'), findsOneWidget);
  });
}
