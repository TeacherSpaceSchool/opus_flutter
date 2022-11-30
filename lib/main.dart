import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'screen/home.dart';
import 'screen/contact.dart';
import 'screen/deprecated.dart';
import 'gql/index.dart';
import 'module/const_value.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../module/app_data.dart';
import '../../module/geolocator.dart';
import '../../module/service.dart';
import './module/notification.dart';
import './widget/app/memoized.dart';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import './riverpod/app.dart';

//key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late StreamController notificationStreamController;
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
var box;
late final bool deprecated;
const title = 'OPUS';
const initialRoute = '/';
String? jwt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  box = await Hive.openBox('opusBox');
  jwt = box.get('jwt');
  final GraphQLClient gqlClient = await generateGqlClient(jwt);
  final Map<String, bool> initialAppData = await initialApp();
  final Map<String, dynamic> checkLocation_ = await checkLocation();
  initAppProvider(
      authenticated: initialAppData['authenticated']!,
      locationServiceEnabled: checkLocation_['locationServiceEnabled'],
      locationPermission: checkLocation_['locationPermission']
  );
  deprecated = initialAppData['deprecated']!;
  await setupNotification();
  initializeService();
  Timer(const Duration(seconds: 1), () {
    FlutterBackgroundService().invoke('initService');
  });
  runApp(MyApp(gqlClient: ValueNotifier(gqlClient)));
}

class MyApp extends HookWidget {

  final ValueNotifier<GraphQLClient>? gqlClient;

  const MyApp({super.key, required this.gqlClient});

  @override
  Widget build(BuildContext context) {
    notificationStreamController = useStreamController();
    useEffect(() {
      //проверка включения геолокации
      geoPosition();
      //прослушивание нажатия на уведомление
      final notificationClickStream = notificationStreamController.stream.listen((data) async {
        navigatorKey.currentState!.pushNamed('/contact');
      });
      return notificationClickStream.cancel;
    }, []);
    /*useAppLifecycleState;
    useEffect(() {
      //прослушивание пришедших уведомлений
      final notificationReceiveStream = FlutterBackgroundService().on('receiveNotification').listen((data) async {
        print('$data ${data?['id']}');
        showNotification(
            id: data?['id'],
            title: 'A ${data?['text']}',
            body: '${DateTime.now()}',
            payload: '${data?['text']} ${DateTime.now()}'
        );
      });
      return notificationReceiveStream.cancel;
    }, []);*/
    return Memoized(child: deprecated?
      const Deprecated(): ProviderScope(
          child: MaterialApp(
              navigatorKey: navigatorKey,
              navigatorObservers: [routeObserver],
              theme:ThemeData(
                primarySwatch: mainMaterialColor,
                textTheme: useMemoized(() => GoogleFonts.robotoTextTheme(
                  Theme.of(context).textTheme,
                ), [context]),
              ),
              debugShowCheckedModeBanner: false,
              title: title,
              initialRoute: initialRoute,
              routes: {
                '/': (context) => const HomePage(),
                '/contact': (context) => const ContactPage(),
              }
          )
      )
    );
  }
}

