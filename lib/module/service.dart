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

  print('vm:entry-point');

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  //обеспечения инициализации
  DartPluginRegistrant.ensureInitialized();
  //initial
  await init();
  //callback
  serviceCallback(service);
  // timer
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    await work(service);
  });
}

void serviceCallback(service) async {
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  service.on('reinitGQL').listen((event) async {
    await initGQL(event['jwt']);
  });
  service.on('initService').listen((event) async {
    work(service);
  });
}

Future init() async {
  await initHiveForFlutter();
  box = await Hive.openBox('opusBox');
  await initGQL(box.get('jwt'));
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
  print('Service $geoData ${DateTime.now()}');
  service.invoke('update',
    {
      'geoData': geoData,
      'date': DateTime.now().toString(),
    },
  );
}

Future initGQL(jwt) async {
  if(subscription_!=null) subscription_.cancel();
  gqlClient = await generateGqlClientService(jwt);
  var subscription = gqlClient.subscribe(
    SubscriptionOptions(
        document: gql(subscriptionDocument)
    ),
  );
  subscription_ = subscription.listen((subscriptionData) {
    print('service push ${subscriptionData.data!['reloadData']!['message']!['text']}');
    showNotification(
      id: 888,
      title: subscriptionData.data!['reloadData']!['message']!['text'],
      body: '${DateTime.now()}',
      payload: '${subscriptionData.data!['reloadData']!['message']!['text']} ${DateTime.now()}'
    );
    gqlClient.mutate(MutationOptions(
        variables: {'_id': subscriptionData.data!['reloadData']!['message']!['_id']},
        document: gql(receiveWS)));
  });
}
