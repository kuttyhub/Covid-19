import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:timeago/timeago.dart' as timeago;

import '../build_card.dart';
import '../chart.dart';
import '../../constants.dart';
import '../../models/country_summary.dart';
import '../../models/time_series_cases.dart';

class IndiaStatistics extends StatelessWidget {
  final List<CountrySummaryModel> summaryList;

  IndiaStatistics({@required this.summaryList});

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BuildCard(
          "CONFIRMED",
          summaryList[summaryList.length - 1].confirmed,
          kConfirmedColor,
          "ACTIVE",
          summaryList[summaryList.length - 1].active,
          kActiveColor,
        ),
        SizedBox(height: 15),
        BuildCard(
          "RECOVERED",
          summaryList[summaryList.length - 1].recovered,
          kRecoveredColor,
          "DEATH",
          summaryList[summaryList.length - 1].death,
          kDeathColor,
        ),
        SizedBox(height: 15),
        buildCardChart(summaryList, context),
      ],
    );
  }

  Widget buildCardChart(
      List<CountrySummaryModel> summaryList, BuildContext context) {
    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Chart(
                _createData(summaryList),
                animate: false,
              ),
            ),
            SizedBox(height: 10),
            buildinfo(kActiveColor, "Active Cases"),
            SizedBox(height: 5),
            buildinfo(kConfirmedColor, "Confirmed Cases"),
            SizedBox(height: 5),
            buildinfo(kRecoveredColor, "Recovered Cases"),
            SizedBox(height: 5),
            buildinfo(Colors.amber, "Death Cases"),
          ],
        ),
      ),
    );
  }

  Widget buildinfo(Color color, String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          height: 10,
          width: 10,
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  static List<charts.Series<TimeSeriesCases, DateTime>> _createData(
      List<CountrySummaryModel> summaryList) {
    List<TimeSeriesCases> confirmedData = [];
    List<TimeSeriesCases> activeData = [];
    List<TimeSeriesCases> recoveredData = [];
    List<TimeSeriesCases> deathData = [];

    for (var item in summaryList) {
      confirmedData.add(TimeSeriesCases(item.date, item.confirmed));
      activeData.add(TimeSeriesCases(item.date, item.active));
      recoveredData.add(TimeSeriesCases(item.date, item.recovered));
      deathData.add(TimeSeriesCases(item.date, item.death));
    }

    return [
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kConfirmedColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: confirmedData,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Active',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kActiveColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: activeData,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kRecoveredColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: recoveredData,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Death',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.amber),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: deathData,
      ),
    ];
  }
}
