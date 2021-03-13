import 'package:flutter/foundation.dart';

class Section {
  String id, name, description, imgURL;

  Section(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.imgURL});

  Section.fromMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['Name'];
    this.imgURL = json['Images'];
    this.description = json['Description'];
  }
}
