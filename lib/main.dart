import 'package:flutter/material.dart';
import 'package:actions/actions.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => ActionShow(),
      },
    );
  }
}
