import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        // BottomNavigationBarItem(
        //  icon: Icon(Icons.calendar_month),
        //  label: 'Calendar',
        //),
        // BottomNavigationBarItem(
        //  icon: Icon(Icons.map),
        //  label: 'Map',
        //),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),

        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Assist'),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.unselectedItemColor,
      onTap: onItemTapped,
    );
  }
}
