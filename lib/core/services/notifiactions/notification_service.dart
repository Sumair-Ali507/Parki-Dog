import 'dart:io';
import 'dart:ui';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../features/chat/view/widget/custom_notification_widget.dart';

class NotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  NotificationService() {
    initializePlatformNotifications();
  }
  final text = Platform.isIOS;

  final _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'parki_dog',
      'Parki Dog Notification Channel',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: Color(0xff2196f3),
    );

    DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails(threadIdentifier: "thread1");

    await _localNotifications.getNotificationAppLaunchDetails();
    // if (details != null && details.didNotificationLaunchApp) {
    //   behaviorSubject.add(details.payload!);
    // }

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User greanted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("provensinal");
    } else {
      print("user denied");
    }
  }

  // Future<NotificationDetails> _groupedNotificationDetails() async {
  //   const List<String> lines = <String>[
  //     'group 1 First drink',
  //     'group 1   Second drink',
  //     'group 1   Third drink',
  //     'group 2 First drink',
  //     'group 2   Second drink'
  //   ];
  //   const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
  //       lines,
  //       contentTitle: '5 messages',
  //       summaryText: 'missed drinks');
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       const AndroidNotificationDetails(
  //     'channel id',
  //     'channel name',
  //     groupKey: 'com.example.flutter_push_notifications',
  //     channelDescription: 'channel description',
  //     setAsGroupSummary: true,
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     playSound: true,
  //     ticker: 'ticker',
  //     styleInformation: inboxStyleInformation,
  //     color: Color(0xff2196f3),
  //   );

  //   const IOSNotificationDetails iosNotificationDetails =
  //       IOSNotificationDetails(threadIdentifier: "thread2");

  //   final details = await _localNotifications.getNotificationAppLaunchDetails();
  //   if (details != null && details.didNotificationLaunchApp) {
  //     behaviorSubject.add(details.payload!);
  //   }

  //   NotificationDetails platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

  //   return platformChannelSpecifics;
  // }

  // Future<void> showScheduledLocalNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required String payload,
  //   required int seconds,
  // }) async {
  //   final platformChannelSpecifics = await _notificationDetails();
  //   await _localNotifications.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
  //     platformChannelSpecifics,
  //     payload: payload,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    // required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      // payload: payload,
    );
  }

  // Future<void> showPeriodicLocalNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   final platformChannelSpecifics = await _notificationDetails();
  //   await _localNotifications.periodicallyShow(
  //     id,
  //     title,
  //     body,
  //     RepeatInterval.everyMinute,
  //     platformChannelSpecifics,
  //     payload: payload,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  // Future<void> showGroupedNotifications({
  //   required String title,
  // }) async {
  //   final platformChannelSpecifics = await _notificationDetails();
  //   final groupedPlatformChannelSpecifics = await _groupedNotificationDetails();
  //   await _localNotifications.show(
  //     0,
  //     "group 1",
  //     "First drink",
  //     platformChannelSpecifics,
  //   );
  //   await _localNotifications.show(
  //     1,
  //     "group 1",
  //     "Second drink",
  //     platformChannelSpecifics,
  //   );
  //   await _localNotifications.show(
  //     3,
  //     "group 1",
  //     "Third drink",
  //     platformChannelSpecifics,
  //   );
  //   await _localNotifications.show(
  //     4,
  //     "group 2",
  //     "First drink",
  //     Platform.isIOS
  //         ? groupedPlatformChannelSpecifics
  //         : platformChannelSpecifics,
  //   );
  //   await _localNotifications.show(
  //     5,
  //     "group 2",
  //     "Second drink",
  //     Platform.isIOS
  //         ? groupedPlatformChannelSpecifics
  //         : platformChannelSpecifics,
  //   );
  //   await _localNotifications.show(
  //     6,
  //     Platform.isIOS ? "group 2" : "Attention",
  //     Platform.isIOS ? "Third drink" : "5 missed drinks",
  //     groupedPlatformChannelSpecifics,
  //   );
  // }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    // print('id $id');
  }

  // void selectNotification(String? payload) {
  //   if (payload != null && payload.isNotEmpty) {
  //     behaviorSubject.add(payload);
  //   }
  // }

  static Future<bool> sendFcmNotification({
    required String title,
    required String body,
    required String token,
    required String photoUrl,
  }) async {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable('sendNotification');

    try {
      final response = await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'token': token,
        'photoUrl': photoUrl,
      });

      // debugPrint('result is ${response.data ?? 'No data came back'}');

      if (response.data == null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  void cancelAllNotifications() => _localNotifications.cancelAll();

  static handleMessageReseved({required BuildContext context}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomNotificationWidget(imageUrl: message.data['photoUrl'], message: message.data['body']),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomNotificationWidget(imageUrl: message.data['photoUrl'], message: message.data['body']),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ));
    });

    FirebaseMessaging.onBackgroundMessage(
      (message) async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomNotificationWidget(imageUrl: message.data['photoUrl'], message: message.data['body']),
          duration: const Duration(seconds: 2), // Adjust the duration as needed
        ));
      },
    );
  }
}
