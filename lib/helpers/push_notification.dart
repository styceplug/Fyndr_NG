import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyndr_ng/controllers/notification_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/snackbars.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String buildPayload(RemoteMessage message) {
  final data = {
    "messageId": message.messageId,
    "data": message.data,
    "title": message.notification?.title,
    "body": message.notification?.body,
  };
  return jsonEncode(data);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  Future<bool> requestPermissions() => _requestPermissions();
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool _initialized = false;


  void _goToNotificationsScreen() {
    // Prevent pushing duplicate routes repeatedly
    if (Get.currentRoute != AppRoutes.notificationScreen) {
      Get.toNamed(AppRoutes.notificationScreen);
    }
  }


  Future<void> init({
    required Future<void> Function({
    required String token,
    required String platform,
    }) upsertDeviceToken,
    Future<void> Function(RemoteMessage message)? onTap,
  }) async {
    if (_initialized) return;
    _initialized = true;

    await _initLocalNotifications(onTap: onTap);

    final granted = await _requestPermissions();
    if (!granted) return;

    // iOS: allow showing notifications while app is in foreground
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ FOREGROUND: show local notification so user sees it instantly
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("📩 FG message: ${message.messageId} | data: ${message.data}");
      // await _showLocal(message);

      try { Get.find<NotificationController>().refreshUnreadCount(); } catch (_) {}
      try { Get.find<AuthController>().chatUnreadCount.value++; } catch (_) {}
    });

    // ✅ BACKGROUND → OPENED BY TAP
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("📲 Opened from background: ${message.data}");
      if (onTap != null) await onTap(message);
      _goToNotificationsScreen();
      Get.toNamed(AppRoutes.notificationScreen);
      try { Get.find<NotificationController>().refreshUnreadCount(); } catch (_) {}

    });

    // ✅ TERMINATED → OPENED BY TAP
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print("🚀 Opened from terminated: ${initialMessage.data}");
      if (onTap != null) await onTap(initialMessage);
      _goToNotificationsScreen();
      try { Get.find<NotificationController>().refreshUnreadCount(); } catch (_) {}
    }

    // ✅ Token sync
    await _syncFcmToken(upsertDeviceToken: upsertDeviceToken);

    _fcm.onTokenRefresh.listen((newToken) async {
      await upsertDeviceToken(
        token: newToken,
        platform: Platform.isIOS ? "ios" : "android",
      );
    });
  }

  Future<void> _syncFcmToken({
    required Future<void> Function({
    required String token,
    required String platform,
    }) upsertDeviceToken,
  }) async {
    try {
      // ✅ iOS: Wait for APNs token before asking for FCM token
      if (Platform.isIOS) {
        String? apns = await _fcm.getAPNSToken();
        int tries = 0;

        while (apns == null && tries < 10) {
          await Future.delayed(const Duration(milliseconds: 500));
          apns = await _fcm.getAPNSToken();
          tries++;
        }

        if (apns == null) {
          print("⚠️ APNs token not ready. Skipping FCM token sync for now.");
          return;
        }

        print("✅ APNs token ready: $apns");
      }

      final token = await _fcm.getToken();
      if (token == null || token.isEmpty) return;

      print("✅ CURRENT DEVICE FCM TOKEN: $token");

      await upsertDeviceToken(
        token: token,
        platform: Platform.isIOS ? "ios" : "android",
      );
    } catch (e) {
      print("❌ Token sync error: $e");
    }
  }


  Future<void> _showLocal(RemoteMessage message) async {
    final title = message.notification?.title ?? "New notification";
    final body  = message.notification?.body ?? "";

    const androidDetails = AndroidNotificationDetails(
      'default_high',
      'High Priority Notifications',
      channelDescription: 'General high priority notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: buildPayload(message),
    );
  }

  Future<void> _initLocalNotifications({
    Future<void> Function(RemoteMessage message)? onTap,
  }) async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;

        final decoded = jsonDecode(payload) as Map<String, dynamic>;
        final data = Map<String, dynamic>.from(decoded['data'] ?? {});

        // Turn payload back into something your routing can use.
        // If you prefer, you can route directly using `data`.
        final fakeMsg = RemoteMessage(data: data);

        print("🔔 Local notification tapped: $data");
        if (onTap != null) await onTap(fakeMsg);
        _goToNotificationsScreen();
        try { Get.find<NotificationController>().refreshUnreadCount(); } catch (_) {}
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'default_high',
      'High Priority Notifications',
      description: 'General high priority notifications',
      importance: Importance.high,
    );

    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImpl =
      _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final ok = await androidImpl?.requestNotificationsPermission();
      print(ok == true ? "Notifications enabled" : "Notifications not enabled");
      return ok ?? false;
    } else {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      print(granted ? "Notifications enabled" : "Notifications not enabled");
      return granted;
    }
  }
}
