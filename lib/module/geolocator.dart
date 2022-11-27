import 'dart:async';
import 'package:geolocator/geolocator.dart';

Future<Map<String, dynamic>> checkLocation() async {
  bool locationServiceEnabled;
  LocationPermission locationPermission;
  //Есть ли разрешение к геолокации
  locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
  }
  if (locationPermission != LocationPermission.always) {
    locationPermission = await Geolocator.requestPermission();
  }
  //Проверка на включение
  locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  return {
    'locationServiceEnabled': locationServiceEnabled,
    'locationPermission': locationPermission
  };
}

Future<Position?> geoPosition() async {
  Position? position;
  final Map<String, dynamic> checkLocation_ = await checkLocation();
  if(checkLocation_['locationServiceEnabled']&&LocationPermission.always==checkLocation_['locationPermission']) {
    position = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 10));
  }
  return position;
}