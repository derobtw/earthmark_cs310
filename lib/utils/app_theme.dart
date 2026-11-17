import 'package:flutter/material.dart';

/// Uygulamanın teması: MaterialApp'e verilen ThemeData.
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
    );
  }
}

/// Uygulamanın renkleri. Bütün ekranlar renkleri buradan alır; böylece
/// Been (yeşil) / Wish (mavi) renkleri harita, kartlar ve butonlarda aynı olur.
class AppColors {
  static const Color primary = Color(0xFF1E6B4E);
  static const Color primaryLight = Color(0xFFE0EFE6);
  static const Color logoGreen = Color(0xFF0E553F); // logodaki yazının rengi

  static const Color been = Color(0xFF2E8B57);
  static const Color beenLight = Color(0xFFE6F3EA);
  static const Color beenChip = Color(0xFFCFE8D8);
  static const Color beenBorder = Color(0xFFB9DDC6);

  static const Color wish = Color(0xFF3D6FB0);
  static const Color wishLight = Color(0xFFE8F0FA);
  static const Color wishChip = Color(0xFFD3E2F5);
  static const Color wishBorder = Color(0xFFBFD3EE);

  static const Color unselected = Color(0xFFD5DAE0);

  // Harita: seçilmemiş ülkeler gri, sınırlar beyaz.
  static const Color mapUnselected = Color(0xFFDCE1E6);
  static const Color mapBorder = Colors.white;
  static const Color mapBackground = Color(0xFFF2F5F7);

  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFDECEC);

  static const Color textDark = Color(0xFF1A2B33);
  static const Color textMuted = Color(0xFF6B7780);
  static const Color border = Color(0xFFDDE3E7);
  static const Color tabInactive = Color(0xFFECEFEE);
  static const Color background = Color(0xFFF6F8F7);
}
