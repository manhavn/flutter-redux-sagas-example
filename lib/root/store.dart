// lib/root/store.dart
// mkdir -p lib/root && touch lib/root/store.dart
import 'package:redux/redux.dart';
import 'package:redux_saga/redux_saga.dart';

var sagaMiddleware = createSagaMiddleware();

dynamic executeState(dynamic state, dynamic action) {
  if ('${action.runtimeType}'.indexOf('IdentityMap') < 0 &&
      '${action.runtimeType}'.indexOf('_InternalLinkedHashMap') < 0) {
    return state;
  }

  switch (action["type"]) {
    case "STATE_CHANGE_VALUE":
      state["value"] = action["value"];
      return state;
    default:
  }
  return state;
}

// create store and apply middleware
final demoRootStore = Store<dynamic>(
  executeState, // updateReducer
  initialState: <String, dynamic>{}, // Reducer
  middleware: [applyMiddleware(sagaMiddleware)],
);
