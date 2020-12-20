import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/backend/others.dart';

class Company {
  String id,
      name,
      description,
      imgURL,
      coverURL,
      email,
      face,
      twitter,
      snapshat,
      youtube,
      instagram,
      phone,
      lat,
      lng,
      distanceBetween,
      secID,
      subSecID,
      locationName;

  Company(
      {@required this.imgURL,
      @required this.name,
      @required this.description,
      @required this.id});

  Company.fromMap(Map<String, dynamic> json)  {
    this.id = json['id'];
    this.name = json['Name'];
    this.description = json['Description'];
    this.imgURL = json['Image'];
    this.email = json['Email'];
    this.face = json['Facebook'];
    this.face = json['Snapchat'];
    this.twitter = json['Twitter'];
    this.youtube = json['Youtube'];
    this.instagram = json['Instagram'];
    this.phone = json['Mobile'];
    this.lat = json['lat'];
    this.lng = json['lon'];
    this.secID=json['IdSections'];
    this.subSecID=json['subSecID'];
    this.coverURL=json['Photo'];
  
  }
}
