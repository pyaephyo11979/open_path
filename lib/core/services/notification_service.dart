import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_path/core/services/api_service.dart';
import 'package:open_path/core/services/secure_storage_service.dart';
import 'package:open_path/repositories/notification_api.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final List<RemoteMessage> _notifications = [];
  List<RemoteMessage> get notifications => List.unmodifiable(_notifications);

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'open_path_notifications',
    'Open Path Notifications',
    description: 'Notifications from Open Path',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await _requestPermission();
    await _setupLocalNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    _messaging.onTokenRefresh.listen(_handleTokenRefresh);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _notifications.insert(0, initialMessage);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(settings: initSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _notifications.insert(0, message);
    _showLocalNotification(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    _notifications.insert(0, message);
  }

  Future<void> _handleTokenRefresh(String newToken) async {
    log('FCM token refreshed');
    try {
      final authToken = await SecureStorageService().getAuthToken();
      if (authToken != null && authToken.isNotEmpty) {
        await NotificationRepository(APIService()).updateFcmToken(newToken);
        log('Refreshed FCM token registered successfully');
      }
    } catch (e) {
      log('Failed to register refreshed FCM token: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      payload: message.data['route'],
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<String?> getFcmToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      try {
        String? apnsToken = await _messaging.getAPNSToken();
        int retryCount = 0;

        while (apnsToken == null && retryCount < 5) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await _messaging.getAPNSToken();
          retryCount++;
        }

        if (apnsToken == null) {
          log('APNS token not available on iOS after retrying.');
          return null;
        }
      } catch (e) {
        log('Error checking APNS token: $e');
        return null;
      }
    }

    try {
      final token = await _messaging.getToken();
      log('FCM Token: $token');
      return token;
    } catch (e) {
      log('Failed to retrieve FCM token: $e');
      return null;
    }
  }

  void clearNotifications() {
    _notifications.clear();
  }
}
