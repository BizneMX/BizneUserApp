import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppState {
  foreground,
  background,
  terminated,
}

class PushNotifications {
  PushNotifications._();

  factory PushNotifications() => _instance;

  static final PushNotifications _instance = PushNotifications._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings =
      const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
          iOS: DarwinInitializationSettings());

  /// Function to setup up push notifications and its configurations
  Future<PushNotifications> init() async {
    await _setFCMToken();
    _configure();

    return this;
  }

  /// Function to ask user for push notification permissions and if provided, save FCM Token in persisted local storage.
  Future<void> _setFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// requesting permission for [alert], [badge] & [sound]. Only for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// saving token only if user granted access.
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String token = (await messaging.getToken())!;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('fcmToken', token);
    }
  }

  /// Function to configure the functionality of displaying and tapping on notifications.
  void _configure() async {
    /// For iOS only, setting values to show the notification when the app is in foreground state.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // initializing the plugin with the settings
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    /// handler when notification arrives. This handler is executed only
    /// when notification arrives in foreground state.
    /// For iOS, OS handles the displaying of notification
    /// For Android, we push local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (GetPlatform.isIOS) {
        _showForegroundNotificationInIOS(message);
      } else {
        _showForegroundNotificationInAndroid(message);
      }
    });

    /// handler when user taps on the notification.
    /// For iOS, it gets executed when the app is in [foreground] / [background] state.
    /// For Android, it gets executed when the app is in [background] state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message: message.data, appState: AppState.background);
    });

    /// If the app is launched from terminated state by tapping on a notification, [getInitialMessage] function will return the
    /// [RemoteMessage] only once.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    /// if [RemoteMessage] is not null, this means that the app is launched from terminated state by tapping on the notification.
    if (initialMessage != null) {
      _handleNotification(
          message: initialMessage.data, appState: AppState.terminated);
    }
  }

  void _showForegroundNotificationInAndroid(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
              android: AndroidNotificationDetails('mx.devbizne.bizne', 'Bizne',
                  icon: '@mipmap/launcher_icon',
                  priority: Priority.high,
                  importance: Importance.max,
                  ticker: 'ticker')));
    }
  }

  void _showForegroundNotificationInIOS(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {}
  }

  void _handleNotification({
    required Map<String, dynamic> message,
    required AppState appState,
  }) async {
    await NotificationHandler.service.handleNotification(message, appState);
  }
}

class NotificationHandler {
  static NotificationHandler get service => Get.find();
  ValueNotifier<int> recolectionId = ValueNotifier<int>(-1);

  Future<NotificationHandler> init() async {
    return this;
  }

  Future handleNotification(
      Map<String, dynamic> message, AppState appState) async {
    if (appState == AppState.background) {
    } else {}
  }
}
