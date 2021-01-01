library my_prj.globals;


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/companyInmap.dart';
import 'package:kul_last/model/userModel.dart';


List<CompanyMap> companies = [];
User myuser=null;
Company myCompany=Company();
double lat=0.0;
double lng=0.0;
List<Company> allcompanies = [];
