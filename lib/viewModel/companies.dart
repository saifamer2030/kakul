import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/backend/others.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/companyInSection.dart';

class CompanyProvider extends ChangeNotifier {
   List<Company> companies = [];

  CompanyProvider() {
    if(companies.isEmpty)
    getAllCompanies().then((v) async {
      companies.addAll(v);
      print('id'+companies[10].id);
      await updateDistanceBetween();
      notifyListeners();
    });
  }

  updateDistanceBetween() async {
    await Future.forEach(companies, (Company company) async {
     
     print('Index:${companies.indexOf(company)}');

      String locName = await getLocName(company.lat, company.lng);
      company.locationName = locName;

      LatLng latlng = await getCurrentLocation();

      int distance = await calculateDistance(
          fromLat: latlng.latitude,
          fromLng: latlng.longitude,
          toLat: double.parse(company.lat),
          toLng: double.parse(company.lng));
      company.distanceBetween = distance.toString();
  //    print('MyDis:${company.distanceBetween}');
    });
  }

  
}
