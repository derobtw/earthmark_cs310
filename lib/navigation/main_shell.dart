import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../screens/continent_map_screen.dart';
import '../screens/home_screen.dart';
import '../screens/my_countries_screen.dart';
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
  int _tabIndex = AppBottomNav.worldTab;

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
          HomeScreen(
            travelData: widget.travelData,
            onTabSelected: _selectTab,
          ),
          ContinentMapScreen(
            travelData: widget.travelData,
            onTabSelected: _selectTab,
          ),
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
