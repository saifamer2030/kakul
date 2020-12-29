import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/section.dart';
import 'package:kul_last/model/subSection.dart';
import 'package:location/location.dart';

import '../myColor.dart';

class RegisterNewUser extends StatefulWidget {
  @override
  _RegisterNewUserState createState() => _RegisterNewUserState();
}

class _RegisterNewUserState extends State<RegisterNewUser> {

  File profileImg;

  File coverImg;

  var mailController = TextEditingController();

  var passController = TextEditingController();

  var confirmPassController = TextEditingController();



  var phoneController = TextEditingController();



  bool checkBoxVal = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  var key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:
              Text('تسجيل حساب جديد', style: TextStyle(color: Colors.black54)),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                        Expanded(
                            child: Container(
                          height: 48,
                          child: TextField(
                            controller: mailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'البريد الالكتروني',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )),
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                        Expanded(
                            child: Container(
                          height: 48,
                          child: TextField(
                            controller: passController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'كلمة المرور',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )),
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                        Expanded(
                            child: Container(
                          height: 48,
                          child: TextField(
                            controller: confirmPassController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'اعادة ادخال كلمة المرور',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )),
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                        Expanded(
                            child: Container(
                          height: 48,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: 'رقم الهاتف',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )),
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          onChanged: (v) {
                            setState(() {
                              checkBoxVal = v;
                            });
                          },
                          value: checkBoxVal,
                          checkColor: Colors.white,
                          activeColor: MyColor.customColor,
                        ),
                        Text(
                            'بالنقر على هذا الزر أكون قد وافقت على شروط الاستخدام'),
                      ],
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: MyColor.customColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        //ValidateRequiredInputs
                        if (validateInputs()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              content: Row(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('جاري تسجيل الشركة')
                                ],
                              ),
                            ),
                          );
                          await registeruser(
                                  companyName: "لا يوجد",
                                  coverImg: null,
                                  description: "",
                                  email: mailController.text,
                                  facebook: "",
                                  instagram:"",
                                  lat: "",
                                  lng:"",
                                  password: passController.text,
                                  phone: phoneController.text,
                                  commRecord: "",
                                  profileImage:null,
                                  secID: "",
                                  snapchat: "",
                                  subscribtion: "0",
                                  subSecID: "",
                                  title: "",
                                  twitter: "",
                                  youtube: "")
                              .then((v) {
                            Fluttertoast.showToast(
                                msg: "تم التسجيل بنجاح",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: MyColor.customColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pop(context);
                          }).whenComplete(() {
                            Navigator.pop(this.context);
                          }).catchError((e) {
                            showSnackMsg(e.toString());
                            print('ErrorRegCompany:$e');
                          }).then((v) {});
                        }
                      },
                      child: Text('سجل الان'),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  showSnackMsg(String msg) {
    key.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
      ),
    ));
  }

  bool validateInputs() {
    if (
        mailController.text.isEmpty ||
        passController.text.isEmpty ||
        phoneController.text.isEmpty) {
      showSnackMsg('من فضلك املأ الفراغات المطلوبة');
      return false;
    } else if (passController.text != confirmPassController.text) {
      showSnackMsg('كلمة المرور غير مطابقة');
      return false;
    } else if (checkBoxVal == false) {
      showSnackMsg('لم يتم الموافقة على شروط الأستخدام');
      return false;
    }
    return true;
  }
}