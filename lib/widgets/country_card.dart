import 'package:flutter/material.dart';

import '../models/saved_country.dart';
import '../utils/app_theme.dart';
import 'status_chip.dart';

/// My Countries ekranındaki ülke kartı: bayrak, isim, kıta, durum etiketi,
/// not ikonu (sadece Been) ve çöp kutusu ikonu.
class CountryCard extends StatelessWidget {
  final SavedCountry savedCountry;
  final void Function() onTap;
  final void Function() onNoteTap;
  final void Function() onDelete;

  const CountryCard({
    super.key,
    required this.savedCountry,
    required this.onTap,
    required this.onNoteTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBeen = savedCountry.isBeen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isBeen ? AppColors.beenLight : AppColors.wishLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isBeen ? AppColors.beenBorder : AppColors.wishBorder,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Text(
                savedCountry.country.flag,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    savedCountry.country.name,
                    // Uzun isimler (ör. "Bosnia and Herzegovina") iki satıra
                    // kayar; daha da uzunsa ikinci satırın sonu "..." olur.
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 2),
                      // Flexible: "North America" gibi uzun kıta adları sığmazsa
                      // taşmak yerine "..." ile kısalır.
                      Flexible(
                        child: Text(
                          savedCountry.country.continent,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatusChip(status: savedCountry.status),
            // Not ikonu sadece Been ülkelerde var. Wish kartlarında aynı
            // genişlikte boşluk bırakılıyor ki çöp kutuları hizalı dursun.
            if (isBeen)
              IconButton(
                onPressed: onNoteTap,
                tooltip: 'Note',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.description_outlined),
                color: AppColors.textDark,
              )
            else
              const SizedBox(width: 40),
            IconButton(
              onPressed: onDelete,
              tooltip: 'Remove',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
