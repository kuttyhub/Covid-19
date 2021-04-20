import 'package:flutter/material.dart';

import 'package:covid19/constants.dart';
import 'package:covid19/screens/tracker.dart';

import './services/covid_service.dart';

void main() {
  runApp(MyApp());
}

CovidService covidService = CovidService();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid 19',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Quicksand',
        primaryColor: Colors.teal,
      ),
      home: Tracker(),
    );
  }
}
