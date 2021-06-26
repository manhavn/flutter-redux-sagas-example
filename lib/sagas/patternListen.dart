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
