import 'package:redux/redux.dart';
import '../actions/app.dart';
import '../state/app.dart';

final appStateReducer = combineReducers<AppState>([
  TypedReducer<AppState, ShowLoading>(showLoading),
  TypedReducer<AppState, SetAuthenticated>(setAuthenticated),
  TypedReducer<AppState, SetLocationPermission>(setLocationPermission),
  TypedReducer<AppState, SetLocationServiceEnabled>(setLocationServiceEnabled),
]);

AppState showLoading (AppState appState, ShowLoading action) {
  appState.isLoading = action.show;
  return appState;
}

AppState setAuthenticated (AppState appState, SetAuthenticated action) {
  appState.authenticated = action.authenticated;
  return appState;
}

AppState setLocationPermission (AppState appState, SetLocationPermission action) {
  appState.locationPermission = action.locationPermission;
  return appState;
}

AppState setLocationServiceEnabled (AppState appState, SetLocationServiceEnabled action) {
  appState.locationServiceEnabled = action.locationServiceEnabled;
  return appState;
}
