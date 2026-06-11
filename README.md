# 와쿠와쿠 ワクワク

일본여행 · 애니 · JPOP 등 일본 문화를 사랑하는 사람들의 모임 **와쿠와쿠** 소개 페이지 (Flutter Web).

## 기술 스택

- **Flutter 3.44** (웹 전용, WebAssembly 빌드 지원)
- **go_router** — 선언적 라우팅 (`lib/app/router.dart`)
- **Riverpod 3** — 상태 관리 및 의존성 주입
- **google_fonts** — Noto Sans KR
- **flutter_animate + visibility_detector** — 스크롤 진입 시 섹션 등장 애니메이션 (`lib/shared/reveal_on_scroll.dart`)
- **responsive_framework** — 브레이크포인트(MOBILE/TABLET/DESKTOP) 기반 반응형
- **url_launcher** — 카카오톡 오픈채팅 링크 연결 (링크는 `home_content.dart`의 `openChatUrl`)
- **very_good_analysis** — 엄격한 린트 세트

## 프로젝트 구조

```
lib/
├── main.dart                  # 진입점 (ProviderScope, URL 전략)
├── app/
│   ├── app.dart               # MaterialApp.router
│   ├── router.dart            # GoRouter 설정 (routerProvider)
│   ├── theme.dart             # AppColors / AppTheme
│   └── not_found_page.dart    # 404 페이지
├── shared/
│   └── widgets.dart           # Section, SectionTitle, TagChip 공용 위젯
└── features/
    └── home/
        ├── home_page.dart     # 홈 화면 (앱바 + 섹션 조립 + 스크롤 내비)
        ├── models.dart        # Activity, MeetupEvent, Pick 등 모델
        ├── providers.dart     # Riverpod 프로바이더 (콘텐츠, D-day, 탭 상태)
        ├── data/
        │   └── home_content.dart  # 콘텐츠 저장소 (추후 API 연동 지점)
        └── sections/          # 화면 섹션 위젯 (히어로, 소개, 활동, 일정, 추천, 가입, 푸터)
```

## 실행

```sh
flutter run -d chrome          # 개발 모드
flutter run -d chrome --wasm   # WasmGC로 실행
```

## 테스트 & 빌드

```sh
flutter analyze                # 정적 분석
flutter test                   # 위젯 테스트
flutter build web --wasm       # 배포 빌드 (build/web, wasm + JS 폴백)
```

배포 시 멀티스레드 렌더링을 쓰려면 서버에서 다음 헤더를 내려야 한다 (없어도 단일 스레드로 동작):

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```
