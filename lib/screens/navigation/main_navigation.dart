import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// routes ito para sa screens
import '../home/Home_screen.dart';
import '../borrow/borrow_status_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  int? studentId;

  @override
  void initState() {
    super.initState();
    loadStudent();
  }

  Future<void> loadStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('student_id');

    setState(() {
      studentId = id;
    });
  }

  void selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (studentId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> screens = [
      const HomeScreen(),
      BorrowStatusScreen(studentId: studentId!),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: selectIndex,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Items"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Requests",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
