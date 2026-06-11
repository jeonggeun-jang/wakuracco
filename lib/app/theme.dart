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

  // 출발 안내 전광판
  static const boardBg = Color(0xFF171A2B);
  static const boardAmber = Color(0xFFFFC24B);
  static const boardGreen = Color(0xFF55D6A0);
  static const boardRed = Color(0xFFFF6B6B);

  // 섹션별 노선 색 (지하철 노선도 컨셉)
  static const lineGreen = Color(0xFF2E9E6B);
  static const lineBlue = Color(0xFF3B7DD8);
  static const linePurple = Color(0xFF8E5BC6);
  static const lineTeal = Color(0xFF18A99B);
  static const lineOrange = Color(0xFFEF8232);

  // 토리이(신사 문) 주홍색
  static const torii = Color(0xFFD6485C);
}

/// 제목용 디스플레이 폰트(Jua) 헬퍼
abstract final class AppTextStyles {
  static TextStyle display({
    double fontSize = 30,
    Color color = AppColors.navy,
    double? height,
  }) {
    return GoogleFonts.jua(fontSize: fontSize, color: color, height: height);
  }
}

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.sakura),
      scaffoldBackgroundColor: AppColors.cream,
    );
    final textTheme = GoogleFonts.notoSansKrTextTheme(base.textTheme);
    return base.copyWith(
      // 폰트 굵기는 400/700 두 가지만 사용한다.
      // Noto Sans KR은 굵기당 ~3MB짜리 별도 파일이라, 쓰는 굵기 수가
      // 곧 다운로드 용량이다 (버튼 기본값 w500도 w700으로 통일).
      textTheme: textTheme.copyWith(
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
