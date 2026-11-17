import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Alt menü: World · Continents · My Countries.
/// Screen 1, 3, 5 (MainShell) ve Screen 4'te kullanılır. Screen 2 bir form
/// olduğu için alt menü yerine geri oku var.
class AppBottomNav extends StatelessWidget {
  // Sekme sıraları (MainShell'deki IndexedStack ile aynı sırada).
  static const int worldTab = 0;
  static const int continentsTab = 1;
  static const int myCountriesTab = 2;

  final int currentIndex;
  final void Function(int index) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.public), label: 'World'),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Continents',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          label: 'My Countries',
        ),
      ],
    );
  }
}
