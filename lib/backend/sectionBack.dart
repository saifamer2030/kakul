import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kul_last/model/advertisment.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/companyInmap.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/jobtype.dart';
import 'package:kul_last/model/map_helper.dart';
import 'package:kul_last/model/map_marker.dart';
import 'package:kul_last/model/message.dart';
import 'package:kul_last/model/myplan.dart';
import 'package:kul_last/model/news.dart';
import 'package:kul_last/model/offer.dart';
import 'package:kul_last/model/photo.dart';
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/model/section.dart';
import 'package:kul_last/model/subSection.dart';
import 'package:kul_last/view/companyDetails.dart';
import 'package:kul_last/view/companyDetailsmap.dart';
import 'package:kul_last/view/photoswiper.dart';
import 'package:mime/mime.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:multi_image_picker/multi_image_picker.dart';

import 'others.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getAllSections() async {
  List<Section> sections = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllSections.php";
  var client = Client();

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Sections'];
    jsonSecList.forEach((item) {
      sections.add(Section.fromMap(item));
    });
    return sections;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getAllSubSections(String secID) async {
  List<SubSection> subSections = [];
  String baseURL = "http://kk.vision.com.sa/API/GetSubSection.php?Spid=$secID";
  var client = Client();

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['SubSection'];
    jsonSecList.forEach((item) {
      subSections.add(SubSection.fromMap(item));
    });
    return subSections;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getUserCompany(String userID) async {
  // List<Company> companies = [];
  Company company;

  String baseURL =
      "http://kk.vision.com.sa/API/GeTMyCompanies.php?UserId=$userID";
  var client = Client();

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    jsonSecList.forEach((item) {
      company = Company.fromMap(item);
    });
    return company;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getCompanySection(String secID) async {
  List<Company> companies = [];
  String baseURL =
      "http://kk.vision.com.sa/API/GetCompaniesIdSections.php?Spid=$secID";
  var client = Client();

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    jsonSecList.forEach((item) {
      if((item['Accept']=="1")&&(item['user_only']=="0")){

        companies.add(Company.fromMap(item));}
    });
    return companies;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}


Future<dynamic> getAllCompanies1() async {
  List<Company> companies = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllCompanies.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    String Address="aaaa";  String distance="22222";
    //  for(int j=0;j<jsonSecList.length;j++){}
    globals.allcompanies.clear();
    jsonSecList.forEach((item)    {
      Timer(Duration(seconds: 0), () async {
       if((item['Accept']=="1")&&(item['user_only']=="0")){
          String locName = await getLocName(item['lat'], item['lon']);
          item['locationName']= locName;

          LatLng latlng = await getCurrentLocation().then((value) {
            Timer(Duration(seconds: 0), () async {
            int distance = await calculateDistance(
                fromLat: value.latitude,
                fromLng: value.longitude,
                toLat: double.parse(item['lat']),
                toLng: double.parse(item['lon'])).then((value1) {
              item['distanceBetween'] = value1.toString();
              print("ggg///$item");
             // globals.allcompanies.clear();
             // companies.add(Company.fromMap(item));
             // companies.sort((fl1, fl2) => fl1.distanceBetween.compareTo(fl2.distanceBetween));

               globals.allcompanies.add(Company.fromMap(item));
             // globals.allcompanies.addAll(companies);
             // globals.allcompanies.sort((fl1, fl2) => fl1.distanceBetween.compareTo(fl2.distanceBetween));
              globals.allcompanies.sort((fl1, fl2) =>int.parse(fl1.distanceBetween) .compareTo(int.parse(fl2.distanceBetween)));
            //  print("aaa${ globals.allcompanies}");
            });
            });
          });

   }
//  String Accept,  user_only;
        //       Timer(Duration(seconds: 0), () async {
        //      double lat2=double.parse(item['lat'].toString().trim());
        //      double  lon2= double.parse(item['lon'].toString().trim());
        //      print("ggg${item['lat'].toString()}");
        //
        //   //   LatLng latlng = globals.latlng;
        //      double lat1=globals.lat;
        //      double  lon1= globals.lng;
        //      //print("ggg/${globals.latlng.latitude.toString()}");
        //
        //      var pi = 0.017453292519943295;
        //      var c = cos;
        //      var a = 0.5 -
        //          c((lat2 - lat1) * pi) / 2 +
        //          c(lat1 * pi) * c(lat2 * pi) * (1 - c((lon2 - lon1) * pi)) / 2;
        //       distance= (12742 * asin(sqrt(a))).toString();
        //      // if(distance<100.0){
        //      try {
        //        List<Placemark> p = await Geolocator().placemarkFromCoordinates(
        //            double.parse(item['lat'].toString().trim()),
        //            double.parse(item['lon'].toString().trim())
        //        );
        //
        //        Placemark place = p[0];
        //        String name = place.name;
        //        String subLocality = place.subLocality;
        //        String locality = place.locality;
        //        String administrativeArea = place.administrativeArea;
        //        String postalCode = place.postalCode;
        //        String country = place.country;
        //
        //        Address ="${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
        //        item['locationName']=Address;
        //        item['distanceBetween']=distance;
        //        print("ggg$Address$distance");
        //
        //        companies.add(Company.fromMap(item));
        //       // companies.sort((fl1, fl2) => fl1.distanceBetween.compareTo(fl2.distanceBetween));
        //
        //      } catch (e) {
        //        print(e);
        //      }
        // });



      });
    });
    return companies;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}














Future<dynamic> getAllCompanies() async {
  List<Company> companies = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllCompanies.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    String Address="aaaa";  String distance="22222";
  //  for(int j=0;j<jsonSecList.length;j++){}
    jsonSecList.forEach((item)    {
if((item['Accept']=="1")&&(item['user_only']=="0")){
      companies.add(Company.fromMap(item));
}
//  String Accept,  user_only;
   //       Timer(Duration(seconds: 0), () async {
   //      double lat2=double.parse(item['lat'].toString().trim());
   //      double  lon2= double.parse(item['lon'].toString().trim());
   //      print("ggg${item['lat'].toString()}");
   //
   //   //   LatLng latlng = globals.latlng;
   //      double lat1=globals.lat;
   //      double  lon1= globals.lng;
   //      //print("ggg/${globals.latlng.latitude.toString()}");
   //
   //      var pi = 0.017453292519943295;
   //      var c = cos;
   //      var a = 0.5 -
   //          c((lat2 - lat1) * pi) / 2 +
   //          c(lat1 * pi) * c(lat2 * pi) * (1 - c((lon2 - lon1) * pi)) / 2;
   //       distance= (12742 * asin(sqrt(a))).toString();
   //      // if(distance<100.0){
   //      try {
   //        List<Placemark> p = await Geolocator().placemarkFromCoordinates(
   //            double.parse(item['lat'].toString().trim()),
   //            double.parse(item['lon'].toString().trim())
   //        );
   //
   //        Placemark place = p[0];
   //        String name = place.name;
   //        String subLocality = place.subLocality;
   //        String locality = place.locality;
   //        String administrativeArea = place.administrativeArea;
   //        String postalCode = place.postalCode;
   //        String country = place.country;
   //
   //        Address ="${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
   //        item['locationName']=Address;
   //        item['distanceBetween']=distance;
   //        print("ggg$Address$distance");
   //
   //        companies.add(Company.fromMap(item));
   //       // companies.sort((fl1, fl2) => fl1.distanceBetween.compareTo(fl2.distanceBetween));
   //
   //      } catch (e) {
   //        print(e);
   //      }
   // });




    });
    return companies;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> getCompanyJobstype(String companyID) async {
  String baseURL = "http://kk.vision.com.sa/API/GetJob.php?Spid=$companyID";
  var client = Client();
  List<Job> jobs = [];
  JobType jobtype;
  bool m=false;
  bool f=false;
//int checkoffers;
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {

      // checkoffers= await getCompanyofferlength(companyID).then((offerlen) {
      //
      // });
      List jsonList = json["Job"];
      jsonList.forEach((item) {
        if(item['Sex']=="ذكر"){
         m=true;
         f=false;
        }else if(item['Sex']=="انثى"){
         f=true;
         m=false;
        }else {
          f=true;
          m=true;
        }
       // jobs.add(Job.fromMap(i));
      });
      return JobType(m,f);
    }
    return JobType(m,f);
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<int> getCompanyofferlength(String companyID) async {
  String baseURL = "http://kk.vision.com.sa/API/GetOffer.php?Spid=$companyID";
  var client = Client();
  List<Offer> offers = [];
int length=0;
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonList = json["Offers"];
      jsonList.forEach((i) {
        offers.add(Offer.fromMap(i));
      });
      print("zzz${offers.length}");
      return offers.length;
    } else {
      print("zzz0}");
      return 0;
    }
  }
  print("zzz0");
  return 0;
}
///////////////////////////
Future<dynamic> getAllCompaniesmap(BuildContext context) async {
  List<CompanyMap> companies = [];
  print("hhh4");
  JobType jobtype;int checkoffers;
  String baseURL = "http://kk.vision.com.sa/API/GetAllCompanies.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    //int jobcolor=0;
   // int i=-1;
    var jobcolor = new List<int>.generate(jsonSecList.length, (i) => 0);

    for(int j=0;j<jsonSecList.length;j++) {
       if((jsonSecList[j]['Accept']=="1")&&(jsonSecList[j]['user_only']=="0")){

      globals.companies.clear();
      //  i++;
      Timer(Duration(seconds: 0), () async {
        jobtype = await getCompanyJobstype(jsonSecList[j]['id']).then((value) {
          if (value.male && value.fmale) {
            jobcolor[j] = 3;
          } else if (value.male == true && value.fmale == false) {
            jobcolor[j] = 1;
          } else if (value.male == false && value.fmale == true) {
            jobcolor[j] = 2;
          } else {
            jobcolor[j] = 0;
          }
          print("ppppp" + jobcolor.toString());
          Timer(Duration(seconds: 0), () async {
            checkoffers =
            await getCompanyofferlength(jsonSecList[j]['id']).then((offerlen) {
              Timer(Duration(seconds: 0), () async {
                var markerImage = await MapHelper.getMarkerIcon(
                    jsonSecList[j]['Image'], 125.0, jobcolor[j], offerlen)
                    .then((value) {
                  jsonSecList[j]['jobcolor'] =jobcolor[j];
                  jsonSecList[j]['offercolor'] =offerlen;
                  jsonSecList[j]['marker'] = Marker(
                    markerId: MarkerId(
                      jsonSecList[j]['id'],
                    ),
                    position: LatLng(
                        double.parse(jsonSecList[j]['lat'].toString()),
                        double.parse(jsonSecList[j]['lon'].toString())),
                    icon: value,
                    infoWindow: InfoWindow(title: jsonSecList[j]['Name'],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PhotoSwiper(CompanyMap.fromMap(jsonSecList[j]))));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CompanyDetailsMap(CompanyMap.fromMap(jsonSecList[j]))));
                        }),
                  );
                  companies.add(CompanyMap.fromMap(jsonSecList[j]));
                  globals.companies.addAll(companies);
                });
              });
            });
          });
        });
      });
    }
    }
