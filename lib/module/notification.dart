import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const channelId = 'opus_push';
const channelName = 'OPUS PUSH';

Future<void> setupNotification() async {

  const androidSetting = AndroidInitializationSettings( '@mipmap/ic_launcher' );
  const iosSetting = DarwinInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification
  );
  const initSettings = InitializationSettings (android: androidSetting, iOS: iosSetting);
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

}

Future<void> showNotification({required id, required body, required payload, title = 'OPUS.KG', ongoing = false, playSound = true}) async {
  final AndroidNotificationDetails androidDetail = AndroidNotificationDetails(
      channelId, // channel Id
      channelName, //channel Name
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      ongoing: ongoing
  );
  const DarwinNotificationDetails iosDetail = DarwinNotificationDetails(
    threadIdentifier: "thread1"
  );
  final NotificationDetails noticeDetail = NotificationDetails(
    iOS: iosDetail,
    android: androidDetail,
  );
  flutterLocalNotificationsPlugin.show(
    id,//id
    title,//title
    body,//description
    noticeDetail,
    payload: payload
  );
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  notificationStreamController.add(payload);
}

void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  print('onDidReceiveLocalNotification');
  showNotification(id: id, body: body, payload: payload, title: title);
}
