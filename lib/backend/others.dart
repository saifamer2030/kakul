import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/globals.dart' as globals;

Future<LatLng> getCurrentLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  globals.lat=(position.latitude);
  globals.lng=( position.longitude);
print("bbb${position.latitude}///${ globals.lat}");
  return LatLng(position.latitude, position.longitude);
}

Future<String> getLocName(String lat, String lng) async {
  double latitude = double.parse(lat);
  double longitude = double.parse(lng);

  List<Placemark> placemark = await Geolocator()
      .placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'ar');
  return placemark[0].subThoroughfare +
      ' ' +
      placemark[0].thoroughfare +
      ' ' +
      placemark[0].subLocality +
      ' ' +
      placemark[0].locality +
      ' ' +
      placemark[0].country;
}

Future<int> calculateDistance(
    {double fromLat, double fromLng, double toLat, double toLng}) async {
  double distanceInMeters =
      await Geolocator().distanceBetween(fromLat, fromLng, toLat, toLng);
  double disKilo = distanceInMeters / 1000;

  return disKilo.floor();
}

updateMyCompanyDistance(Company company) async {
  String locName = await getLocName(company.lat, company.lng);
  company.locationName = locName;

  LatLng latlng = await getCurrentLocation();

  int distance = await calculateDistance(
      fromLat: latlng.latitude,
      fromLng: latlng.longitude,
      toLat: double.parse(company.lat),
      toLng: double.parse(company.lng));
//  company.distanceBetween = distance.toString();
 // print('MyDis:${company.distanceBetween}');
}
