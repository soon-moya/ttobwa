import 'package:flutter/material.dart';

class AppTheme {
  // 색상
  static const Color primary = Color(0xFF2563EB);       // 파란색
  static const Color primaryDark = Color(0xFF1E40AF);   // 진한 파란색
  static const Color accent = Color(0xFF10B981);        // 초록색
  static const Color error = Color(0xFFDC2626);         // 빨간색
  static const Color warning = Color(0xFFF59E0B);       // 노란색
  
  // 선생님별 색상
  static const List<Color> therapistColors = [
    Color(0xFF2563EB),  // 파란색
    Color(0xFFDC2626),  // 빨간색
    Color(0xFF16A34A),  // 초록색
    Color(0xFF7C3AED),  // 보라색
    Color(0xFFF59E0B),  // 주황색
    Color(0xFF0891B2),  // 청록색
    Color(0xFFBE185D),  // 핫핑크
    Color(0xFF7C2D12),  // 갈색
  ];
  
  // Typography
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
  );
  
  // Spacing
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  
  // Border Radius
  static const double radius4 = 4;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;
}
