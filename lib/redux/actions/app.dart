import 'package:geolocator/geolocator.dart';

class ShowLoading {
  final bool show;
  ShowLoading(this.show);
}

class SetAuthenticated {
  final bool authenticated;
  SetAuthenticated(this.authenticated);
}

class SetLocationServiceEnabled{
  final bool locationServiceEnabled;
  SetLocationServiceEnabled(this.locationServiceEnabled);
}

class SetLocationPermission {
  final LocationPermission locationPermission;
  SetLocationPermission(this.locationPermission);
}