//     jsonSecList.forEach((item) async {
//       globals.companies.clear();
// i++;
//       Timer(Duration(seconds: 0), () async {
//         jobtype=await  getCompanyJobstype(item['id']).then((value) {
//           if(value.male&&value.fmale){
//             jobcolor=3;
//           }else if(value.male==true&&value.fmale==false){
//             jobcolor=1;
//           }else if(value.male==false&&value.fmale==true){
//             jobcolor=2;
//           }else{jobcolor=0;}
//           print("ppppp"+jobcolor.toString());
//           Timer(Duration(seconds: 0), () async {
//           checkoffers= await getCompanyofferlength(item['id']).then((offerlen) {
//             Timer(Duration(seconds: 0), () async {
//
//               var markerImage = await MapHelper.getMarkerIcon(item['Image'],125.0,jobcolor,offerlen).then((value) {
//
//                 item['marker']= Marker(
//                   markerId: MarkerId(
//                     item['id'],
//                   ),
//                   position: LatLng(double.parse(item['lat'].toString()), double.parse(item['lon'].toString())),
//                   icon: value,
//                   infoWindow: InfoWindow(title: item['Name'],
//                       onTap: (){
//                         // Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) =>
//                         //             CompanyDetails(jsonSecList[i])));
//                       }),
//                 );
//                 companies.add(CompanyMap.fromMap(item));
//                 globals.companies.addAll(companies);
//               });
//             });
//           });
//           });
//         });
//
//
//       });
//       });



    return companies;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> getFeaturedCompanies() async {
  List<Company> companies = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllCompaniesSP.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    jsonSecList.forEach((item) {
    //  if((item['Accept']=="1")&&(item['user_only']=="0")){

        companies.add(Company.fromMap(item));
      //}
    });
    return companies;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getSuggestedCompanies() async {
  List<Company> companies = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllCompaniesRN.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Companies'];
    jsonSecList.forEach((item) {
      companies.add(Company.fromMap(item));
    });
    return companies;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getCompanyImgs({String companyID}) async {
  String baseURL = "http://kk.vision.com.sa/API/GetImages.php?Spid=$companyID";
  List<String> urls = [];
  var client = Client();

  Response response = await client.get(baseURL);
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonSecList = json['Images'];
      jsonSecList.forEach((item) {
        urls.add(item['Image']);
      });
      return urls;
    }
    return null;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getCompanyJobs({String companyID}) async {
  String baseURL = "http://kk.vision.com.sa/API/GetJob.php?Spid=$companyID";
  var client = Client();
  List<Job> jobs = [];

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonList = json["Job"];
      jsonList.forEach((i) {
        jobs.add(Job.fromMap(i));
      });
      return jobs;
    }
    return null;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getCompanyNews({String companyID}) async {
  String baseURL = "http://kk.vision.com.sa/API/GetNews.php?Spid=$companyID";
  var client = Client();
  List<New> news = [];

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonList = json["News"];
      jsonList.forEach((i) {
        news.add(New.fromMap(i));
      });
      return news;
    } else {
      return null;
    }
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> addjob(
Companyid,
Companyname,
CompanyimgURL,
Companyphone,
salary,
workhours,
details,
sextype,
expertype,
edutype,
   ) async {
   var baseURL='http://kk.vision.com.sa/API/AddJob.php?Name=$Companyname&Sex=$sextype&Salary=$salary&WorkHours=$workhours&Education=$edutype&Experience=$expertype&Details=$details&Id-Us=$Companyid';
  print("llll");
  var client = Client();
  print("lll$edutype");
  Response response = await client.get(baseURL)
      .then((value){
    print("lll${value.body}//${Companyname}///$salary//$sextype");
  });

}

Future<dynamic> addnews(
    Companyid,
    Companyname,
    CompanyimgURL,
    Companyphone,

    details,
    secid
    ) async {

  var baseURL ='http://kk.vision.com.sa/API/AddNews.php?Name=$secid&Topic=$details&IdSubSection=$secid&us-id=$Companyid&Image=$CompanyimgURL';
  //  baseURL_APP+'Drivers/UpdateOrderIDLocations.php?OrderID=${widget.orderID}&DriverID=${widget.driverId}&driver_lat=${lat}&driver_long=${long}';
  var client = Client();
  Response response = await client.get(baseURL)
      .then((value){
    print("lll${value.body}//${Companyname}///$secid//$details");
  });
  // http.Response response = await http.get(baseURL,
  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json'
  //     }).then((value){
  //   //print("lll${value.body}//${widget.orderID}///$lat//$long");
  // });
  // print("lll${response.body}//${widget.orderID}$lat//$long");
}



Future<dynamic> getAllJobs() async {
  List<Job> jobs = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllJob.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Job'];
    jsonSecList.forEach((item) {
      jobs.add(Job.fromMap(item));
    });
    return jobs;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> getAllNews() async {
  List<New> news = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllNews.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['News'];
    jsonSecList.forEach((item) {
      news.add(New.fromMap(item));
    });
    return news;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> getAllAdvert() async {
  List<Advertisment> advertisment = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllADS.php";
  var client = Client();
  Response response = await client.get(baseURL);
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['ADS'];
    jsonSecList.forEach((item) {
      advertisment.add(Advertisment.fromMap(item));
      //  print("hhhh${item}");

    });
    return advertisment;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}


Future<dynamic> registeruser(
    {String companyName,
      File profileImage,
      String description,
      String secID,
      String subSecID,
      String subscribtion,
      String email,
      String password,
      String facebook,
      String twitter,
      String youtube,
      String snapchat,
      String instagram,
      File coverImg,
      String phone,
      String commRecord,
      String lat,
      String lng,
      String title}) async {

  String url = 'http://kk.vision.com.sa/API/NewUser.php?';
  Map<String, String> headers = {'Cookie': 'PHPSESSID=a214u1u1v8pgrdj2p6dpb5n8l1'};
  //String copoun = (pinController.text == null) ? '' : pinController.text;
  //print('Coup:$copoun');
  var formData = dio.FormData.fromMap({
    "Name": companyName,
    "Image":"",
    "Description": description,
    "IdSections": secID,
    "IdSubSection": subSecID,
    "Subscription": subscribtion,
    "Email": email,
    "Password": password,
    "Facebook": facebook,
    "Twitter": twitter,
    "YouTube": youtube,
    "Snapchat":snapchat,
    "Instagram": instagram,
    "Photo":"",
    "Mobile": phone,
    "CommercialReg":commRecord,
    "lat": lat,
    "lon": lng,
    "Title": title
  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
 print('Status:${response.statusCode}');
 print('Response:${response.data.toString()}');
}

// Future<dynamic> registeruser(
//     {String companyName,
//       File profileImage,
//       String description,
//       String secID,
//       String subSecID,
//       String subscribtion,
//       String email,
//       String password,
//       String facebook,
//       String twitter,
//       String youtube,
//       String snapchat,
//       String instagram,
//       File coverImg,
//       String phone,
//       String commRecord,
//       String lat,
//       String lng,
//       String title}) async {
//   String url = 'http://kk.vision.com.sa/API/NewUser.php?';
//   // Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
//   Map<String, String> headers = {'Cookie': 'PHPSESSID=a214u1u1v8pgrdj2p6dpb5n8l1'};
//   var client = Client();
//   Response res = await client.post(url,headers:headers,
//       body:jsonEncode({
//         "Name": companyName,
//         "Image":"",
//         "Description": description,
//         "IdSections": secID,
//         "IdSubSection": subSecID,
//         "Subscription": subscribtion,
//         "Email": email,
//         "Password": password,
//         "Facebook": facebook,
//         "Twitter": twitter,
//         "YouTube": youtube,
//         "Snapchat":snapchat,
//         "Instagram": instagram,
//         "Photo":"",
//         "Mobile": phone,
//         "CommercialReg":commRecord,
//         "lat": lat,
//         "lon": lng,
//         "Title": title
//       })).then((response) {
//     print('Status:${response.statusCode}');
//     print('Response:${response.body.toString()}');
//   } );
//
//
//
// }

Future<dynamic> registerCompany(
    {String id,
      String companyName,
    File profileImage,
    String description,
    String secID,
    String subSecID,
    String subscribtion,
    String email,
    String facebook,
    String twitter,
    String youtube,
    String snapchat,
    String instagram,
    File coverImg,
    String phone,
    String commRecord,
    String lat,
    String lng,
    String title}) async {
  var profileMediaType = {
    lookupMimeType(profileImage.path).split('/')[0]:
        lookupMimeType(profileImage.path).split('/')[1]
  };
  var coverMediaType = {
    lookupMimeType(coverImg.path).split('/')[0]:
        lookupMimeType(coverImg.path).split('/')[1]
  };
  String url = 'http://kk.vision.com.sa/API/UpdateUser.php';
  Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
  var formData = dio.FormData.fromMap({
    "id": id,
    "Name": companyName,
    "Image": await dio.MultipartFile.fromFile(profileImage.path,
        contentType: MediaType(profileMediaType.keys.elementAt(0),
            profileMediaType.values.elementAt(0))),
    "Description": description,
    "IdSections": secID,
    "IdSubSection": subSecID,
    "Subscription": subscribtion,
    "Email": email,

    "Facebook": facebook,
    "Twitter": twitter,
    "YouTube": youtube,
    "Snapchat":snapchat,
    "Instagram": instagram,
    "Photo": await dio.MultipartFile.fromFile(coverImg.path,
        contentType: MediaType(coverMediaType.keys.elementAt(0),
            coverMediaType.values.elementAt(0))),
    "Mobile": phone,
    "CommercialReg":commRecord,
    "lat": lat,
    "lon": lng,
    "Title": title,
    "Accept": "0",
    "user_only": "0"
  });
 // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  print('Status:${response.statusCode}');
  print('Response:${response.data.toString()}');
}





Future<dynamic> getCompanymessage(String companyID) async {
  String baseURL = "http://kk.vision.com.sa/API/GetMessage.php?Spid=${companyID}";
  var client = Client();
  List<Message> message = [];

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonList = json["Messages"];
      jsonList.forEach((i) {
        message.add(Message.fromMap(i));
      });
      return message;
    } else {
      return null;
    }
  }

  return translator.translate('AConnectionErrorHasOccurred');
}

Future<dynamic> registerOffer(
    {String id,
      String name,
      String description,
      String oldprice,
      String newprice,
      File profileImage,

    }) async {
  var profileMediaType = {
    lookupMimeType(profileImage.path).split('/')[0]:
    lookupMimeType(profileImage.path).split('/')[1]
  };

  String url = 'http://kk.vision.com.sa/API/AddOffer.php';
  Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

  //String copoun = (pinController.text == null) ? '' : pinController.text;
  //print('Coup:$copoun');
//الحقول  : title, text, image, new_price, old_price, company_id
  var formData = dio.FormData.fromMap({
    "company_id": id,
    "title": name,
    "image": await dio.MultipartFile.fromFile(profileImage.path,
        contentType: MediaType(profileMediaType.keys.elementAt(0),
            profileMediaType.values.elementAt(0))),
    "text": description,
    "old_price": oldprice,
    "new_price": newprice,
  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  print('Status:${response.statusCode}');
  print('Response:${response.data.toString()}');
}
Future<dynamic> deleteOffer({String id}) async {
  var baseURL =
      "http://kk.vision.com.sa/API/DeleteOffer.php?id=$id";
  var client = Client();
  Response response = await client.get(baseURL)
      .then((value){
    print("lll${value.body}//${value.request}//");
  });
}
Future<dynamic> deleteJob({String id}) async {
  var baseURL =
      "http://kk.vision.com.sa/API/DeletesJob.php?id=$id";
  var client = Client();
  Response response = await client.get(baseURL)
      .then((value){
    print("lll${value.body}//${value.request}//");
  });
}
Future<dynamic> deleteNews({String id}) async {
  var baseURL =
      "http://kk.vision.com.sa/API/DeleteNews.php?id=$id";
  var client = Client();
  Response response = await client.get(baseURL)
      .then((value){
    print("lll${value.body}//${value.request}//");
  });
}


Future<dynamic> getCompanyoffers({String companyID}) async {
  String baseURL = "http://kk.vision.com.sa/API/GetOffer.php?Spid=$companyID";
  var client = Client();
  List<Offer> offers = [];

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonList = json["Offers"];
      jsonList.forEach((i) {
        offers.add(Offer.fromMap(i));
      });
      return offers;
    } else {
      return null;
    }
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> getAlloffers() async {
  List<Offer> offers = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllOffer.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Offers'];
    jsonSecList.forEach((item) {
      offers.add(Offer.fromMap(item));
    });
    return offers;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> getSimilaroffers(String similarsec,String similarsubsec) async {
  List<Offer> offers = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllOffer.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Offers'];
    jsonSecList.forEach((item) {
      if(item['IdSubSection']==similarsubsec){
      offers.add(Offer.fromMap(item));
      }
    });
    jsonSecList.forEach((item) {
      if((item['IdSections']==similarsec)&&(item['IdSubSection']!=similarsubsec)){
        offers.add(Offer.fromMap(item));
      }
    });
    return offers;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> getSimilarJobs(String similarsec,String similarsubsec) async {
  List<Job> jobs = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllJob.php";
  var client = Client();
  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    List jsonSecList = json['Job'];
    // jsonSecList.forEach((item) {
    //   jobs.add(Job.fromMap(item));
    // });

    jsonSecList.forEach((item) {
      if(item['IdSubSection']==similarsubsec){
        jobs.add(Job.fromMap(item));
      }
    });
    jsonSecList.forEach((item) {
      if((item['IdSections']==similarsec)&&(item['IdSubSection']!=similarsubsec)){
        jobs.add(Job.fromMap(item));
      }
    });




    return jobs;
  }

  return translator.translate('AConnectionErrorHasOccurred');
}



Future<dynamic> registerCompanyphotos1(
    {String id,
      List<Asset>  coverImg}) async {
  List<dio.MultipartFile> images = [];
  for (int i = 0; i < coverImg.length; i++) {
    var path = await FlutterAbsolutePath.getAbsolutePath(coverImg[i].identifier);
dio.MultipartFile a =await dio.MultipartFile.fromFile(path,
    contentType: MediaType("image", "jpg"));
    images.add(a);
    String url = 'http://kk.vision.com.sa/API/UpdateUser.php';
    Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
    var formData = dio.FormData.fromMap({
      "Spid": id,
      "Image": a,

    });
    // print('FormData:${formData.fields}');
    dio.Response response = await dio.Dio()
        .post(url, data: formData, options: dio.Options(headers: headers));
    print('Status:${response.statusCode}');
    print('Response:${response.data.toString()}');
  }


}

Future<dynamic> registerCompanyphotos(
    {String id,
       File coverImg,
    }) async {

  var coverMediaType = {
    lookupMimeType(coverImg.path).split('/')[0]:
    lookupMimeType(coverImg.path).split('/')[1]
  };
  String url = 'http://kk.vision.com.sa/API/AddImage.php';
  Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
  var formData = dio.FormData.fromMap({
    "Spid": id,
    "Image": await dio.MultipartFile.fromFile(coverImg.path,
        contentType: MediaType(coverMediaType.keys.elementAt(0),
            coverMediaType.values.elementAt(0))),
  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  print('Status:${response.statusCode}');
  print('Response:${response.data.toString()}');
}
Future<dynamic> getCompanyphoto(String companyID) async {
  String baseURL = "http://kk.vision.com.sa/API/GetImage.php?Spid=${companyID}";
  var client = Client();
  List<Photo> photo = [];

  Response response = await client.get(baseURL);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    if (json['success'] == 1) {
      List jsonList = json["Images"];
      jsonList.forEach((i) {
        photo.add(Photo.fromMap(i));
      });
      return photo;
    } else {
      return null;
    }
  }

  return translator.translate('AConnectionErrorHasOccurred');
}
Future<dynamic> deletCompanyphoto(String photoID) async {
  String baseURL = "http://kk.vision.com.sa/API/DeleteImage.php?id=${photoID}";
  var client = Client();
  Response response = await client.get(baseURL)
      .then((value){
    print("lll${value.body}//${value.request}//");
  });

}
Future<dynamic> getallplans() async {
  List<Plan> plans = [];

  String url = 'http://kk.vision.com.sa/API/Plans.php';
  Map<String, String> headers = {   'Content-type': 'application/json',
    'Accept': 'application/json'};

  var formData = dio.FormData.fromMap({
    "req_type": "getAll",
  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  if (response.statusCode == 200) {
    var json = jsonDecode(response.data);
    if (json['success']) {
      List jsonList = json["data"];
      print('Responsepp11:${jsonList.toString()}');
      jsonList.forEach((i) {
        plans.add(Plan.fromMap(i));
        print('Responsepp11:${Plan.fromMap(i).text}');
      });
      return plans;
    } else {
      return null;
    }
  }

  print('Status:${response.statusCode}');
  print('Responsepp:${response.data.toString()}');
}

Future<dynamic> getmyplans(id) async {
  List<MyPlan> plans = [];

  String url = 'http://kk.vision.com.sa/API/Subscribe.php';
  Map<String, String> headers = {   'Content-type': 'application/json',
    'Accept': 'application/json'};

  var formData = dio.FormData.fromMap({
    "req_type": "getByUserID",
    "user_id": id

  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  if (response.statusCode == 200) {
    var json = jsonDecode(response.data);
    if (json['success']) {
      List jsonList = json["data"];
      print('Responsepp11:${jsonList.toString()}');
      jsonList.forEach((i) {
        plans.add(MyPlan.fromMap(i));
        print('Responsepp11:${MyPlan.fromMap(i).id}');
      });
      return plans;
    } else {
      return plans;
    }
  }

  print('Status:${response.statusCode}');
  print('Responsepp:${response.data.toString()}');
}


Future<dynamic> creatmyplan(id) async {
  String url = 'http://kk.vision.com.sa/API/Subscribe.php';
  Map<String, String> headers = {   'Content-type': 'application/json',
    'Accept': 'application/json'};

  var formData = dio.FormData.fromMap({
    "req_type": "create",
    "user_id": id,
    "plan_id": 4,
    "status" : "1"


  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  print('Status:${response.statusCode}');
  print('Responsepp:${response.data.toString()}kkk');
}

Future<dynamic> creatmyplanwithpay(user_id,plan_id,price,
paymentCard_type,_paymentCard_number,_paymentCard_month,_paymentCard_year,
_paymentCard_cvv,_paymentCard_name) async {
  String url = 'http://kk.vision.com.sa/API/Subscribe.php';
  Map<String, String> headers = {   'Content-type': 'application/json',
    'Accept': 'application/json'};

  var formData = dio.FormData.fromMap({
    "req_type": "create",
    "user_id": user_id,
    "plan_id": plan_id,
    "status" : "1",

    "amount": "$price",
    "currency": "SAR",
    "paymentBrand": "${paymentCard_type}",
    "paymentType" : "DE",

    "number": "${_paymentCard_number}",
    "expiryMonth":"${_paymentCard_month}",
    "expiryYear":"${_paymentCard_year}",
    "cvv" :"${_paymentCard_cvv}",
  "holder" : "${_paymentCard_name}",

  });
  // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
  print('Status:${response.statusCode}');
  print('Responsepp:${response.data.toString()}kkk');
}