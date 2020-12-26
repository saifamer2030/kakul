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
import 'package:kul_last/model/globals.dart' as globals;

class AddNewJob extends StatefulWidget {
  @override
  _AddNewJobState createState() => _AddNewJobState();
}

class _AddNewJobState extends State<AddNewJob> {



  var salaryController = TextEditingController();
  var workhoursController = TextEditingController();
  var detailsController = TextEditingController();
  List<String> sextype = ["ذكر","انثى","غير محدد"];
 String selectedsextype;
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
              Text('إضافة وظيفة جديدة', style: TextStyle(color: Colors.black54)),
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
                            controller: workhoursController,
                            decoration: InputDecoration(
                              hintText: 'ساعات العمل',
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
                            controller: salaryController,
                          //  keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'المرتب',
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
                          color: Colors.white,
                          child: DropdownButton(
                              isExpanded: true,
                              value: selectedsextype,
                              hint: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'النوع',
                                  style: TextStyle(fontFamily: 'jareda'),
                                ),
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black54),
                              underline: Container(),
                              onChanged: (sec) {
                                setState(() {
                                  selectedsextype = sec;
                                });
                              },
                              items:  sextype.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,

                                    ));
                              }).toList(),),
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
                          height: 100,
                          color: MyColor.customColor,
                        ),
                        Expanded(
                            child: Container(
                          height: 100,
                          child: TextField(
                            controller: detailsController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'الوصف',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )),
                        Container(
                          width: 3,
                          height: 100,
                          color: MyColor.customColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                                  Text('جاري إضافة الوظيفة')
                                ],
                              ),
                            ),
                          );
                          await addjob(
                              globals.myCompany.id,
                              globals.myCompany.name,
                              globals.myCompany.imgURL,
                              globals.myCompany.phone,
                           salaryController.text,
                           workhoursController.text,
                           detailsController.text,
                           selectedsextype
                          )
                              .then((v) {
                            Fluttertoast.showToast(
                                msg: "تمت الإضافة بنجاح",
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
                      child: Text(' إضافة'),
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
    if (salaryController.text.isEmpty ||
        detailsController.text.isEmpty ||
        workhoursController.text.isEmpty) {
      showSnackMsg('من فضلك املأ الفراغات المطلوبة');
      return false;
    } else if (sextype == null ) {
      showSnackMsg('قم باختيار الأقسام كاملة');
      return false;
    }
    return true;
  }
}
