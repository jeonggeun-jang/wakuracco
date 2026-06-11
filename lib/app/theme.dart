import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 와쿠와쿠 브랜드 팔레트
abstract final class AppColors {
  static const sakura = Color(0xFFE85A71);
  static const sakuraLight = Color(0xFFFFE3EA);
  static const navy = Color(0xFF2B2D42);
  static const cream = Color(0xFFFFF9F5);
  static const line = Color(0xFFF0E4E0);
  static const kakaoYellow = Color(0xFFFEE500);
  static const kakaoText = Color(0xFF191919);
}

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.sakura),
      scaffoldBackgroundColor: AppColors.cream,
    );
    return base.copyWith(
      textTheme: GoogleFonts.notoSansKrTextTheme(base.textTheme),
    );
  }
}
