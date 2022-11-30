import 'package:flutter/material.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../module/const_value.dart';
import './memoized.dart';
import '../../screen/permission.dart';
import 'package:geolocator/geolocator.dart';
import '../../riverpod/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Layout extends HookConsumerWidget with  RouteAware {

  final String title;
  final Widget body;
  final bool showBack;
  final bool loading;
  final Widget? floatingActionButton;

  const Layout({super.key, required this.title, required this.body, this.floatingActionButton, this.showBack = false, this.loading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget? drawer = useMemoized(() => showBack?null:const SafeArea(child: MyDrawer()), []);
    //provider
    final bool loading_ = ref.watch(appProvider.select((app) => app.loading));
    final LocationPermission locationPermission = ref.watch(appProvider.select((app) => app.locationPermission));
    final bool locationServiceEnabled = ref.watch(appProvider.select((app) => app.locationServiceEnabled));
    //build
    return Stack(
      children: [
        Scaffold(
            drawer: drawer,
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: !locationServiceEnabled||locationPermission!=LocationPermission.always?
            null
                :
            MyAppBar(title: title),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: !locationServiceEnabled||locationPermission!=LocationPermission.always?
                    const Permission()
                        :
                    body
                )
            ),
            floatingActionButton: Memoized(
                keys: [locationServiceEnabled, locationPermission],
                child: floatingActionButton==null||!locationServiceEnabled||locationPermission!=LocationPermission.always?
                Container()
                    :
                floatingActionButton!
            )
        ),
        Memoized(
            keys: [loading, loading_],
            child: loading||loading_?
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
    );
  }
}