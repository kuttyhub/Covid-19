import 'distric_model.dart';

class StateModel {
  final String state;
  final List<DistricModel> districs;

  StateModel({this.state, this.districs});
}

List<StateModel> getStatefromJson(Map<String, dynamic> json) {
  List<StateModel> stateSummary = [];
  json.forEach((key, value) {
    if (key != 'statecode' && key != 'State Unassigned') {
      stateSummary.add(
        StateModel(
          state: key,
          districs: districFromJson(value['districtData']),
        ),
      );
    }
  });
  return stateSummary;
}
