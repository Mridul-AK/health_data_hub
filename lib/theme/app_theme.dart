import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color bg = Color(0xFF000000);
  static const Color bgElevated = Color(0xFF080B09);
  static const Color card = Color(0xFF080B09);
  static const Color textPrimary = Color(0xFFF3F6F4);
  static const Color textSecondary = Color(0xFF9BA6A1);
  static const Color textFaint = Color(0xFF5E6A65);
  static const Color green = Color(0xFF37E36B);
  static const Color greenDim = Color(0xFF1B7A3C);
  static const Color red = Color(0xFFF2452F);
  static const Color redDim = Color(0xFF7A241B);
  static const Color gold = Color(0xFFF5C43B);
  static const Color goldDim = Color(0xFF7A6320);
  static const Color cyan = Color(0xFF3FD8E8);
  static const Color blue = Color(0xFF2E7BF6);
  static const Color amber = Color(0xFFF39B2B);
  static const Color line = Color(0xFF1C2723);
}

enum AccentTheme { green, red, gold, cyan }

extension AccentColors on AccentTheme {
  Color get color {
    switch (this) {
      case AccentTheme.green:
        return AppColors.green;
      case AccentTheme.red:
        return AppColors.red;
      case AccentTheme.gold:
        return AppColors.gold;
      case AccentTheme.cyan:
        return AppColors.cyan;
    }
  }

  Color get glow {
    switch (this) {
      case AccentTheme.green:
        return const Color(0xFF0B331A);
      case AccentTheme.red:
        return const Color(0xFF380E09);
      case AccentTheme.gold:
        return const Color(0xFF6E500E);
      case AccentTheme.cyan:
        return const Color(0xFF08262A);
    }
  }
}

class AppText {
  AppText._();

  static const String display = 'Michroma';
  static const String mono = 'SpaceMono';

  static const TextStyle screenTitle = TextStyle(
    fontFamily: display,
    fontSize: 15,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: display,
    fontSize: 18,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: display,
    fontSize: 15,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13.5,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyFaint = TextStyle(
    fontSize: 12.5,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle mono10 = TextStyle(
    fontFamily: mono,
    fontSize: 10,
    color: AppColors.textSecondary,
  );

  static const TextStyle chipLabel = TextStyle(
    fontFamily: mono,
    fontSize: 9.5,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.green,
        surface: AppColors.card,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}
