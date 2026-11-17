import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Ekranların üstündeki "earthmark" başlığı: harita logosu + yazı.
/// Logo dosyası: assets/images/earthmark_logo.png (pubspec.yaml'da tanımlı).
class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/earthmark_logo.png', height: 30),
        const SizedBox(width: 8),
        const Text(
          'earthmark',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.logoGreen,
          ),
        ),
      ],
    );
  }
}
