import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../models/saved_country.dart';
import '../navigation/app_navigator.dart';
import '../utils/app_theme.dart';
import '../utils/country_status.dart';
import '../utils/search_utils.dart';
import '../widgets/add_country_button.dart';
import '../widgets/app_logo_header.dart';
import '../widgets/country_card.dart';
import '../widgets/remove_country_dialog.dart';

/// SCREEN 5 · My Countries
/// Kaydedilen bütün ülkeler kart halinde. Filtre (All/Been/Wish), arama,
/// ülke ekleme ve silme bu ekranda. Alt menü MainShell'de.
class MyCountriesScreen extends StatefulWidget {
  final TravelData travelData;
  final void Function(int tabIndex) onTabSelected;

  const MyCountriesScreen({
    super.key,
    required this.travelData,
    required this.onTabSelected,
  });

  @override
  State<MyCountriesScreen> createState() => _MyCountriesScreenState();
}

class _MyCountriesScreenState extends State<MyCountriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filtre değerleri: 'All', CountryStatus.been, CountryStatus.wish
  static const String _all = 'All';
  String _filter = _all;
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Seçili filtreye ve arama metnine uyan ülkeler.
  List<SavedCountry> get _visibleCountries {
    return widget.travelData.savedCountries.where((saved) {
      final bool matchesFilter = _filter == _all || saved.status == _filter;
      final bool matchesSearch =
          SearchUtils.matchesCountryName(saved.country.name, _searchText);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _openAddCountry() {
    // Dönüşte ayrıca setState gerekmiyor: veri değişince MainShell
    // bütün sekmeleri yeniden çiziyor.
    AppNavigator.openAddCountry(
      context,
      travelData: widget.travelData,
      onTabSelected: widget.onTabSelected,
    );
  }

  /// Kart → Screen 4. Not ikonu → Screen 4 + not editörü.
  void _openDetails(SavedCountry saved, {bool openNoteEditor = false}) {
    AppNavigator.openCountryDetails(
      context,
      travelData: widget.travelData,
      savedCountry: saved,
      onTabSelected: widget.onTabSelected,
      openNoteEditor: openNoteEditor,
    );
  }

  void _confirmRemove(SavedCountry saved) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => RemoveCountryDialog(
        countryName: saved.country.name,
        onRemove: () {
          setState(() {
            widget.travelData.removeCountry(saved.country.code);
          });
        },
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final TravelData data = widget.travelData;
    final List<SavedCountry> countries = _visibleCountries;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogoHeader(),
              const SizedBox(height: 12),

              // 1 · Başlık ve Add Country butonu
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'My Countries',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  AddCountryButton(onPressed: _openAddCountry),
                ],
              ),
              const SizedBox(height: 14),

              // 2 · Filtre: sayılar her build'de veriden hesaplanır
              Row(
                children: [
                  Expanded(
                    child: _FilterTab(
                      label: 'All (${data.totalCount})',
                      selected: _filter == _all,
                      onTap: () => setState(() => _filter = _all),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterTab(
                      label: 'Been (${data.beenCount})',
                      selected: _filter == CountryStatus.been,
                      onTap: () => setState(() => _filter = CountryStatus.been),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterTab(
                      label: 'Wish (${data.wishCount})',
                      selected: _filter == CountryStatus.wish,
                      onTap: () => setState(() => _filter = CountryStatus.wish),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 3 · Arama alanı
              TextField(
                controller: _searchController,
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchText.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 4-5 · Ülke kartları (liste kayar, özet şeridi altta sabit kalır)
              Expanded(
                child: countries.isEmpty
                    ? _EmptyState(hasAnyCountry: data.totalCount > 0)
                    : ListView.separated(
                        itemCount: countries.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final SavedCountry saved = countries[index];
                          return CountryCard(
                            key: ValueKey(saved.country.code),
                            savedCountry: saved,
                            onTap: () => _openDetails(saved),
                            onNoteTap: () =>
                                _openDetails(saved, openNoteEditor: true),
                            onDelete: () => _confirmRemove(saved),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),

              // 6 · Özet şeridi
              _SummaryStrip(
                beenCount: data.beenCount,
                wishCount: data.wishCount,
              ),
            ],
          ),
        ),
      ),
      // 7 · Alt menü MainShell'de (Screen 1, 3 ve 5'te ortak).
    );
  }
}

/// All / Been / Wish filtre butonu.
class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final void Function() onTap;

  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.tabInactive,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

/// Listenin altındaki "7 Countries Been | 5 Countries Wish" şeridi.
class _SummaryStrip extends StatelessWidget {
  final int beenCount;
  final int wishCount;

  const _SummaryStrip({required this.beenCount, required this.wishCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.flight_takeoff,
              color: AppColors.been,
              count: beenCount,
              label: 'Countries Been',
            ),
          ),
          Container(width: 1, height: 36, color: AppColors.border),
          Expanded(
            child: _SummaryItem(
              icon: Icons.bookmark_border,
              color: AppColors.wish,
              count: wishCount,
              label: 'Countries Wish',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

/// Liste boşken gösterilen mesaj.
class _EmptyState extends StatelessWidget {
  final bool hasAnyCountry;

  const _EmptyState({required this.hasAnyCountry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        hasAnyCountry
            ? 'No countries match your search.'
            : 'No countries yet.\nTap "+ Add Country" to start your map.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
