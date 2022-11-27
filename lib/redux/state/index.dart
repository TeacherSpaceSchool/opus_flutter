import 'app.dart';
import 'package:geolocator/geolocator.dart';

class IndexState {

  final AppState appState;

  IndexState({
    required this.appState
  });

  factory IndexState.init({required bool authenticated, required bool locationServiceEnabled, required LocationPermission locationPermission}) => IndexState(
    appState: AppState(authenticated: authenticated, locationServiceEnabled: locationServiceEnabled, locationPermission: locationPermission)
  );

  @override
  int get hashCode =>
      appState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IndexState &&
              runtimeType == other.runtimeType &&
              appState == other.appState;

  @override
  String toString() {
    return 'IndexState{appState: ${appState.toString()}}';
  }
}