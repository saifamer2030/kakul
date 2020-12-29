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
import 'package:kul_last/model/globals.dart' as globals;

import '../myColor.dart';

class AddNewOffer extends StatefulWidget {
  @override
  _AddNewOfferState createState() => _AddNewOfferState();
}

class _AddNewOfferState extends State<AddNewOffer> {

  var nameController = TextEditingController();
  var desctionController = TextEditingController();
  var oldpriceController = TextEditingController();
  var newpriceController = TextEditingController();

  File profileImg;

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
              Text('إضافة عرض جديدة', style: TextStyle(color: Colors.black54)),
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
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'اسم العرض',
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
                            controller: desctionController,
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
                            controller: oldpriceController,
                            decoration: InputDecoration(
                              hintText: 'السعر قبل العرض',
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
                            controller: newpriceController,
                            decoration: InputDecoration(
                              hintText: 'السعر فى العرض',
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
                            child: InkWell(
                          onTap: () async {
                            profileImg = await getImage();
                            setState(() {});
                          },
                          child: Container(
                              color: Colors.white,
                              height: 48,
                              child: Center(
                                child: (profileImg != null)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.check),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('تم ارفاق الصورة')
                                        ],
                                      )
                                    : Text('ارفاق صورة مع العرض'),
                              )),
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
                          await registerOffer(
                              id:globals.myCompany.id,
                              name: nameController.text,
                              description: desctionController.text,
                              oldprice: oldpriceController.text,
                              newprice: newpriceController.text,
                            profileImage: profileImg,
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

  Future<File> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    return image;
  }

  bool validateInputs() {
    if (nameController.text.isEmpty ||
        desctionController.text.isEmpty ||
        newpriceController.text.isEmpty ||
        oldpriceController.text.isEmpty) {
      showSnackMsg('من فضلك املأ الفراغات المطلوبة');
      return false;


    } else if (profileImg == null) {
      showSnackMsg('قم بأرفاق الصور المطلوبة');
      return false;
    }
    return true;
  }
}
