import 'package:covid_hunt/ad_helper/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  NavigationStatus navigationStatus = NavigationStatus.INDIA;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();

    _interstitialAd = InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
          ad.dispose();
        },
        onAdClosed: (_) {
          SystemNavigator.pop();
        },
      ),
    );
    _interstitialAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      if (_isInterstitialAdReady) {
        _interstitialAd.show();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit an App'),
              actions: <Widget>[
                OutlinedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                    return true;
                  },
                ),
                OutlinedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    return false;
                  },
                ),
              ],
            );
          },
        );
      }
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        child: SafeArea(
          child: Stack(
            children: [
              Container(color: kPrimaryColor),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height *
                          (navigationStatus == NavigationStatus.INDIA
                              ? 0.8
                              : 1),
                      padding: EdgeInsets.only(
                          bottom: 30, top: 0, left: 20, right: 20),
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
                    if (_isBannerAdReady &&
                        navigationStatus == NavigationStatus.INDIA) ...[
                      Container(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                      SizedBox(height: size.height * 0.1),
                    ]
                  ],
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
        onWillPop: onWillPop,
      ),
    );
  }
}
