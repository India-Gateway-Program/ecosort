import 'package:ecosort/constants/borders.dart';
import 'package:ecosort/constants/colors.dart';
import 'package:ecosort/pages/assist_screen.dart';
import 'package:ecosort/pages/calendar_screen.dart';
import 'package:ecosort/pages/history_screen.dart';
import 'package:ecosort/pages/map_screen.dart';
import 'package:ecosort/pages/scan_screen.dart';
import 'package:ecosort/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HistoryScreen(),
    CalendarScreen(),
    MapScreen(),
    AssistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: _selectedIndex == 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScanScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                  ),
                  label: Text("Scan", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorders.small,
                    ),
                    padding: const EdgeInsets.all(15),
                  ),
                )
              ],
            )
          : null,
    );
  }
}
