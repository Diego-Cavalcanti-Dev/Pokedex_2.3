import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/theme_service.dart';
import 'screens/login_screen.dart';

final ThemeService themeService = ThemeService();
final ValueNotifier<bool> temaEscuroNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await themeService.init();
  temaEscuroNotifier.value = themeService.obterTemaEscuro();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: temaEscuroNotifier,
      builder: (context, temaEscuro, child) {
        return MaterialApp(
          title: 'Pokédex',
          debugShowCheckedModeBanner: false,
          themeMode: temaEscuro ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primarySwatch: Colors.red,
            useMaterial3: false,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.red,
            useMaterial3: false,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              foregroundColor: Colors.white,
            ),
            cardColor: const Color(0xFF1F1F1F),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
