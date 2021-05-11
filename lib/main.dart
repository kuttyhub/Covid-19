import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/tracker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {runApp(MyApp());} );

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Hunt',
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
