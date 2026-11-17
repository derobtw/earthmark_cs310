/// Uygulamadaki sabit ülke bilgisi (veri setinden gelir, değişmez).
class Country {
  final String code; // ISO alpha-2, örn. 'DE'
  final String name;
  final String continent;
  final String flag; // bayrak emojisi

  const Country({
    required this.code,
    required this.name,
    required this.continent,
    required this.flag,
  });
}
