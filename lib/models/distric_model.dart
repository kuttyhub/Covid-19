class Distric {
  final String distric;
  final int active;
  final int death;
  final int confirmed;
  final int recovered;

  Distric(
      {this.distric, this.confirmed, this.death, this.recovered, this.active});
}
List<Distric> districFromJson(Map<String, dynamic> json) {
    List<Distric> disList;
    json.forEach((key, value) {
      if (key != "statecode") {
        disList.add(Distric(
          distric: key,
          active: value['active'],
          confirmed: value['confirmed'] + value['delta']['confirmed'],
          recovered: value['recovered'] + value['delta']['recovered'],
          death: value['deceased'] + value['delta']['deceased'],
        ));
      }
    });
    return [...disList];
  }