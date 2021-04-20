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
  List<DistricModel> districSummary = [];
  int active = 0;
  int confirmed = 0;
  int death = 0;
  int recovered = 0;

  @override
  void initState() {
    countData();
    super.initState();
  }

  void countData() {
    var state = widget.stateSummary.firstWhere(
        (state) => state.state.toLowerCase() == widget.stateName.toLowerCase());
    districSummary = state.districs;

    for (var dis in districSummary) {
      active += dis.active;
      confirmed += dis.confirmed;
      death += dis.death;
      recovered += dis.recovered;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisSize: MainAxisSize.min,
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
        ],
    
    );
  }
}
