import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../models/saved_country.dart';

/// Ortak navigasyon: Screen 2 (Add Country) ve Screen 4 (Country Details)
/// birden fazla ekrandan açıldığı için açma kodu tek yerde duruyor.
/// Alt menü sekmeleri (World, Continents, My Countries) ise MainShell'de.
///
/// Bu aşamada Screen 2 ve Screen 4 henüz yok; butonlar kısa bir bilgi
/// mesajı gösteriyor. Ekranlar eklenince sadece bu dosya değişecek.
class AppNavigator {
  /// "+ Add Country" butonları (Screen 1, 3, 5) → Screen 2.
  static void openAddCountry(
    BuildContext context, {
    required TravelData travelData,
    required void Function(int tabIndex) onTabSelected,
  }) {
    _showComingSoon(context, 'Add Country (Screen 2)');
  }

  /// Ülke kartı (Screen 5) → Screen 4. Not ikonu için openNoteEditor: true.
  static void openCountryDetails(
    BuildContext context, {
    required TravelData travelData,
    required SavedCountry savedCountry,
    required void Function(int tabIndex) onTabSelected,
    bool openNoteEditor = false,
  }) {
    _showComingSoon(context, '${savedCountry.country.name} details (Screen 4)');
  }

  static void _showComingSoon(BuildContext context, String screenName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$screenName will be added in the next step.')),
    );
  }
}
