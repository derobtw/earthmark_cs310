/// Ülke arama kuralı. Hem Screen 2 hem Screen 5 aynı kuralı kullanır.
class SearchUtils {
  // Özel harfleri düz harfe çevirir, böylece "turkiye" yazınca "Türkiye",
  // "cote" yazınca "Côte d'Ivoire" bulunur. (Türkçe klavyede "Tü" yazmak da çalışır.)
  static const Map<String, String> _letterMap = {
    'ü': 'u',
    'ö': 'o',
    'ç': 'c',
    'ş': 's',
    'ı': 'i',
    'ğ': 'g',
    'ô': 'o',
    // Türkçe klavyedeki büyük 'İ' küçültülünce 'i' + nokta işareti olur;
    // o noktayı siliyoruz ki "İtaly" yazınca da Italy bulunsun.
    '̇': '',
  };

  static String normalize(String text) {
    String result = text.toLowerCase();
    _letterMap.forEach((special, plain) {
      result = result.replaceAll(special, plain);
    });
    return result;
  }

  /// İsim, aranan metinle başlıyorsa ya da isimdeki bir kelime onunla
  /// başlıyorsa eşleşir. "ge" -> Germany, Georgia (Algeria değil)
  /// "kor" -> North Korea, South Korea
  static bool matchesCountryName(String name, String query) {
    final String q = normalize(query.trim());
    if (q.isEmpty) {
      return true;
    }
    final String n = normalize(name);
    return n.startsWith(q) || n.contains(' $q');
  }
}
