import 'distric_model.dart';

class State {
  final String state;
  final List<Distric> districs;

  State({this.state, this.districs});
}

List<State> getStatefromJson(Map<String, dynamic> json) {
  List<State> stateSummary;
  json.forEach((key, value) {
    if (key != 'statecode' && key != 'State Unassigned') {
      stateSummary.add(
        State(
          state: key,
          districs: districFromJson(value['districtData']),
        ),
      );
    }
  });
}
