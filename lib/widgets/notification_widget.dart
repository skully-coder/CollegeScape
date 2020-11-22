import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manipalleaks/models/notification.dart';

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Notif> notifications = [];
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> notification) async {
      print("onMessage: $notification");
      final notif = notification['notification'];
      setState(() {
        notifications.add(Notif(title: notif['title'], body: notif['body']));
      });
    }, onLaunch: (Map<String, dynamic> notification) async {
      print("onLaunch: $notification");
    }, onResume: (Map<String, dynamic> notification) async {
      print("onResume: $notification");
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: notifications.map(buildNotification).toList(),
      ),
    );
  }

  Widget buildNotification(Notif notification) => ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.body),
      );
}
