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
