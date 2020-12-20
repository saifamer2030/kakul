import 'dart:convert';

import 'package:http/http.dart';
import 'package:kul_last/model/userModel.dart';

Future<dynamic> userLogin(String mail, String pass) async {
  String baseURL =
      "http://kk.vision.com.sa/API/GetUser.php?username=$mail&password=$pass";

  var client = Client();
  Response res = await client.get(baseURL);

  print(res.body);
  var json = jsonDecode(res.body);
  if (json['success'] == 0) {
    client.close();
    return json['message'];
  }
  client.close();
  return User.fromMap(json);
}
