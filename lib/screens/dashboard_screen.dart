import 'package:flutter/material.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Text("Notification Screen"),
    const Text("Profile Screen"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/icons/dash_home_inactive_icon.png"),
              ),
              activeIcon: Image(
                image: AssetImage("assets/icons/dash_home_active_icon.png"),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/icons/dash_noti_inactive_icon.png"),
              ),
              activeIcon: Image(
                image: AssetImage("assets/icons/dash_noti_active_icon.png"),
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(
                  "assets/icons/dash_profile_inactive_icon.png",
                ),
              ),
              activeIcon: Image(
                image: AssetImage("assets/icons/dash_profile_active_icon.png"),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
