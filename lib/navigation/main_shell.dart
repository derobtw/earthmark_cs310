import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../screens/my_countries_screen.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

/// Alt menüyü ve üç sekmeyi (World, Continents, My Countries) tutan ana ekran.
///
/// IndexedStack sayesinde sekmeler arasında geçince her sekmenin durumu
/// korunur (ör. My Countries'teki arama, seçili kıta).
/// TravelData'yı dinler: veri hangi ekranda değişirse değişsin setState ile
/// bütün sekmeler yeniden çizilir (harita renkleri, istatistikler, liste).
class MainShell extends StatefulWidget {
  final TravelData travelData;

  const MainShell({super.key, required this.travelData});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // World ekranı henüz hazır olmadığı için şimdilik My Countries ile açılıyor.
  int _tabIndex = AppBottomNav.myCountriesTab;

  @override
  void initState() {
    super.initState();
    widget.travelData.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    widget.travelData.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (!mounted) return;
    setState(() {});
  }

  /// Sekme değiştirir. Alt ekranlara (Screen 2, 4) da verilir; oradan
  /// "Done" ya da alt menü ile istenen sekmeye dönülür.
  void _selectTab(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: [
          // Screen 1 ve Screen 3 sonraki aşamada eklenecek.
          const _ComingSoonTab(title: 'World Map', icon: Icons.public),
          const _ComingSoonTab(title: 'Continents', icon: Icons.map_outlined),
          MyCountriesScreen(
            travelData: widget.travelData,
            onTabSelected: _selectTab,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tabIndex,
        onTap: _selectTab,
      ),
    );
  }
}

/// Henüz eklenmemiş sekmeler için geçici ekran.
class _ComingSoonTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ComingSoonTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coming in the next step.',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
