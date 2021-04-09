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

class AddNewNews extends StatefulWidget {
  @override
  _AddNewNewsState createState() => _AddNewNewsState();
}

class _AddNewNewsState extends State<AddNewNews> {



  // var salaryController = TextEditingController();
   var titleController = TextEditingController();
  var detailsController = TextEditingController();
  List<Section> sections = [];
  Section selectedSection;

  String mainSec;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSections().then((v) {
      setState(() {
        sections.addAll(v);
      });
    });
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
              Text('إضافة خبر جديدة', style: TextStyle(color: Colors.black54)),
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
                                controller: titleController,
                                //  keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'العنوان',
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
                                  Text('جاري إضافة الخبر')
                                ],
                              ),
                            ),
                          );
                          await addnews(
                              globals.myCompany.id,
                              globals.myCompany.name,
                              globals.myCompany.imgURL.replaceAll("http://kk.vision.com.sa/uploads/", ""),
                              globals.myCompany.phone,
                           detailsController.text,
                            titleController.text,
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
    if (
        detailsController.text.isEmpty||   titleController.text.isEmpty
      ) {
      showSnackMsg('من فضلك املأ الفراغات المطلوبة');
      return false;
    }
    return true;
  }
}
