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
  List<DistricModel> districSummaryList = [];
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
      districSummaryList = stateDummy.districs;
      var kactive = 0;
      var kconfirmed = 0;
      var kdeath = 0;
      var krecovered = 0;

      for (var dis in districSummaryList) {
        kactive += dis.active;
        kconfirmed += dis.confirmed;
        kdeath += dis.death;
        krecovered += dis.recovered;
      }
      setState(() {
        active = kactive;
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
            "DistricWise Lists :",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(districSummaryList.length, (index) {
          return Container(
            height: 85,
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
                    districSummaryList[index].distric,
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Acitve : ${districSummaryList[index].active}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kActiveColor,
                          ),
                        ),
                        Text(
                          "Recovered : ${districSummaryList[index].recovered}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kRecoveredColor,
                          ),
                        ),
                        Text(
                          "Death : ${districSummaryList[index].death}",
                          style: TextStyle(
                            fontSize: 14,
                            color: kDeathColor,
                          ),
                        ),
                        Text(
                          "Confirmed : ${districSummaryList[index].confirmed}",
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
