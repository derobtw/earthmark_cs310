import 'package:flutter/material.dart';

import 'data/travel_data.dart';
import 'navigation/main_shell.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  // runApp'ten önce bir paket (shared_preferences) kullanacağımız için gerekli.
  WidgetsFlutterBinding.ensureInitialized();

  // Bütün ekranların paylaştığı tek veri nesnesi.
  final TravelData travelData = TravelData();

  // Cihazda daha önce kaydedilmiş ülkeleri oku (ilk açılışta liste boş gelir).
  await travelData.loadFromDevice();

  // Örnek veriyle (7 Been, 5 Wish) test etmek için alttaki satırı aç:
  // travelData.loadSampleData();

  runApp(EarthmarkApp(travelData: travelData));
}

class EarthmarkApp extends StatelessWidget {
  final TravelData travelData;

  const EarthmarkApp({super.key, required this.travelData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthmark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Açılış: alt menülü ana ekran, ilk sekme World (Screen 1).
      home: MainShell(travelData: travelData),
    );
  }
}
