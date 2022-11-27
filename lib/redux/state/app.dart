import 'package:geolocator/geolocator.dart';

class AppState {
  bool isLoading;
  bool authenticated;
  bool locationServiceEnabled;
  LocationPermission locationPermission;

  AppState({
    this.isLoading = false,
    this.authenticated = false,
    required this.locationServiceEnabled,
    required this.locationPermission
  });

  @override
  int get hashCode =>
      isLoading.hashCode ^
      authenticated.hashCode ^
      locationServiceEnabled.hashCode ^
      locationPermission.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              isLoading == other.isLoading &&
              authenticated == other.authenticated &&
              locationServiceEnabled == other.locationServiceEnabled &&
              locationPermission == other.locationPermission;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, authenticated: $authenticated, locationPermission: $locationPermission, locationServiceEnabled: $locationServiceEnabled}';
  }
}