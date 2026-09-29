import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../timetable/timetable_screen.dart';
import '../records/records_screen.dart';
import '../children/children_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  final List<BottomNavigationBarItem> _tabs = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: '일정',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.note_alt),
      label: '기록',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: '원생',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: '마이',
    ),
  ];

  final List<Widget> _screens = [
    const TimeTableScreen(),
    const RecordsScreen(),
    const ChildrenScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey[400],
        items: _tabs,
      ),
    );
  }
}
