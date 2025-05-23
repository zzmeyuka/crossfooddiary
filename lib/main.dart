import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'firebase_options.dart';
import 'theme_provider.dart';
import 'locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/calendar_screen.dart';
import 'screens/settings_page.dart';
import 'screens/about_page.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('local_data'); // одна "коробка" для локальных данных

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const FoodDiaryApp(),
    ),
  );
}

class FoodDiaryApp extends StatelessWidget {
  const FoodDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LocaleProvider, AuthProvider>(
      builder: (context, themeProvider, localeProvider, authProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food Diary',
          themeMode: authProvider.themeMode,
          locale: Locale(authProvider.languageCode),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.pinkAccent,
              secondary: Colors.purpleAccent,
              background: Color(0xFFFFF0F6),
            ),
            scaffoldBackgroundColor: const Color(0xFFFFF0F6),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.pinkAccent,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black87),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              secondary: Colors.pinkAccent,
              background: Color(0xFF1E1B2E),
            ),
            scaffoldBackgroundColor: const Color(0xFF1E1B2E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.pinkAccent,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white70),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/calendar': (context) => const CalendarScreen(),
            '/settings': (context) => const SettingsPage(),
            '/about': (context) => const AboutPage(),
            '/profile': (context) => const ProfileScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
          },
        );
      },
    );
  }
}
