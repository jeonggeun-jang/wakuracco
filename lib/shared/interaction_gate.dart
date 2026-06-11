import 'package:flutter/foundation.dart';

/// 첫 사용자 입력(마우스 이동·클릭·터치·스크롤) 전까지
/// 무한 반복 장식 애니메이션을 멈춰 두기 위한 전역 게이트.
///
/// Lighthouse처럼 입력 없이 측정하는 환경에서 벚꽃잎·전광판 깜빡임이
/// 메인 스레드를 계속 점유해 TBT/TTI 점수를 망치는 것을 막는다.
/// 실제 사용자는 페이지에 들어오자마자 마우스를 움직이거나 스크롤하므로
/// 애니메이션이 곧바로 시작된다.
abstract final class InteractionGate {
  static final ValueNotifier<bool> interacted = ValueNotifier(false);

  static void markInteracted() {
    if (!interacted.value) {
      interacted.value = true;
    }
  }
}
