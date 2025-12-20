import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final String time;
  final String? badge;

  NotificationItem({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.message,
    required this.time,
    this.badge,
  });
}
