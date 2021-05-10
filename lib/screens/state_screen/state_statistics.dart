import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

import '../build_card.dart';
import '../../models/state.dart';
import '../../models/distric_model.dart';
import '../../constants.dart';

class StateStatistics extends StatefulWidget {
  final List<StateModel> stateSummary;
  final String stateName;

  StateStatistics({
    @required this.stateSummary,
    @required this.stateName,
  });

  @override
  _StateStatisticsState createState() => _StateStatisticsState();
}

class _StateStatisticsState extends State<StateStatistics> {
  List<DistricModel> districtSummaryList = [];
  List<DistricModel> filterdList = [];
  int active = 0;
  int confirmed = 0;
  int death = 0;
  int recovered = 0;
  String distName = 'none';
  String currentState;

  @override
  void initState() {
    //countData();
    getUserLocation();
    super.initState();
  }

  void countData() {
    print(" ${widget.stateName}");
    // for (var s in widget.stateSummary) {
    //   print(s.state.toLowerCase());
    //   print(s.state.toLowerCase() == widget.stateName.toLowerCase());
    // }
    final stateDummy = widget.stateSummary.firstWhere((stateElement) =>
        stateElement.state.replaceAll(' ', '').toLowerCase() ==
        widget.stateName.replaceAll(' ', '').toLowerCase());
    print(stateDummy);
    if (stateDummy != null) {
      districtSummaryList = stateDummy.districts;
      var kactive = 0;
      var kconfirmed = 0;
      var kdeath = 0;
      var krecovered = 0;

      for (var dis in districtSummaryList) {
        kactive += dis.active;
        kconfirmed += dis.confirmed;
        kdeath += dis.death;
        krecovered += dis.recovered;
      }
      filterList();
      setState(() {
        districtSummaryList = stateDummy.districts;
        active = kactive < 0 ? 0 : kactive;
        confirmed = kconfirmed;
        death = kdeath;
        recovered = krecovered;
      });
    }
  }

  getUserLocation() async {
    //call this async method from whereever you need
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    //currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //print(addresses);
    var first = addresses.first;
    //print(
    //' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    print('->>${first.adminArea}');
    currentState = first.adminArea;
    distName = first.subAdminArea ?? 'none';
    countData();
  }

  filterList() {
    print('$distName $currentState');
    if (distName != 'none' && currentState.toLowerCase() == widget.stateName.toLowerCase()) {
      final index = districtSummaryList.indexWhere((element) =>
          element.distric.replaceAll(' ', '').toLowerCase() ==
          distName.replaceAll(' ', '').toLowerCase());
      if (index == -1) {
        filterdList = districtSummaryList;
        return;
      }
      if (index < districtSummaryList.length) {
        filterdList = [];
        for (int i = index; i < districtSummaryList.length; i++) {
          filterdList.add(districtSummaryList[i]);
        }
        if (index != 0) {
          for (int i = 0; i < index; i++) {
            filterdList.add(districtSummaryList[i]);
          }
        }
        for (int i = 0; i < filterdList.length; i++) {
          //print('-->$i ${filterdList[i].distric}');
        }
      }
    } else {
      filterdList = districtSummaryList;
    }
  }

  @override
  Widget build(BuildContext context) {
    countData();
    return Column(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BuildCard(
          "CONFIRMED",
          confirmed,
          kConfirmedColor,
          "ACTIVE",
          active,
          kActiveColor,
        ),
        BuildCard(
          "RECOVERED",
          recovered,
          kRecoveredColor,
          "DEATH",
          death,
          kDeathColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(
            "DistrictWise Lists :",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(filterdList.length, (index) {
          return Container(
            margin: EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    filterdList[index].distric,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Acitve : ${filterdList[index].active}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kActiveColor,
                          ),
                        ),
                        Text(
                          "Recovered : ${filterdList[index].recovered}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kRecoveredColor,
                          ),
                        ),
                        Text(
                          "Death : ${filterdList[index].death}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kDeathColor,
                          ),
                        ),
                        Text(
                          "Confirmed : ${filterdList[index].confirmed}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kConfirmedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        })
      ],
    );
  }
}
