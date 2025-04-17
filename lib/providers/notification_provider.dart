import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/habit_model.dart';

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notifications;
  bool _isInitialized = false;

  NotificationProvider(this._notifications) {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _isInitialized = true;
  }

  Future<void> scheduleTaskReminder(HabitTask task) async {
    if (!_isInitialized) await _initializeNotifications();

    final now = DateTime.now();
    var scheduledTime = now;

    // Set the scheduled time based on the task's frequency type
    switch (task.frequencyType) {
      case 'daily':
        scheduledTime = DateTime(now.year, now.month, now.day, 9, 0); // 9 AM
        break;
      case 'weekly':
        scheduledTime = DateTime(now.year, now.month, now.day, 9, 0)
            .add(const Duration(days: 7));
        break;
      case 'monthly':
        scheduledTime = DateTime(now.year, now.month + 1, 1, 9, 0);
        break;
    }

    // If the scheduled time is in the past, move it to the next occurrence
    if (scheduledTime.isBefore(now)) {
      switch (task.frequencyType) {
        case 'daily':
          scheduledTime = scheduledTime.add(const Duration(days: 1));
          break;
        case 'weekly':
          scheduledTime = scheduledTime.add(const Duration(days: 7));
          break;
        case 'monthly':
          scheduledTime = DateTime(now.year, now.month + 1, 1, 9, 0);
          break;
      }
    }

    final androidDetails = AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      channelDescription: 'Notifications for habit tasks',
      importance: Importance.high,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      'Don\'t forget to ${task.title}!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTaskReminder(String taskId) async {
    if (!_isInitialized) await _initializeNotifications();
    await _notifications.cancel(taskId.hashCode);
  }

  Future<void> cancelAllReminders() async {
    if (!_isInitialized) await _initializeNotifications();
    await _notifications.cancelAll();
  }
} 