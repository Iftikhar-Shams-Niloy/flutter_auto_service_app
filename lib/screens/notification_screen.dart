import 'package:flutter/material.dart';
import 'package:flutter_auto_service_app/theme/app_colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_auto_service_app/models/notification_item_model.dart';
import 'package:flutter_auto_service_app/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      icon: Icons.calendar_today,
      iconColor: MyAppColors.primaryBlue,
      iconBackground: const Color(0xFFE9EEFB),
      title: 'Bookings Alerts',
      message: 'Good news! Anil Kumar just booked your Convo.',
      time: '2h ago',
    ),
    NotificationItem(
      id: '2',
      icon: Icons.notifications,
      iconColor: Colors.white,
      iconBackground: MyAppColors.primaryBlue,
      title: 'Reminder',
      message: 'Tomorrow is your Convo!',
      time: '1d ago',
      badge: null,
    ),
    NotificationItem(
      id: '3',
      icon: Icons.star,
      iconColor: Colors.white,
      iconBackground: MyAppColors.primaryBlue,
      title: 'New Feature Alert',
      message: 'A new version of the app is available!',
      time: '5h ago',
      badge: 'NEW',
    ),
  ];

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: MyAppColors.textFieldBackground,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: MyAppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Slidable(
                    key: ValueKey(notification.id),
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.3,
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          _deleteNotification(notification.id);
                        },
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _deleteNotification(notification.id);
                          },
                          backgroundColor: MyAppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          icon: Icons.delete_outline,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          autoClose: true,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.3,
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          _deleteNotification(notification.id);
                        },
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _deleteNotification(notification.id);
                          },
                          backgroundColor: MyAppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          icon: Icons.delete_outline,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          autoClose: true,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        // Trigger phone notification
                        NotificationService().showNotification(
                          id: int.parse(notification.id),
                          title: notification.title,
                          body: notification.message,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: MyAppColors.primaryBlue,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: notification.iconBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      notification.icon,
                                      color: notification.iconColor,
                                      size: 24,
                                    ),
                                  ),
                                  if (notification.badge != null)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyAppColors.primaryBlue,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          notification.badge!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyAppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notification.message,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: MyAppColors.textGrey,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notification.time,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: MyAppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
