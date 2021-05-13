import "package:flutter/material.dart";
import 'Api.dart';
import 'login.dart';
import 'package:cron/cron.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

ApiService api = new ApiService();
final storage = new FlutterSecureStorage();
int last_news_id = 0;

Future<void> check_updates() async {

  api.get_news().then((news_data) => {
    possibly_notify(news_data)}
    );
}

void possibly_notify(news_data) async{
  String last_news_string = await storage.read(key: "news");
  if (news_data.length < 1) {
    return;
  }
  if(last_news_string == null){
    storage.write(key: "news", value: 0.toString());
    return;
  }
  int last_news_id = int.parse(last_news_string);
  if (news_data.length == 0) {
    return;
  }
  String notification = news_data[0]["notification"];
  int current = 0;
  try {
    current = int.parse(news_data[0]["id"]);
    storage.write(key: "news", value: current.toString());
  } catch (e) {}
  if (last_news_id < current) {
    AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: 'basic_channel', title: 'Nieuwe bericht', body: notification));

  } else {
    print("no new notifications, print nothing");
  }
}

void main() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(MyApp());
  final cron = Cron()
    ..schedule(Schedule.parse('*/90 * * * * *'), () {
      check_updates();
    });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(primarySwatch: Colors.blue), home: LoginDemo());
  }
}
