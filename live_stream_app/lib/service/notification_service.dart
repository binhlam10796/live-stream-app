import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:live_stream_app/constants/globals.dart';
import 'package:live_stream_app/constants/keys.dart';
import 'package:live_stream_app/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:live_stream_app/modules/dashboard/model/user_noty_response.dart';

import '../modules/dashboard/model/admin_noty_response.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_app_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void unSubscribeToTopic() {
    FirebaseMessaging.instance.unsubscribeFromTopic('admin');
    FirebaseMessaging.instance.unsubscribeFromTopic(userID.toString());
  }

  void subscribeToTopic() {
    if (roles.contains('ROLE_ADMIN')) {
      FirebaseMessaging.instance.unsubscribeFromTopic('admin');
      FirebaseMessaging.instance.unsubscribeFromTopic(userID.toString());
      FirebaseMessaging.instance.subscribeToTopic('admin');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('admin');
      FirebaseMessaging.instance.unsubscribeFromTopic(userID.toString());
      FirebaseMessaging.instance.subscribeToTopic(userID.toString());
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showNotification(message);
      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
    });
  }

  Future showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'live_stream_app_channel',
      'Live Stream App Notifications',
      description: 'Project Live Stream App',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (roles.contains('ROLE_ADMIN')) {
      Body notyBody =
          Body.fromJson(jsonDecode(message.data.entries.first.value));
      String title = message.data.entries.last.value;
      AndroidNotification? android = message.notification?.android;
      flutterLocalNotificationsPlugin.show(
        100,
        "$title of ${notyBody.email}",
        notyBody.content,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android?.smallIcon,
            // other properties...
          ),
          iOS: const IOSNotificationDetails(
              presentAlert: true, presentSound: true),
        ),
        payload: 'Default_Sound',
      );
    } else {
       UserNotyResponse notyBody =
           UserNotyResponse.fromJson(jsonDecode(message.data.entries.first.value));
      String title = message.data.entries.last.value;
      AndroidNotification? android = message.notification?.android;
      flutterLocalNotificationsPlugin.show(
        100,
        "Admin has processed your ${notyBody.streamID} stream",
        title,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android?.smallIcon,
            // other properties...
          ),
          iOS: const IOSNotificationDetails(
              presentAlert: true, presentSound: true),
        ),
        payload: 'Default_Sound',
      );
    }
  }

  Future selectNotification(String? payload) async {
    if (roles.contains('ROLE_ADMIN')) {
      BlocProvider.of<DashboardBloc>(Keys.navState.currentContext!)
          .add(FetchAllStream());
    } else {
      BlocProvider.of<DashboardBloc>(Keys.navState.currentContext!)
          .add(FetchStreamByUser(userID: userID));
    }
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
