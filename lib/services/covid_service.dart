
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:covid19/models/state.dart';
import '../models/country_summary.dart';

class CovidService {

  Future<List<CountrySummaryModel>> getCountrySummary() async {
    final data = await http.Client()
        .get(Uri.https('api.covid19api.com', 'total/dayone/country/india'));

    if (data.statusCode != 200) throw Exception();

    List<CountrySummaryModel> summaryList = (json.decode(data.body) as List)
        .map((item) => new CountrySummaryModel.fromJson(item))
        .toList();

    return summaryList;
  }

  Future getStateSummary() async {
    final data =
        await http.Client().get(Uri.https('api.covid19india.org','state_district_wise.json'));

    if (data.statusCode != 200) throw Exception();

    List<State> summaryList = getStatefromJson(json.decode(data.body));
    return summaryList;
  }
}
