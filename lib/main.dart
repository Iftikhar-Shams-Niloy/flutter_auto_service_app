import 'package:flutter/material.dart';
import 'package:flutter_auto_service_app/screens/auth_screen.dart';
import 'package:flutter_auto_service_app/screens/dashboard_screen.dart';
import 'package:flutter_auto_service_app/screens/home_screen.dart';
import 'package:flutter_auto_service_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Service',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const DashboardScreen(),
    );
  }
}
