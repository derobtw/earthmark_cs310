import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../navigation/app_navigator.dart';
import '../utils/app_theme.dart';
import '../utils/continents.dart';
import '../widgets/add_country_button.dart';
import '../widgets/map_legend.dart';
import '../widgets/stat_card.dart';
import '../widgets/travel_map.dart';

/// SCREEN 1 · Home / World Map
/// Açılış ekranı: dünya haritası, renk açıklaması ve iki istatistik kartı.
/// Alt menü MainShell'de.
class HomeScreen extends StatelessWidget {
  final TravelData travelData;
  final void Function(int tabIndex) onTabSelected;

  const HomeScreen({
    super.key,
    required this.travelData,
    required this.onTabSelected,
  });

  void _openAddCountry(BuildContext context) {
    AppNavigator.openAddCountry(
      context,
      travelData: travelData,
      onTabSelected: onTabSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Countries Visited = farklı Been ülke sayısı (Wish dahil değil).
    // World Explored = Been / veri setindeki ülke sayısı (195).
    final String explored = '${travelData.worldPercent.toStringAsFixed(1)}%';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1 · Başlık ve Add Country butonu
              Row(
                children: [
                  Image.asset('assets/images/earthmark_logo.png', height: 30),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'earthmark',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.logoGreen,
                      ),
                    ),
                  ),
                  AddCountryButton(onPressed: () => _openAddCountry(context)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'My World Map',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Your travel memories, on one map',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),

              // 2-3 · Dünya haritası ve zoom butonları
              TravelMap(
                travelData: travelData,
                label: 'World',
                focusArea: Continents.worldArea,
                height: 230,
              ),
              const SizedBox(height: 10),

              // 4 · Renk açıklaması
              const MapLegend(),
              const SizedBox(height: 16),

              // 5 · İstatistik kartları
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Countries Visited',
                      value: '${travelData.beenCount}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(title: 'World Explored', value: explored),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
