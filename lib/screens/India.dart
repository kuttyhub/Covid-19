import 'package:flutter/material.dart';

import '../services/covid_service.dart';

import '../models/country_summary.dart';
import '../screens/india_loading.dart';
import '../screens/india_statistics.dart';

CovidService covidService = CovidService();

class Country extends StatefulWidget {
  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  Future<List<CountrySummaryModel>> summaryList;

  @override
  initState() {
    super.initState();
    summaryList = covidService.getCountrySummary();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                  fontSize: 14,
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
                return CountryLoading(inputTextLoading: false);
              default:
                return !snapshot.hasData
                    ? Center(
                        child: Text("Empty"),
                      )
                    : CountryStatistics(
                        summaryList: snapshot.data,
                      );
            }
          },
        ),
      ],
    );
  }
}
