import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:permission_handler/permission_handler.dart';

import '../widgets/snackbars.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tzData.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // ✅ Pre-create channel so Android doesn’t block notifications silently
    const androidChannel = AndroidNotificationChannel(
      'live_room_channel',
      'Live Room Notifications',
      description: 'Notifications for upcoming live room sessions',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      print('Notification tapped with payload: ${response.payload}');
      // Handle navigation here if needed
    }
  }

  Future<bool> requestPermissions() async {
    bool permissionGranted = false;

    if (Platform.isAndroid) {
      final androidImpl = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        await Permission.scheduleExactAlarm.request();
        permissionGranted = granted ?? false;
      }
    } else if (Platform.isIOS) {
      final iosImpl = _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      permissionGranted = await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    }

    // --- SHOW SNACKBAR IF GRANTED ---
    if (permissionGranted) {
      CustomSnackBar.success(message: "Notifications enabled already");
    }

    return permissionGranted;
  }


  Future<void> cancelNotification(int id) async => _notifications.cancel(id);

  Future<void> cancelAllNotifications() async => _notifications.cancelAll();
}