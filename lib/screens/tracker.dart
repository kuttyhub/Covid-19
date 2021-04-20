import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/navigation_option.dart';
import 'state.dart';
import 'India.dart';

enum NavigationStatus {
  INDIA,
  STATE,
}

class Tracker extends StatefulWidget {
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  NavigationStatus navigationStatus = NavigationStatus.INDIA;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    )),
                child: Country(),
              ),
            ),
            Container(
              height: size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavigationOption(
                    title: "India",
                    selected: navigationStatus == NavigationStatus.INDIA,
                    onSelected: () {
                      setState(() {
                        navigationStatus = NavigationStatus.INDIA;
                      });
                    },
                  ),
                  NavigationOption(
                    title: "State",
                    selected: navigationStatus == NavigationStatus.STATE,
                    onSelected: () {
                      setState(() {
                        navigationStatus = NavigationStatus.STATE;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
