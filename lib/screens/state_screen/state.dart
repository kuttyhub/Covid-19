import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constants.dart';
import './state_statistics.dart';
import './state_loading.dart';
import '../../models/state.dart';
import '../../services/covid_service.dart';

CovidService covidService = CovidService();

class StateScreen extends StatefulWidget {
  @override
  _StatesState createState() => _StatesState();
}

class _StatesState extends State<StateScreen> {
  final TextEditingController _typeAheadController = TextEditingController();

  Future<List<StateModel>> states;
  StateModel stateSummary;
  int totalActive = 0;
  int totalConfirmed = 0;
  int totalDeath = 0;
  int totalRecovered = 0;
  @override
  void initState() {
    super.initState();
    states = covidService.getStateSummary();
    print(states);
    this._typeAheadController.text = "tamil Nadu";
  }

  List<String> _getSuggestions(List<StateModel> list, String query) {
    List<String> matches = [];

    for (var item in list) {
      matches.add(item.state);
    }
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: states,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Error"),
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return StateLoading();
          default:
            return !snapshot.hasData
                ? Center(
                    child: Text("Empty"),
                  )
                : Stack(
                    children: [
                      Container(color: kPrimaryColor),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                "Type the country name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: this._typeAheadController,
                                decoration: InputDecoration(
                                  hintText: 'Type here State name',
                                  hintStyle: TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(20),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(
                                        left: 24.0, right: 16.0),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return _getSuggestions(snapshot.data, pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  this._typeAheadController.text = suggestion;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StateStatistics(
                              stateSummary: snapshot.data,
                              stateName: _typeAheadController.text,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
        }
      },
    );
  }
}
