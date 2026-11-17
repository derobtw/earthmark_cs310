import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// "Remove Germany?" onay penceresi (wireframe durum C).
/// Screen 5'teki çöp kutusu ve Screen 4'teki "Remove from My Countries"
/// butonu bu pencereyi kullanır.
///
/// Kullanım:
///   showDialog(
///     context: context,
///     builder: (context) => RemoveCountryDialog(
///       countryName: 'Germany',
///       onRemove: () { ... },
///     ),
///   );
class RemoveCountryDialog extends StatelessWidget {
  final String countryName;
  final void Function() onRemove;

  const RemoveCountryDialog({
    super.key,
    required this.countryName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.errorLight,
        child: Icon(Icons.priority_high, color: AppColors.error),
      ),
      title: Text(
        'Remove $countryName?',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Its status and note will be cleared from My Countries.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textMuted),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                // Cancel: kayıt olduğu gibi kalır.
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                // Önce pencereyi kapat, sonra silme işini yapan callback'i çağır.
                onPressed: () {
                  Navigator.pop(context);
                  onRemove();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
