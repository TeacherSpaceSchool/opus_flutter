import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../gql/index.dart';
import '../gql/passport.dart';
import '../gql/version.dart';
import 'package:device_info_plus/device_info_plus.dart';

const double version = 1;
late final double insetPaddingDialog;
late final double width;
late final bool isMobile;
Map<String, dynamic> profile = {};

Future<Map<String, bool>> initialApp() async {
  width = window.physicalSize.width/window.devicePixelRatio;
  isMobile = width<500;
  if(isMobile) {
    insetPaddingDialog = 32;
  }
  else {
    insetPaddingDialog = (width - 500)/2;
  }
  Map<String, dynamic>? res = await getQuery(
      queries: [getProfile, getVersion],
  );
  if(res?['getStatus']?['role']!=null) {
    profile = res?['getStatus'];
    final String device;
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
    sendMutation(variables: {
      'device': device
    }, mutation: setDevice);
  }
  return {
    'authenticated': profile['role']!=null,
    'deprecated': res?['version']!=version
  };
}