import 'package:flutter/material.dart';

import '../../services/covid_service.dart';
import '../../models/country_summary.dart';
import './india_loading.dart';
import './india_statistics.dart';

CovidService covidService = CovidService();

class India extends StatefulWidget {
  @override
  _IndiaState createState() => _IndiaState();
}

class _IndiaState extends State<India> {
  Future<List<CountrySummaryModel>> summaryList;

  @override
  initState() {
    super.initState();
    summaryList = covidService.getCountrySummary();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Global Corona Virus Cases",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    summaryList = covidService.getCountrySummary();
                  });
                },
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: summaryList,
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text("Error"),
              );
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return IndiaLoading();
              default:
                return !snapshot.hasData
                    ? Center(
                        child: Text("Empty"),
                      )
                    : IndiaStatistics(
                        summaryList: snapshot.data,
                      );
            }
          },
        ),
      ],
    );
  }
}
