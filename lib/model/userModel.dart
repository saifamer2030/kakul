
import 'package:flutter/foundation.dart';

class User{
  String id,mail,name;

  User({@required this.id,@required this.mail,@required this.name});

  User.fromMap(Map<String,dynamic> json){
    this.name=json['Name'];
    this.mail=json['Email'];
    this.id=json['id'];
  }
}