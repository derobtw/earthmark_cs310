import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../models/saved_country.dart';
import '../screens/country_details_screen.dart';
import '../screens/country_selection_screen.dart';

/// Ortak navigasyon: Screen 2 (Add Country) ve Screen 4 (Country Details)
/// birden fazla ekrandan açıldığı için açma kodu tek yerde duruyor.
/// Alt menü sekmeleri (World, Continents, My Countries) ise MainShell'de.
class AppNavigator {
  /// "+ Add Country" butonları (Screen 1, 3, 5) → Screen 2.
  static void openAddCountry(
    BuildContext context, {
    required TravelData travelData,
    required void Function(int tabIndex) onTabSelected,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CountrySelectionScreen(
          travelData: travelData,
          onTabSelected: onTabSelected,
        ),
      ),
    );
  }

  /// Ülke kartı (Screen 5) → Screen 4. Not ikonu için openNoteEditor: true.
  static void openCountryDetails(
    BuildContext context, {
    required TravelData travelData,
    required SavedCountry savedCountry,
    required void Function(int tabIndex) onTabSelected,
    bool openNoteEditor = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CountryDetailsScreen(
          travelData: travelData,
          savedCountry: savedCountry,
          onTabSelected: onTabSelected,
          openNoteEditor: openNoteEditor,
        ),
      ),
    );
  }
}
