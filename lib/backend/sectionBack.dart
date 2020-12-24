import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/map_helper.dart';
import 'package:kul_last/model/map_marker.dart';
import 'package:kul_last/model/news.dart';
import 'package:kul_last/model/section.dart';
import 'package:kul_last/model/subSection.dart';
import 'package:mime/mime.dart';

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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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
      companies.add(Company.fromMap(item));
    });
    return companies;
  }

  return 'حدث خطأ في الاتصال';
}

Future<dynamic> getAllCompanies() async {
  List<Company> companies = [];
  String baseURL = "http://kk.vision.com.sa/API/GetAllCompanies.php";
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

  return 'حدث خطأ في الاتصال';
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
      companies.add(Company.fromMap(item));
    });
    return companies;
  }

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
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

  return 'حدث خطأ في الاتصال';
}

Future<dynamic> registerCompany(
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
  var profileMediaType = {
    lookupMimeType(profileImage.path).split('/')[0]:
        lookupMimeType(profileImage.path).split('/')[1]
  };
  var coverMediaType = {
    lookupMimeType(coverImg.path).split('/')[0]:
        lookupMimeType(coverImg.path).split('/')[1]
  };
  String url = 'http://kk.vision.com.sa/API/NewUser.php?';
  Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

  //String copoun = (pinController.text == null) ? '' : pinController.text;
  //print('Coup:$copoun');

  var formData = dio.FormData.fromMap({
    "Name": companyName,
    "Image": await dio.MultipartFile.fromFile(profileImage.path,
        contentType: MediaType(profileMediaType.keys.elementAt(0),
            profileMediaType.values.elementAt(0))),
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
    "Photo": await dio.MultipartFile.fromFile(coverImg.path,
        contentType: MediaType(coverMediaType.keys.elementAt(0),
            coverMediaType.values.elementAt(0))),
    "Mobile": phone,
    "CommercialReg":commRecord,
    "lat": lat,
    "lon": lng,
    "Title": title
  });
 // print('FormData:${formData.fields}');
  dio.Response response = await dio.Dio()
      .post(url, data: formData, options: dio.Options(headers: headers));
//  print('Status:${response.statusCode}');
//  print('Response:${response.data.toString()}');
}
