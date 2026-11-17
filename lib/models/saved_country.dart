import '../utils/country_status.dart';
import 'country.dart';

/// Kullanıcının kaydettiği bir ülke: hangi ülke, durumu (Been/Wish) ve notu.
class SavedCountry {
  final Country country;
  String status; // CountryStatus.been veya CountryStatus.wish
  String note; // sadece Been ülkelerde gösterilir (Screen 4)
  DateTime? noteUpdatedAt;

  SavedCountry({
    required this.country,
    required this.status,
    this.note = '',
    this.noteUpdatedAt,
  });

  bool get isBeen => status == CountryStatus.been;
}
