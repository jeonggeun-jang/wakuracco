import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:waku/app/router.dart';
import 'package:waku/app/theme.dart';

class WakuWakuApp extends ConsumerWidget {
  const WakuWakuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '와쿠와쿠 ワクワク — 일본 문화를 사랑하는 사람들의 모임',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 899, name: TABLET),
          Breakpoint(start: 900, end: double.infinity, name: DESKTOP),
        ],
      ),
    );
  }
}
