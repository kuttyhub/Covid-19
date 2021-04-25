import 'package:flutter/material.dart';

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
  int active = 0;
  int confirmed = 0;
  int death = 0;
  int recovered = 0;

  // @override
  // void initState() {
  //   countData();
  //   super.initState();
  // }

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
      setState(() {
        active = kactive<0?0:kactive;
        confirmed = kconfirmed;
        death = kdeath;
        recovered = krecovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    countData();
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        ...List.generate(districtSummaryList.length, (index) {
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
                    districtSummaryList[index].distric,
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
                          "Acitve : ${districtSummaryList[index].active}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kActiveColor,
                          ),
                        ),
                        Text(
                          "Recovered : ${districtSummaryList[index].recovered}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kRecoveredColor,
                          ),
                        ),
                        Text(
                          "Death : ${districtSummaryList[index].death}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kDeathColor,
                          ),
                        ),
                        Text(
                          "Confirmed : ${districtSummaryList[index].confirmed}",
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
