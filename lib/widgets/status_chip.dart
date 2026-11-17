import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/country_status.dart';

/// Kartlardaki küçük "✓ Been" / "Wish" etiketi.
class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isBeen = status == CountryStatus.been;
    final Color mainColor = isBeen ? AppColors.been : AppColors.wish;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isBeen ? AppColors.beenChip : AppColors.wishChip,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBeen ? Icons.check : Icons.bookmark_border,
            size: 14,
            color: mainColor,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
