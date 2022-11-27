import '../state/index.dart';
import '../reducer/app.dart';

IndexState indexReducer(IndexState state, action) {
  return IndexState(
    appState: appStateReducer(state.appState, action),
  );
}