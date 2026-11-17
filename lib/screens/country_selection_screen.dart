import 'package:flutter/material.dart';

import '../data/country_list.dart';
import '../data/travel_data.dart';
import '../models/country.dart';
import '../models/saved_country.dart';
import '../utils/app_theme.dart';
import '../utils/country_status.dart';
import '../utils/search_utils.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/save_confirmation_dialog.dart';
import 'country_details_screen.dart';

/// SCREEN 2 · Country Selection (Add Country formu)
/// Kullanıcı listeden bir ülke ve bir durum (Been/Wish) seçip kaydeder.
/// Screen 1, 3 ve 5'teki "+ Add Country" butonları bu ekranı açar.
class CountrySelectionScreen extends StatefulWidget {
  final TravelData travelData;
  final void Function(int tabIndex) onTabSelected;

  const CountrySelectionScreen({
    super.key,
    required this.travelData,
    required this.onTabSelected,
  });

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  Country? _selectedCountry;
  String? _selectedStatus;

  // Hata mesajları sadece kullanıcı bir kere Save'e bastıktan sonra görünür.
  bool _triedToSave = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Country> get _filteredCountries {
    return allCountries
        .where((country) =>
            SearchUtils.matchesCountryName(country.name, _searchText))
        .toList();
  }

  bool get _showCountryError => _triedToSave && _selectedCountry == null;
  bool get _showStatusError => _triedToSave && _selectedStatus == null;

  void _saveCountry() {
    setState(() {
      _triedToSave = true;
    });

    // Yerel değişkenlere alınca Dart null kontrolünden sonra bunların
    // null olmadığını biliyor, ! kullanmaya gerek kalmıyor.
    final Country? country = _selectedCountry;
    final String? status = _selectedStatus;
    if (country == null || status == null) {
      return; // Geçersiz form: kullanıcı ekranda kalır, hatalar görünür.
    }

    final String? previousStatus =
        widget.travelData.saveCountry(country, status);
    _showSavedDialog(country, status, previousStatus);
  }

  String _savedMessage(Country country, String status, String? previous) {
    if (previous == null) {
      return '${country.name} was added as $status.';
    }
    if (previous == status) {
      return '${country.name} is already marked as $status.';
    }
    return '${country.name} was moved from $previous to $status.';
  }

  void _showSavedDialog(Country country, String status, String? previous) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SaveConfirmationDialog(
        message: _savedMessage(country, status, previous),
        showAddNote: status == CountryStatus.been,
        onDone: () {
          // Formu kapat ve World (Screen 1) sekmesine dön.
          Navigator.pop(context);
          widget.onTabSelected(AppBottomNav.worldTab);
        },
        onAddNote: () {
          // Formun yerine Screen 4'ü aç ve not editörünü göster.
          final SavedCountry? saved = widget.travelData.findSaved(country.code);
          if (saved == null) {
            Navigator.pop(context);
            return;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => CountryDetailsScreen(
                travelData: widget.travelData,
                savedCountry: saved,
                onTabSelected: widget.onTabSelected,
                openNoteEditor: true,
              ),
            ),
          );
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
    final List<Country> countries = _filteredCountries;

    return Scaffold(
      // 1 · AppBar geri okunu otomatik koyar; kaydetmeden geri döner.
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Add Country',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a country to add to your map',
              style: TextStyle(color: AppColors.textMuted),
            ),
            const Divider(height: 28),

            // 2 · Ülke arama alanı
            const _FieldLabel(text: 'Country *'),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search country',
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 3 · Sonuç listesi (tek seçim)
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showCountryError ? AppColors.error : AppColors.border,
                  width: _showCountryError ? 1.5 : 1,
                ),
              ),
              child: countries.isEmpty
                  ? const Center(
                      child: Text(
                        'No countries found',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final Country country = countries[index];
                        return _CountryOptionTile(
                          key: ValueKey(country.code),
                          country: country,
                          isSelected: _selectedCountry?.code == country.code,
                          currentStatus:
                              widget.travelData.statusOf(country.code),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                            });
                          },
                        );
                      },
                    ),
            ),
            if (_selectedCountry != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Selected: ${_selectedCountry?.name}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (_showCountryError)
              const _ErrorText(message: 'Please choose a country.'),
            const SizedBox(height: 22),

            // 4 · Durum kartları (tam olarak biri seçili olabilir)
            const _FieldLabel(text: 'Travel Status *'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatusOptionCard(
                    title: CountryStatus.been,
                    subtitle: "I've visited",
                    color: AppColors.been,
                    lightColor: AppColors.beenLight,
                    selected: _selectedStatus == CountryStatus.been,
                    hasError: _showStatusError,
                    onTap: () {
                      setState(() {
                        _selectedStatus = CountryStatus.been;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatusOptionCard(
                    title: CountryStatus.wish,
                    subtitle: 'I want to visit',
                    color: AppColors.wish,
                    lightColor: AppColors.wishLight,
                    selected: _selectedStatus == CountryStatus.wish,
                    hasError: _showStatusError,
                    onTap: () {
                      setState(() {
                        _selectedStatus = CountryStatus.wish;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_showStatusError)
              const _ErrorText(message: 'Please choose a travel status.'),
            const SizedBox(height: 28),

            // 5 · Kaydet butonu
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveCountry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Country',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Required fields are validated before saving.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String message;

  const _ErrorText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: AppColors.error),
      ),
    );
  }
}

/// Sonuç listesindeki tek bir ülke satırı. Seçiliyse yeşil zemin ve tik.
/// Ülke zaten kayıtlıysa mevcut durumu (Been/Wish) sağda küçük yazıyla görünür;
/// kaydedince bu durum yenisiyle değişir.
class _CountryOptionTile extends StatelessWidget {
  final Country country;
  final bool isSelected;
  final String? currentStatus;
  final void Function() onTap;

  const _CountryOptionTile({
    super.key,
    required this.country,
    required this.isSelected,
    required this.currentStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String? status = currentStatus;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.beenLight : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                country.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (status != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: status == CountryStatus.been
                        ? AppColors.been
                        : AppColors.wish,
                  ),
                ),
              ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.been : AppColors.unselected,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

/// Been / Wish seçim kartı.
class _StatusOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Color lightColor;
  final bool selected;
  final bool hasError;
  final void Function() onTap;

  const _StatusOptionCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.lightColor,
    required this.selected,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    if (selected) {
      borderColor = color;
    } else if (hasError) {
      borderColor = AppColors.error;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? lightColor : const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: selected || hasError ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (selected) Icon(Icons.check, color: color, size: 18),
                if (selected) const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
