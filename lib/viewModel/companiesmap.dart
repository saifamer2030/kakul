
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/backend/others.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/companyInmap.dart';

class CompanyMapProvider extends ChangeNotifier {
   List<CompanyMap> companiesmap = [];

   CompanyProvidermap() {
     if(companiesmap.isEmpty)
       print("hhh2");

     // getAllCompaniesmap(context).then((v) async {
     //   print("hhh3");
     //
     //   companiesmap.addAll(v);
     //     print('iddd'+v);
     //     await updateDistanceBetween();
     //     notifyListeners();
     //   });
   }
  updateDistanceBetween() async {
    await Future.forEach(companiesmap, (CompanyMap company) async {

     print('Index:${companiesmap.indexOf(company)}');

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
