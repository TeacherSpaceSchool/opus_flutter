import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late final StateNotifierProvider<AppNotifier, App> appProvider;

initAppProvider({
  required bool authenticated,
  required bool locationServiceEnabled,
  required LocationPermission locationPermission
}) async {
  appProvider = StateNotifierProvider<AppNotifier, App>((ref) {
    return AppNotifier(
      authenticated: authenticated,
      locationServiceEnabled: locationServiceEnabled,
      locationPermission: locationPermission,
    );
  });
}

@immutable
class App {

  final bool loading;
  final bool authenticated;
  final bool locationServiceEnabled;
  final LocationPermission locationPermission;

  const App({
    this.loading = false,
    required this.authenticated,
    required this.locationServiceEnabled,
    required this.locationPermission
  });

  App copyWith({
    bool? loading,
    bool? authenticated,
    bool? locationServiceEnabled,
    LocationPermission? locationPermission
  }) {
    return App(
      loading: loading ?? this.loading,
      authenticated: authenticated ?? this.authenticated,
      locationServiceEnabled: locationServiceEnabled ?? this.locationServiceEnabled,
      locationPermission: locationPermission ?? this.locationPermission,
    );
  }

}

class AppNotifier extends StateNotifier<App> {

  AppNotifier({
    required authenticated,
    required locationServiceEnabled,
    required locationPermission
  }): super(App(
      authenticated: authenticated,
      locationServiceEnabled: locationServiceEnabled,
      locationPermission: locationPermission
  ));

  void setLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

}


