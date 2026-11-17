import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Harita renk açıklaması: Been / Wish / Not selected.
/// Screen 1 ve Screen 3'te aynı.
class MapLegend extends StatelessWidget {
  final String unselectedLabel;

  const MapLegend({super.key, this.unselectedLabel = 'Not selected'});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 6,
      children: [
        const _LegendItem(color: AppColors.been, label: 'Been'),
        const _LegendItem(color: AppColors.wish, label: 'Wish'),
        _LegendItem(color: AppColors.mapUnselected, label: unselectedLabel),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
        ),
      ],
    );
  }
}
