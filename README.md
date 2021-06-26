# flutter-redux-sagas-example
```shell script
 # flutter create .
 flutter create my_app
 cd my_app
 flutter run
```

- bước 1: lib/main.dart
```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  
}
```

- bước 2: lib/root/store.dart
          pubspec.yaml
```dart
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
```

```yaml
# pubspec.yaml

...

dependencies:
  ...
  redux_saga: ^3.0.4

...
```

```shell script
 # shell script, bash, terminal
 flutter pub get
 flutter pub upgrade
 flutter pub outdated
 flutter doctor --verbose
```

- Bước 3:
```dart
// lib/main.dart
...

import 'root/store.dart';

...

const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() {
  ...

  sagaMiddleware.setStore(demoRootStore); // init data => call setStore()


  if (isProduction == false) {
    debugPrint('DEV_DEBUG Welcome to Development Mode');
    demoRootStore.onChange.listen(render);
  }

  ...
}

void render(dynamic state) {
  debugPrint('$state');
}
```

- Bước 4: lib/sagas/patternListen.dart
          pubspec.yaml
```dart
// lib/sagas/patternListen.dart
// mkdir -p lib/sagas && touch lib/sagas/patternListen.dart
import 'package:http/http.dart';
import 'package:redux_saga/redux_saga.dart';
import 'dart:convert' as convert;

Iterable patternListen() sync* {
  yield TakeEvery(fetchDataDemo1, pattern: PatternFetchDemo1);
  yield TakeEvery(fetchDataDemo2, pattern: PatternFetchDemo2);
}

Iterable fetchDataDemo1({dynamic action}) sync* {
  // yield Delay(Duration(seconds: 1));
  yield Try(() sync* {
    var data = Result();
    var paramDemo1 = PatternFetchDemo1().getName();
    var paramDemo2 = 'Domo2 ${PatternFetchDemo1().getName()}';

    yield Call(fetchHttpsJSON, args: [paramDemo1, paramDemo2], result: data);
    yield Put(
        {"type": "STATE_CHANGE_VALUE", "result": data.value, "success": true});
  }, Catch: (e, s) sync* {
    yield Put({"type": "FETCH_FAILED", "message": e.message, "success": false});
  });
}

Iterable fetchDataDemo2({dynamic action}) sync* {
  // yield Delay(Duration(seconds: 1));
  yield Try(() sync* {
    var data = Result();
    yield Call(fetchHttp, result: data);
    yield Put(
        {"type": "STATE_CHANGE_VALUE", "result": data.value, "success": true});
  }, Catch: (e, s) sync* {
    yield Put({"type": "FETCH_FAILED", "message": e.message, "success": false});
  });
}

class PatternFetchDemo1 {
  String name = '';

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return this.name;
  }
}

class PatternFetchDemo2 {}

dynamic fetchHttpsJSON(String paramDemo1, String paramDemo2) async {
  Uri url = Uri.https('localhost.com', '/data.json', {
    'page': '0',
    'limit': '50',
    'param_demo_1': paramDemo1,
    'param_demo_2': paramDemo2
  });
  Map<String, String> headers = {"Content-type": "application/json"};
  Response response = await get(url, headers: headers);
  return convert.jsonDecode(response.body) as Map<String, dynamic>;
}

dynamic fetchHttp() async {
  Uri url = Uri.http('localhost.com', '/data.txt');
  Response response = await get(url);
  return response.body;
}
```

```yaml
# pubspec.yaml

...

dependencies:
  ...
  http: ^0.13.3

  ...
```

```shell script
 # shell script, bash, terminal
 flutter pub get
 flutter pub upgrade
 flutter pub outdated
 flutter doctor --verbose
```

- Bước 5:
```dart
// lib/main.dart
...

import 'sagas/patternListen.dart';

...

void main() {
  ...

  sagaMiddleware.run(patternListen); // init listen pattern

  if (isProduction == false) {
      ...
  }
  ...
}
```

- Bước 6: lib/routers.dart
          lib/screens/homeScreen.dart
          lib/main.dart
          
```dart
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
```

```dart
// lib/screens/homeScreen.dart
// mkdir -p lib/screens && touch lib/screens/homeScreen.dart
import 'package:flutter/material.dart';

import '../root/store.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    demoRootStore
        .dispatch({"type": "STATE_CHANGE_VALUE", "value": "HomeScreen"});

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (pageView) {
        debugPrint('pageView $pageView');
      },
      children: [
        Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sign up', style: Theme.of(context).textTheme.headline4),
                RaisedButton(
                    child: Text('Register'),
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/signup');
                    }),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.cyan,
          child: MaterialBanner(
            content: Text('message'),
            leading: CircleAvatar(child: Icon(Icons.delete)),
            actions: [
              FlatButton(
                child: const Text('onPressed'),
                onPressed: () {
                  debugPrint('onPressed');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

```dart
// lib/main.dart
...

import 'routers.dart';

...

void main() {
  ...

  runApp(Routers());
  ...
}
```

- Android: android/app/src/main/AndroidManifest.xml

```xml
<manifest
...

    <uses-permission android:name="android.permission.INTERNET" />

    <application
...
```