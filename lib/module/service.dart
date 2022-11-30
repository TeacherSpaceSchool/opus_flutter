import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:ui';
import './geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../gql/index.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './notification.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../gql/geo_history.dart';
import '../gql/subscription.dart';
import 'package:geolocator/geolocator.dart';

var box;
late final String device;
var gqlClient;
var subscription_;
late StreamSubscription<Position> positionStream;
String? lastCall;

void initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      initialNotificationTitle: 'OPUS SERVICE',
      initialNotificationContent: '',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  print('onIosBackground');

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  //обеспечения инициализации
  DartPluginRegistrant.ensureInitialized();
  //initial
  await init(service);
  //callback
  serviceCallback(service);
  // timer
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    print('Service lastCall $lastCall');
    String nowCall = DateTime.now().toString();
    lastCall = nowCall;
    print('Service nowCall ${nowCall}');
    var geoData = await geoPosition();
    await work(service);
  });
}

void serviceCallback(service) async {
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  service.on('reinitGQL').listen((event) async {
    await initGQL(jwt: event['jwt'], service: service);
  });
  service.on('initService').listen((event) async {
    work(service);
  });
}

Future init(service) async {
  await initHiveForFlutter();
  box = await Hive.openBox('opusBox');
  await initGQL(jwt: box.get('jwt'), service: service);
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    device = '${iosInfo.name} ${iosInfo.model} ${iosInfo.systemName} ${iosInfo.systemVersion}';
  }
  else if(defaultTargetPlatform == TargetPlatform.android) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    device = '${androidInfo.brand} ${androidInfo.model} ${androidInfo.device} Android ${androidInfo.version.release}';
  }
  else {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    device = 'browser ${webBrowserInfo.browserName} ${webBrowserInfo.userAgent}';
  }
}

Future work(ServiceInstance service) async {
  var geoData;
  try {
    geoData = await geoPosition();
    if(geoData!=null) {
      await gqlClient.mutate(MutationOptions(
          variables: {'geo': [geoData!.latitude, geoData!.longitude], 'device': device},
          document: gql(addGeoHistory)));
    }
  }
  catch(error) {
    //...
  }
  print('GEO-S $geoData');
  service.invoke('update',
    {
      'geoData': geoData,
      'date': DateTime.now().toString()
    },
  );
}

Future initGQL({required jwt, required service}) async {
  int i = 0;
  if(subscription_!=null) subscription_.cancel();
  gqlClient = await generateGqlClientService(jwt);
  var subscription = gqlClient.subscribe(
    SubscriptionOptions(
        document: gql(subscriptionDocument)
    ),
  );
  subscription_ = subscription.listen((subscriptionData) {
    i++;
    print('service push $i ${subscriptionData.data!['reloadData']!['message']!['text']}');
    showNotification(
      id: i,
      title: 'S ${subscriptionData.data!['reloadData']!['message']!['text']}',
      body: '${DateTime.now()}',
      payload: '${subscriptionData.data!['reloadData']!['message']!['text']} ${DateTime.now()}'
    );
    gqlClient.mutate(MutationOptions(
        variables: {'_id': subscriptionData.data!['reloadData']!['message']!['_id']},
        document: gql(receiveWS)));
      service.invoke('receiveNotification',
        {
          'text': subscriptionData.data!['reloadData']!['message']!['text'],
          'id': i
        },
      );
  });
}
