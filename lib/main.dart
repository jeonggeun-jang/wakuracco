import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:waku/app/app.dart';

void main() {
  // 웹 URL에서 해시(#)를 제거해 깔끔한 경로(/foo)를 사용한다.
  // 비웹 플랫폼에서는 자동으로 no-op이다.
  usePathUrlStrategy();
  runApp(const ProviderScope(child: WakuWakuApp()));
}
