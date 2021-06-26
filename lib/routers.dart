// lib/routers.dart
// touch lib/routers.dart
import 'package:flutter/material.dart';
import 'screens/homeScreen.dart';

import 'root/store.dart';
import 'sagas/patternListen.dart';

class Routers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // demoRootStore.dispatch(PatternFetchDemo1());

    final objectDemo1 = PatternFetchDemo1();
    objectDemo1.setName("objectDemo1 Name");
    demoRootStore.dispatch(objectDemo1);

    return MaterialApp(
      routes: {
        '/': (context) => HomeScreen(),
        // '/signup': (context) => SignUpScreen(),
      },
    );
  }
}
