// Earthmark için basit testler: arama kuralı ve veri mantığı.
// Çalıştırmak için: flutter test
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:earthmark/data/country_list.dart';
import 'package:earthmark/data/travel_data.dart';
import 'package:earthmark/models/country.dart';
import 'package:earthmark/utils/country_status.dart';
import 'package:earthmark/utils/search_utils.dart';

void main() {
  test('Dataset has 195 countries', () {
    expect(allCountries.length, 195);
  });

  test('Search matches the start of a word and special letters', () {
    expect(SearchUtils.matchesCountryName('Germany', 'ge'), isTrue);
    expect(SearchUtils.matchesCountryName('Algeria', 'ge'), isFalse);
    expect(SearchUtils.matchesCountryName('South Korea', 'kor'), isTrue);
    expect(SearchUtils.matchesCountryName('Türkiye', 'turkiye'), isTrue);
  });

  test('A country is never in both lists', () {
    SharedPreferences.setMockInitialValues({});
    final TravelData data = TravelData();
    final Country spain = findCountryByCode('ES')!;

    data.saveCountry(spain, CountryStatus.wish);
    data.saveCountry(spain, CountryStatus.been);

    expect(data.totalCount, 1);
    expect(data.beenCount, 1);
    expect(data.wishCount, 0);
  });

  test('Removing a country clears it', () {
    SharedPreferences.setMockInitialValues({});
    final TravelData data = TravelData();
    final Country japan = findCountryByCode('JP')!;

    data.saveCountry(japan, CountryStatus.been);
    data.updateNote('JP', 'Cherry blossoms!');
    data.removeCountry('JP');

    expect(data.totalCount, 0);
    expect(data.findSaved('JP'), isNull);
  });
}
