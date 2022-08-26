import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:steak_finder/nav.dart';
import 'package:steak_finder/services/local_auth.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            title: 'Steak Finder',
            theme: ThemeData(primarySwatch: Colors.red),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: Nav(),
          );
        });
  }
}
