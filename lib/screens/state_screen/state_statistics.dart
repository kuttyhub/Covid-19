import 'package:flutter/material.dart';

import '../build_card.dart';
import '../../models/state.dart';
import '../../models/distric_model.dart';
import '../../constants.dart';

class StateStatistics extends StatefulWidget {
  final List<StateModel> stateSummary;
  final String stateName;
  final String currentStateName;
  final String currentDistName;

  StateStatistics({
    @required this.stateSummary,
    @required this.stateName,
    @required this.currentStateName,
    @required this.currentDistName,
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
  

  @override
  void initState() {
    //countData();
    
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
  filterList() {
    print('-->${widget.currentDistName} ${widget.currentStateName}<--');
    if (widget.currentDistName != 'none' &&
        widget.currentStateName.toLowerCase() == widget.stateName.toLowerCase()) {
      final index = districtSummaryList.indexWhere((element) =>
          element.distric.replaceAll(' ', '').toLowerCase() ==
          widget.currentDistName.replaceAll(' ', '').toLowerCase());
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
              fontSize: 16,
              color: kTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(filterdList.length, (index) {
          return buildDistCard(filterdList[index]);
        })
      ],
    );
  }
}

Widget buildDistCard(DistricModel dis) {
  return Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                dis.distric,
                style: TextStyle(fontSize: 18, color: Colors.grey.shade800,fontWeight: FontWeight.bold),
              ),
            Column(
                  children: [
                    Text("Confirmed",style: TextStyle(color:kConfirmedColor)),
                    SizedBox(height: 3),
                    Text(dis.confirmed.toString(),style: TextStyle(color:kConfirmedColor)),
                  ],
                ),
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Column(
                children: [
                  Text("Recoverd",style: TextStyle(color:kRecoveredColor),),
                  SizedBox(height: 3),
                  Text(dis.recovered.toString(),style: TextStyle(color:kRecoveredColor),),
                ],
              ),
              Column(
                children: [
                  Text("Active",style: TextStyle(color:kActiveColor),),
                  SizedBox(height: 3),
                  Text(dis.active.toString(),style: TextStyle(color:kActiveColor),),
                ],
              ),Column(
                children: [
                  Text("Death",style: TextStyle(color:kDeathColor),),
                  SizedBox(height: 3),
                  Text(dis.death.toString(),style: TextStyle(color:kDeathColor),),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
