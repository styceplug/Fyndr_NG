import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyndr_ng/controllers/notification_controller.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:permission_handler/permission_handler.dart';
import '../widgets/snackbars.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("📩 BG message: ${message.messageId}");
}

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
  bool _initialized = false;
  bool _listenersAttached = false;

  int _apnsRetryCount = 0;
  Timer? _apnsRetryTimer;

  static const int _maxApnsRetries = 1;

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initializeAndSyncToken({
    required Future<void> Function({
      required String token,
      required String platform,
    })
    upsertDeviceToken,
  }) async {
    // ✅ Prevent multiple simultaneous runs
    if (_initialized) return;

    _initialized = true;

    await _initLocalNotifications();

    // ✅ Attach listeners ONCE
    if (!_listenersAttached) {
      _listenersAttached = true;

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        await _showLocal(message);

        // 🔔 update badge count when a push comes in
        try {
          Get.find<NotificationController>().refreshUnreadCount();
        } catch (_) {}
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("📲 Notification opened: ${message.data}");
        try {
          Get.find<NotificationController>().refreshUnreadCount();
        } catch (_) {}
      });

      _fcm.onTokenRefresh.listen((newToken) async {
        await upsertDeviceToken(
          token: newToken,
          platform: Platform.isIOS ? "ios" : "android",
        );
      });
    }

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print("🚀 Opened from terminated: ${initialMessage.data}");
    }

    final granted = await requestPermissions();
    if (!granted) {
      _initialized = false;
      return;
    }

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      final apnsToken = await _fcm.getAPNSToken();

      if (apnsToken == null) {
        // ✅ hard cap retries
        if (_apnsRetryCount < _maxApnsRetries) {
          _apnsRetryCount++;

          _apnsRetryTimer?.cancel();
          _apnsRetryTimer = Timer(const Duration(seconds: 5), () {
            _initialized = false; // allow retry run
            initializeAndSyncToken(upsertDeviceToken: upsertDeviceToken);
          });
        } else {
          print(
            "⚠️ APNs token not ready; giving up after $_maxApnsRetries retry.",
          );
        }

        _initialized = false;
        return;
      }

      print("✅ APNs Token ready: $apnsToken");
    }

    try {
      await _fcm.subscribeToTopic('all');
    } catch (e) {
      print("⚠️ subscribeToTopic failed: $e");
    }

    await syncFcmToken(upsertDeviceToken: upsertDeviceToken);
  }

  Future<String?> _waitForApnsToken({int maxTries = 1}) async {
    if (!Platform.isIOS) return "na";

    String? apns = await _fcm.getAPNSToken();
    int tries = 0;

    while (apns == null && tries < maxTries) {
      await Future.delayed(const Duration(milliseconds: 500));
      apns = await _fcm.getAPNSToken();
      tries++;
    }

    return apns;
  }

  Future<void> _showLocal(RemoteMessage message) async {
    final title = message.notification?.title ?? "New notification";
    final body = message.notification?.body ?? "";

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

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: buildPayload(message),
    );
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    const androidChannel = AndroidNotificationChannel(
      'default_high',
      'High Priority Notifications',
      description: 'General high priority notifications',
      importance: Importance.high,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      print('Notification tapped payload: $payload');
    }
  }

  /// Local notifications permission + FCM permission
  Future<bool> requestPermissions() async {
    bool granted = false;

    if (Platform.isAndroid) {
      final androidImpl =
          _local
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImpl != null) {
        final ok = await androidImpl.requestNotificationsPermission();
        granted = ok ?? false;
      }

      // Only if you schedule exact alarms
      await Permission.scheduleExactAlarm.request();
    } else if (Platform.isIOS) {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    }

    if (granted) {
      // CustomSnackBar.success(message: "Notifications enabled");
      print('Notifications enabled');
    } else {
      // CustomSnackBar.failure(message: "Notifications not enabled");
      print('Notifications not enabled');
    }

    return granted;
  }

  Future<void> syncFcmToken({
    required Future<void> Function({
      required String token,
      required String platform,
    })
    upsertDeviceToken,
  }) async {
    try {
      final fcmToken = await _fcm.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      await upsertDeviceToken(
        token: fcmToken,
        platform: Platform.isIOS ? "ios" : "android",
      );
    } catch (e) {
      print("❌ Token sync error: $e");
    }
  }

  Future<void> cancelNotification(int id) async => _local.cancel(id);

  Future<void> cancelAllNotifications() async => _local.cancelAll();
}
