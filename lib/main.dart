import 'package:flutter/material.dart';

import 'package:flutter_calc/calculator/CalculatorScreen.dart';
import 'package:flutter_calc/const.dart';


////////////////////////////////////////////////////////////////////////////////
void main() => runApp(MyApp());


////////////////////////////////////////////////////////////////////////////////
class MyApp extends StatelessWidget {

  Map<String, WidgetBuilder> makeRoutes(BuildContext context) {
    Map<String, WidgetBuilder> routes = {};
    routes['/'] = (context) => CalculatorScreen();
    return routes;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[100],
      ),
      initialRoute: '/',
      routes: makeRoutes(context)
    );
  }
}

