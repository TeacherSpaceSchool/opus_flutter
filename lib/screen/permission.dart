import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/app/my_button.dart';
import '../widget/app/connector.dart';
import '../widget/app/my_text.dart';
import '../widget/app/memoized.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/state/index.dart';
import '../redux/actions/app.dart';
import '../module/geolocator.dart';

class Permission extends HookWidget {

  const Permission({super.key});

  @override
  Widget build(BuildContext context) {
    final openAppSettings = useState(false);
    final String openAppSettingsText = useMemoized(()=>openAppSettings.value?'Проверить разрешение':'Настройки приложения', [openAppSettings.value]);
    final openLocationSettings = useState(false);
    final String openLocationSettingsText = useMemoized(()=>openLocationSettings.value?'Проверить геолкацию':'Настройки геолокации', [openLocationSettings.value]);
    return MyStoreConnector(
        builder: (context, state) => Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  Memoized(
                    keys: [state.appState.locationPermission, openAppSettingsText],
                    child: state.appState.locationPermission!=LocationPermission.always?
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
                                  StoreProvider.of<IndexState>(context).dispatch(SetLocationPermission(locationPermission));
                                }
                            )
                          ]
                      )
                        :
                      Container()
                  ),
                  const SizedBox(height: 10),
                  Memoized(
                    keys: [state.appState.locationServiceEnabled, openLocationSettingsText],
                    child: !state.appState.locationServiceEnabled?
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
                                StoreProvider.of<IndexState>(context).dispatch(SetLocationServiceEnabled(locationServiceEnabled));
                              }
                          )
                        ]
                    )
                      :
                    Container(),
                  )
                ]
            )
        )
    );
  }
}
