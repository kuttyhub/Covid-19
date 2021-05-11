import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/navigation_option.dart';
import '../screens/state_screen/state.dart';
import '../screens/india_screen/India.dart';

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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom:30,top:0,left:20,right:20),
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: navigationStatus == NavigationStatus.INDIA
                    ? India()
                    : StateScreen(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.25,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
