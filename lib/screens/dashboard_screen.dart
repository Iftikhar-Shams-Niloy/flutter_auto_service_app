import 'package:flutter/material.dart';
import 'package:flutter_auto_service_app/screens/notification_screen.dart';
import 'package:flutter_auto_service_app/screens/profile_screen.dart';
import 'package:flutter_auto_service_app/theme/app_colors.dart';
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
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
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
          selectedItemColor: MyAppColors.primaryBlue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/icons/dash_home_inactive_icon.png"),
                height: 24,
                width: 24,
              ),
              activeIcon: Image(
                image: AssetImage("assets/icons/dash_home_active_icon.png"),
                height: 24,
                width: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/icons/dash_noti_inactive_icon.png"),
                height: 24,
                width: 24,
              ),
              activeIcon: Image(
                image: AssetImage("assets/icons/dash_noti_active_icon.png"),
                height: 24,
                width: 24,
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(
                  "assets/icons/dash_profile_inactive_icon.png",
                ),
                height: 24,
                width: 24,
              ),
              activeIcon: Image(
                image: AssetImage("assets/icons/dash_profile_active_icon.png"),
                height: 24,
                width: 24,
              ),

              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
