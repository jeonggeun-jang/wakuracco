import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waku/app/not_found_page.dart';
import 'package:waku/features/home/home_page.dart';

/// 앱 라우터. 페이지가 늘어나면 routes에 GoRoute를 추가하면 된다.
/// Provider로 감싸 두면 추후 로그인 상태에 따른 redirect 등을 붙이기 쉽다.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});
