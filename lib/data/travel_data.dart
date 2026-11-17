import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/country.dart';
import '../models/saved_country.dart';
import '../utils/country_status.dart';
import 'country_list.dart';

/// Kullanıcının bütün ülke seçimlerini tutan ortak veri sınıfı.
/// main.dart'ta tek bir nesne oluşturulur ve ekranlara constructor ile verilir,
/// böylece bütün ekranlar aynı veriyi görür.
///
/// Veri cihazda shared_preferences ile saklanır: uygulama açılırken
/// loadFromDevice() okur, her değişiklikten sonra saveToDevice() yazar.
///
/// ChangeNotifier: veri her değiştiğinde notifyListeners() çağrılır. MainShell
/// bunu dinleyip setState yapar; böylece harita, istatistikler ve liste
/// hangi ekrandan değişiklik yapılırsa yapılsın hemen güncellenir.
class TravelData extends ChangeNotifier {
  static const String _storageKey = 'saved_countries';

  final List<SavedCountry> _saved = [];

  List<SavedCountry> get savedCountries => List.unmodifiable(_saved);

  int get totalCount => _saved.length;

  int get beenCount =>
      _saved.where((saved) => saved.status == CountryStatus.been).length;

  int get wishCount =>
      _saved.where((saved) => saved.status == CountryStatus.wish).length;

  /// Gidilen ülkelerin veri setindeki yüzdesi (Wish dahil değil).
  double get worldPercent => beenCount / allCountries.length * 100;

  SavedCountry? findSaved(String code) {
    for (final saved in _saved) {
      if (saved.country.code == code) {
        return saved;
      }
    }
    return null;
  }

  /// Ülkenin mevcut durumu; kayıtlı değilse null.
  String? statusOf(String code) => findSaved(code)?.status;

  /// Ülkeyi kaydeder. Ülke zaten kayıtlıysa durumu değiştirilir, böylece bir
  /// ülke iki listede birden olamaz. Önceki durumu döndürür (yeni ise null).
  /// Not: Wish'e çevrilen ülkenin notu silinmiyor, sadece gösterilmiyor.
  String? saveCountry(Country country, String status) {
    final SavedCountry? existing = findSaved(country.code);
    String? previousStatus;
    if (existing == null) {
      _saved.add(SavedCountry(country: country, status: status));
    } else {
      previousStatus = existing.status;
      existing.status = status;
    }
    saveToDevice();
    notifyListeners();
    return previousStatus;
  }

  /// Ülkeyi listeden çıkarır; durumu ve notu birlikte silinir.
  void removeCountry(String code) {
    _saved.removeWhere((saved) => saved.country.code == code);
    saveToDevice();
    notifyListeners();
  }

  /// Notu günceller (Screen 4'teki not editörü). Not en fazla 200 karakter;
  /// sınırı TextField'daki maxLength sağlıyor. Son düzenleme tarihi de kaydedilir.
  void updateNote(String code, String note) {
    final SavedCountry? saved = findSaved(code);
    if (saved == null) {
      return;
    }
    saved.note = note;
    saved.noteUpdatedAt = DateTime.now();
    saveToDevice();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Cihazda saklama (shared_preferences)
  // Liste JSON metnine çevrilip tek bir anahtar altında saklanıyor:
  // [{"code":"DE","status":"Been","note":"...","noteUpdatedAt":"2024-09-01T..."}, ...]
  // ---------------------------------------------------------------------------

  /// Uygulama açılırken bir kere çağrılır (main.dart).
  Future<void> loadFromDevice() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonText = prefs.getString(_storageKey);
      if (jsonText == null) {
        return; // İlk açılış: henüz kayıt yok.
      }

      final List<dynamic> items = jsonDecode(jsonText) as List<dynamic>;
      _saved.clear();
      for (final item in items) {
        final Map<String, dynamic> map = item as Map<String, dynamic>;
        final Country? country = findCountryByCode(map['code'] as String);
        if (country == null) {
          continue; // Veri setinde olmayan bir kod varsa atla.
        }
        final String? updatedText = map['noteUpdatedAt'] as String?;
        _saved.add(
          SavedCountry(
            country: country,
            status: map['status'] as String,
            note: (map['note'] as String?) ?? '',
            noteUpdatedAt:
                updatedText == null ? null : DateTime.tryParse(updatedText),
          ),
        );
      }
    } catch (error) {
      // Kayıt bozuksa uygulama çökmesin, boş listeyle açılsın.
      debugPrint('Could not load saved countries: $error');
    }
  }

  /// Bütün listeyi cihaza yazar. saveCountry, removeCountry ve updateNote
  /// bunu kendisi çağırıyor.
  Future<void> saveToDevice() async {
    try {
      final List<Map<String, dynamic>> items = _saved.map((saved) {
        return <String, dynamic>{
          'code': saved.country.code,
          'status': saved.status,
          'note': saved.note,
          'noteUpdatedAt': saved.noteUpdatedAt?.toIso8601String(),
        };
      }).toList();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(items));
    } catch (error) {
      debugPrint('Could not save countries: $error');
    }
  }

  /// Wireframe'deki örnek veri: 7 Been, 5 Wish. (Sadece test için.)
  void loadSampleData() {
    // Listede sırayla eklenir; beenCodes içinde olmayanlar Wish olur.
    final List<String> beenCodes = ['DE', 'FR', 'IT', 'GR', 'NL', 'GB', 'EG'];
    final List<String> order = [
      'DE', 'FR', 'IT', 'ES', 'JP', 'GR', 'NL', 'GB', 'EG', 'BR', 'CA', 'AU',
    ];

    for (final code in order) {
      final Country? country = findCountryByCode(code);
      if (country == null) {
        continue;
      }
      final String status =
          beenCodes.contains(code) ? CountryStatus.been : CountryStatus.wish;
      _saved.add(SavedCountry(country: country, status: status));
    }

    final SavedCountry? germany = findSaved('DE');
    if (germany != null) {
      germany.note =
          'Visited in summer 2024. Loved Berlin, especially the history and the food!';
      germany.noteUpdatedAt = DateTime(2024, 9, 1);
    }
  }
}
