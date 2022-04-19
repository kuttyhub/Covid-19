import 'package:geocoding/geocoding.dart';

Future<List<Placemark>> getAddressFromCordinates({latitude, longitude}) async {
  var res = await placemarkFromCoordinates(latitude, longitude);
  return res;
}
