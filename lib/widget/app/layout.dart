import 'package:flutter/material.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'root_aware.dart';
import '../../module/const_value.dart';
import '../../main.dart';
import './memoized.dart';
import './connector.dart';
import '../../screen/permission.dart';
import 'package:geolocator/geolocator.dart';

class Layout extends HookWidget with  RouteAware {
  
  final String title;
  final Widget body;
  final bool showBack;
  final Widget? floatingActionButton;

  const Layout({super.key, required this.title, required this.body, this.floatingActionButton, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    final Widget? drawer = useMemoized(() => showBack?null:const SafeArea(child: MyDrawer()), []);
    //routeObserver
    final route = ModalRoute.of(context);
    useEffect(() {
      final routeAware = MyRouteAware();
      routeObserver.subscribe(routeAware, route as PageRoute);
      return () => routeObserver.unsubscribe(routeAware);
    }, [route, routeObserver]);
    //build
    return MyStoreConnector(
        builder: (context, state) => Stack(
          children: [
            Scaffold(
                drawer: drawer,
                backgroundColor: const Color(0xFFF5F5F5),
                appBar: !state.appState.locationServiceEnabled||state.appState.locationPermission!=LocationPermission.always?
                  null
                    :
                  MyAppBar(title: title),
                body: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: !state.appState.locationServiceEnabled||state.appState.locationPermission!=LocationPermission.always?
                          const Permission()
                            :
                          body
                    )
                ),
                floatingActionButton: Memoized(
                    keys: [state.appState.locationServiceEnabled, state.appState.locationPermission],
                    child: floatingActionButton==null||!state.appState.locationServiceEnabled||state.appState.locationPermission!=LocationPermission.always?
                      Container()
                        :
                      floatingActionButton!
                )
            ),
            Memoized(
                keys: [state.appState.isLoading],
                child: state.appState.isLoading?
                  Container(
                    color: const Color.fromARGB(80, 0, 0, 0),
                    child: const Center(
                      child: SpinKitRing(
                        color: mainColor,
                        size: 70,
                      ),
                    ),
                  )
                    :
                  Container()
            )
          ],
        )
    );
  }
}
