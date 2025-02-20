import 'package:ecosort/constants/colors.dart';
import 'package:ecosort/pages/assist_screen.dart';
import 'package:ecosort/pages/history_screen.dart';
import 'package:ecosort/pages/scan_screen.dart';
import 'package:ecosort/pages/splash_screen.dart';
import 'package:ecosort/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locale_switcher/locale_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

// Theme Provider using Riverpod
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', state);
  }
}

void main() {
  Gemini.init(apiKey: Config.geminiAPIToken);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return LocaleManager(
        supportedLocales: [Locale("de"), Locale("IN")],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => SplashScreen(),
            '/main': (context) => const HomePage(),
          },
        ));
  }
}

// Light and Dark Theme Definitions
class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(color: Colors.green),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green.shade900,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(color: Colors.green.shade900),
  );
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HistoryScreen(),
    ScanScreen(),
    AssistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoSort'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
