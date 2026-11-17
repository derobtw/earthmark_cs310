import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../navigation/app_navigator.dart';
import '../utils/app_theme.dart';
import '../utils/continents.dart';
import '../widgets/map_legend.dart';
import '../widgets/travel_map.dart';

/// SCREEN 3 · Continent Map
/// Bir kıtayı seçip haritada o kıtaya odaklanma. Renkler ve veri dünya
/// haritasıyla aynı. Alt menü MainShell'de.
class ContinentMapScreen extends StatefulWidget {
  final TravelData travelData;
  final void Function(int tabIndex) onTabSelected;

  const ContinentMapScreen({
    super.key,
    required this.travelData,
    required this.onTabSelected,
  });

  @override
  State<ContinentMapScreen> createState() => _ContinentMapScreenState();
}

class _ContinentMapScreenState extends State<ContinentMapScreen> {
  String _continent = Continents.europe;

  void _openAddCountry() {
    AppNavigator.openAddCountry(
      context,
      travelData: widget.travelData,
      onTabSelected: widget.onTabSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1 · Başlık ve + butonu (Screen 2'yi açar)
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Continents',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _openAddCountry,
                    tooltip: 'Add Country',
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                    color: AppColors.textDark,
                  ),
                ],
              ),
              const Divider(height: 20),

              // 2 · Kıta seçimi
              const Text(
                'Select a continent',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: _continent,
                  isExpanded: true,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(10),
                  items: Continents.all
                      .map(
                        (continent) => DropdownMenuItem<String>(
                          value: continent,
                          child: Text(continent),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _continent = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 14),

              // 3-4 · Kıtaya odaklanmış harita ve zoom butonları.
              // key: kıta değişince harita (ve zoom'u) sıfırdan oluşsun.
              TravelMap(
                key: ValueKey(_continent),
                travelData: widget.travelData,
                label: '$_continent Map',
                focusArea: Continents.areaOf(_continent),
                height: 290,
                showPinchHint: true,
              ),
              const SizedBox(height: 16),

              // 5 · Renk açıklaması ve not
              const Text(
                'Country status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const MapLegend(unselectedLabel: 'Unselected'),
              const SizedBox(height: 10),
              const Text(
                'Countries keep the same colors as the world map.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
