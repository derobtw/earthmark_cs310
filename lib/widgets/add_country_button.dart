import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// "+ Add Country" butonu. Screen 1, 3 ve 5'te aynı buton kullanılır,
/// hepsi Screen 2'yi (CountrySelectionScreen) açar.
class AddCountryButton extends StatelessWidget {
  final void Function() onPressed;

  const AddCountryButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 18),
          SizedBox(width: 4),
          Text('Add Country', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
