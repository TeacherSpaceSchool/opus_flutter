import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/app/my_button.dart';
import '../widget/app/my_text.dart';
import '../widget/app/memoized.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../module/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../riverpod/app.dart';

class Permission extends HookConsumerWidget {

  const Permission({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //provider
    final bool locationServiceEnabled = ref.watch(appProvider.select((app) => app.locationServiceEnabled));
    final LocationPermission locationPermission = ref.watch(appProvider.select((app) => app.locationPermission));
    //
    final openAppSettings = useState(false);
    final String openAppSettingsText = useMemoized(()=>openAppSettings.value?'Проверить разрешение':'Настройки приложения', [openAppSettings.value]);
    final openLocationSettings = useState(false);
    final String openLocationSettingsText = useMemoized(()=>openLocationSettings.value?'Проверить геолкацию':'Настройки геолокации', [openLocationSettings.value]);
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              Memoized(
                  keys: [locationPermission, openAppSettingsText],
                  child: locationPermission!=LocationPermission.always?
                  Column(
                      children : [
                        const MyText(title: 'Инструкция'),
                        MyButton(
                            title: openAppSettingsText,
                            function: () async {
                              LocationPermission locationPermission = await Geolocator.checkPermission();
                              if (locationPermission != LocationPermission.always) {
                                await Geolocator.openAppSettings();
                                openAppSettings.value = true;
                              }
                              else {
                                geoPosition();
                              }
                              ref.read(appProvider.notifier).setLocationPermission(locationPermission);
                            }
                        )
                      ]
                  )
                      :
                  Container()
              ),
              const SizedBox(height: 10),
              Memoized(
                keys: [locationServiceEnabled, openLocationSettingsText],
                child: !locationServiceEnabled?
                Column(
                    children : [
                      const MyText(title: 'Инструкция'),
                      MyButton(
                          title: openLocationSettingsText,
                          function: () async {
                            bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
                            if(!locationServiceEnabled) {
                              await Geolocator.openLocationSettings();
                              openLocationSettings.value = true;
                            }
                            else {
                              geoPosition();
                            }
                            ref.read(appProvider.notifier).setLocationServiceEnabled(locationServiceEnabled);
                          }
                      )
                    ]
                )
                    :
                Container(),
              )
            ]
        )
    );
  }
}
