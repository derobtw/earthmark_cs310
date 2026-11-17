import 'package:flutter/material.dart';

/// Kıta listesi ve her kıtanın dünya haritası üzerindeki alanı.
///
/// countries_world_map paketinde ayrı kıta haritaları yok; bu yüzden Screen 3
/// dünya haritasını seçilen kıtanın alanına yakınlaştırarak gösteriyor.
/// Alanlar haritanın genişliğine/yüksekliğine oranla verilmiştir (0 = sol/üst,
/// 1 = sağ/alt) ve paketin harita verisindeki ülke sınırlarından hesaplanmıştır.
class Continents {
  static const String africa = 'Africa';
  static const String asia = 'Asia';
  static const String europe = 'Europe';
  static const String northAmerica = 'North America';
  static const String southAmerica = 'South America';
  static const String oceania = 'Oceania';

  static const List<String> all = [
    africa,
    asia,
    europe,
    northAmerica,
    southAmerica,
    oceania,
  ];

  /// Bütün dünya.
  static const Rect worldArea = Rect.fromLTRB(0, 0, 1, 1);

  static const Map<String, Rect> mapAreas = {
    africa: Rect.fromLTRB(0.42, 0.30, 0.68, 0.86),
    asia: Rect.fromLTRB(0.55, 0.12, 0.92, 0.67),
    europe: Rect.fromLTRB(0.44, 0.06, 0.62, 0.39),
    northAmerica: Rect.fromLTRB(0.04, 0.0, 0.40, 0.55),
    southAmerica: Rect.fromLTRB(0.25, 0.48, 0.41, 1.0),
    oceania: Rect.fromLTRB(0.79, 0.50, 1.0, 0.95),
  };

  static Rect areaOf(String continent) => mapAreas[continent] ?? worldArea;
}
