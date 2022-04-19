import 'dart:developer';

import 'package:covid_hunt/utils/getAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:location/location.dart';

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
  String distName = 'none';
  String currentState = "tamil Nadu";

  @override
  void initState() {
    super.initState();
    states = covidService.getStateSummary();
    getUserLocation();
    // log(states.toString());
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
    var addresses = await getAddressFromCordinates(
        latitude: myLocation.latitude, longitude: myLocation.longitude);
    var first = addresses.first;
    // log(first.toString());
    // log('->>${first.administrativeArea}');
    // log("-->${first.subAdministrativeArea}");
    setState(() {
      currentState = first.administrativeArea;
      distName = first.subAdministrativeArea;
      this._typeAheadController.text = currentState;
    });
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
    // print("TypeAched " + _typeAheadController.text);
    _typeAheadController.text = _typeAheadController.text == ''
        ? currentState
        : _typeAheadController.text;
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
                    child: Text(
                      snapshot.error.toString().contains('SocketException')
                          ? "Please check your network"
                          : 'Internal Error',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(color: kPrimaryColor),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 30, bottom: 10, left: 10, right: 10),
                              child: Text(
                                "Type the State name",
                                style: TextStyle(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                                      color: Colors.grey,
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
                              currentStateName: currentState,
                              currentDistName: distName,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 30, bottom: 10, left: 10, right: 10),
                          child: Text(
                            "Type the State name",
                            style: TextStyle(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                                padding: EdgeInsets.only(left: 24.0, right: 16.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey,
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
                          currentStateName: currentState,
                          currentDistName: distName,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                        ),
                      ],
                    ),
                );
        }
      },
    );
  }
}
