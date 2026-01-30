import 'package:flutter/material.dart';
import '../screens/calendar_screen.dart';
import '../screens/profile_screen.dart';

class BottomNav extends StatelessWidget {
  final int current;
  const BottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current,
      onTap: (i) {
        if (i == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()));
        }
        if (i == 3) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Календарь'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: 'Статистика'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Профиль'),
      ],
    );
  }
}
