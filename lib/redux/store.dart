import 'package:redux/redux.dart';
import './state/index.dart';
import './reducer/index.dart';
import 'package:geolocator/geolocator.dart';

Store<IndexState> generateStore ({required bool authenticated, required bool locationServiceEnabled, required LocationPermission locationPermission}) {
  return Store<IndexState>(
      indexReducer,
      initialState: IndexState.init(authenticated: authenticated, locationServiceEnabled: locationServiceEnabled, locationPermission: locationPermission),
  );
}