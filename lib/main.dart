import 'package:flutter/material.dart';

import 'root/store.dart';
import 'sagas/patternListen.dart';
import 'routers.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() {
  sagaMiddleware.setStore(demoRootStore); // init data => call setStore()
  sagaMiddleware.run(patternListen); // init listen pattern

  if (isProduction == false) {
    debugPrint('DEV_DEBUG Welcome to Development Mode');
    demoRootStore.onChange.listen(render);
  }

  runApp(Routers());
}

void render(dynamic state) {
  debugPrint('$state');
}
