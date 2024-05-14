import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> onBackgroundMessage(RemoteMessage message) async {
  if (!Platform.isIOS) {
    await Firebase.initializeApp();
  }
  print('totototototo data: ${message.data}');
  print('totototototo notification: ${message.notification}');
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final messageCtlr = StreamController<RemoteMessage>.broadcast();
  final dataCtlr = StreamController<dynamic>.broadcast();
  final notificationCtlr = StreamController<dynamic>.broadcast();

  subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<String> getToken() async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        messageCtlr.sink.add(message);
        dataCtlr.sink.add(message.data);
        notificationCtlr.sink.add(message.notification);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey('route') && message.data.containsKey('id')) {
        // Get.toNamed(message.data['route'], arguments: {'post': message.data['id']},);
        Get.toNamed(message.data['route']);
      }
    });

    // With this token you can test it easily on your phone
    final token = await _firebaseMessaging.getToken().then((value) => value);
    return token!;
  }

  dispose() {
    messageCtlr.close();
    dataCtlr.close();
    notificationCtlr.close();
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '0',
      'general',
      // channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _localNotificationsPlugin.show(
      id,
      message.notification!.title!,
      message.notification!.body!.substring(0, message.notification!.body!.length > 50 ? 50 : message.notification!.body!.length),
      notificationDetails,
      payload: message.data.containsKey('id') ? '${message.data['id']}' : null,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('totototototo payload: ${payload}');
    }
  }
}
