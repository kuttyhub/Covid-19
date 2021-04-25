import 'distric_model.dart';

class StateModel {
  final String state;
  final List<DistricModel> districts;

  StateModel({this.state, this.districts});
}

List<StateModel> getStatefromJson(Map<String, dynamic> json) {
  List<StateModel> stateSummary = [];
  json.forEach((key, value) {
    if (key != 'statecode' && key != 'State Unassigned') {
      stateSummary.add(
        StateModel(
          state: key,
          districts: districFromJson(value['districtData']),
        ),
      );
    }
  });
  return stateSummary;
}
