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

class NewCompany extends StatefulWidget {
  @override
  _NewCompanyState createState() => _NewCompanyState();
}

class _NewCompanyState extends State<NewCompany> {
  String dropDownVal, dropDownVal2;

  var nameController = TextEditingController();

  var mailController = TextEditingController(text:globals.myCompany.email);



  String mainSec;

  String subSec;

  var desctionController = TextEditingController();

  var phoneController = TextEditingController(text:globals.myCompany.phone );
  var commericalController = TextEditingController();

  var titleController = TextEditingController();

  LatLng companyLatLng;

  File profileImg;

  File coverImg;

  var faceController = TextEditingController();

  var twitterController = TextEditingController();

  var instaController = TextEditingController();

  var youtubeController = TextEditingController();
  var snapController=TextEditingController();


  List<Section> sections = [];
  Section selectedSection;
  List<SubSection> subSections = [];
  SubSection selectedSubSection;

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
          Text('تسجيل شركة جديدة', style: TextStyle(color: Colors.black54)),
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
                                  hintText: 'اسم الشركة',
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
                              color: Colors.white,
                              child: DropdownButton(
                                  isExpanded: true,
                                  value: selectedSection,
                                  hint: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'القسم الرئيسي',
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
                                      selectedSection = sec;
                                    });
                                    subSections.clear();
                                    getAllSubSections(selectedSection.id).then((v) {
                                      setState(() {
                                        subSections.addAll(v);
                                      });
                                    });
                                  },
                                  items: getSectionsDropDown()),
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
                                value: selectedSubSection,
                                hint: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'القسم الفرعي',
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
                                    selectedSubSection = sec;
                                  });
                                },
                                items: getSubSectionsDropDown(),
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
                        Container(
                          width: 3,
                          height: 48,
                          color: MyColor.customColor,
                        ),
                        Expanded(
                            child: Container(
                              height: 48,
                              child: TextField(
                                controller: commericalController,
                                decoration: InputDecoration(
                                  hintText: 'رقم السجل التجاري',
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
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: 'عنوان الشركة',
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
                                        Text('تم ارفاق صورة البروفايل')
                                      ],
                                    )
                                        : Text('ارفاق صورة البروفايل'),
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
                                var loc = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => MyDialog());
                                if (loc != null) {
                                  companyLatLng = loc;
                                  setState(() {});
                                }
                              },
                              child: Container(
                                color: Colors.white,
                                height: (companyLatLng != null) ? 48 : 70,
                                child: Center(
                                    child: (companyLatLng != null)
                                        ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.check),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('تم تحديد العنوان على الخريطة'),
                                      ],
                                    )
                                        : Image.asset('assets/loc.jpg')),
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
                                coverImg = await getImage();
                                setState(() {});
                              },
                              child: Container(
                                  color: Colors.white,
                                  height: 48,
                                  child: Center(
                                    child: (coverImg != null)
                                        ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.check),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('تم ارفاق صورة الغلاف')
                                      ],
                                    )
                                        : Text('ارفاق صورة الغلاف'),
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
                                controller: faceController,
                                decoration: InputDecoration(
                                  hintText: 'رابط صفحة الفيس بوك',
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
                                controller: twitterController,
                                decoration: InputDecoration(
                                  hintText: 'رابط صفحة تويتر',
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
                                controller: instaController,
                                decoration: InputDecoration(
                                  hintText: 'رابط صفحة انستجرام',
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
                                controller: youtubeController,
                                decoration: InputDecoration(
                                  hintText: 'رابط قناة اليوتيوب',
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
                                controller: snapController,
                                decoration: InputDecoration(
                                  hintText: 'رابط سناب شات',
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
                          await registerCompany(
                              id:globals.myCompany.id,
                              companyName: nameController.text,
                              coverImg: coverImg,
                              description: desctionController.text,
                              email: mailController.text,
                              facebook: faceController.text,
                              instagram: instaController.text,
                              lat: companyLatLng.latitude.toString(),
                              lng: companyLatLng.longitude.toString(),
                              phone: phoneController.text,
                              commRecord: commericalController.text,
                              profileImage: profileImg,
                              secID: selectedSection.id,
                              snapchat: snapController.text,
                              subscribtion: "0",
                              subSecID: selectedSubSection.id,
                              title: titleController.text,
                              twitter: twitterController.text,
                              youtube: youtubeController.text)
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

  Future<File> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    return image;
  }

  List<DropdownMenuItem> getSectionsDropDown() {
    List<DropdownMenuItem> items = [];
    sections.forEach((sec) {
      items.add(DropdownMenuItem(
        child: Text(sec.name),
        value: sec,
      ));
    });
    return items;
  }

  List<DropdownMenuItem> getSubSectionsDropDown() {
    List<DropdownMenuItem> items = [];
    subSections.forEach((sec) {
      items.add(DropdownMenuItem(
        child: Text(sec.name),
        value: sec,
      ));
    });
    return items;
  }

  bool validateInputs() {
    if (nameController.text.isEmpty ||
        mailController.text.isEmpty ||
        desctionController.text.isEmpty ||
        phoneController.text.isEmpty ||
        titleController.text.isEmpty ||
        commericalController.text.isEmpty) {
      showSnackMsg('من فضلك املأ الفراغات المطلوبة');
      return false;

    } else if (selectedSubSection == null || selectedSection == null) {
      showSnackMsg('قم باختيار الأقسام كاملة');
      return false;
    } else if (profileImg == null || coverImg == null) {
      showSnackMsg('قم بأرفاق الصور المطلوبة');
      return false;
    } else if (companyLatLng == null) {
      showSnackMsg('قم بتحديد موقع الشركة على الخريطة');
      return false;
    }
    return true;
  }
}

class MyDialog extends StatefulWidget {
  MyDialog();

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  LatLng currentLoc = LatLng(0.0, 0.0);

  var location = new Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers.add(Marker(markerId: MarkerId('loc'), position: currentLoc));
    location.getLocation().then((locData) {
      print(locData);
      _controller.future.then((con) {
        con.animateCamera(CameraUpdate.newLatLng(
            LatLng(locData.latitude, locData.longitude)));
      });
      currentLoc = LatLng(locData.latitude, locData.longitude);
      markers.clear();
      markers.add(Marker(markerId: MarkerId('loc'), position: currentLoc));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        child: GoogleMap(
          onMapCreated: (gController) {
            _controller.complete(gController);
          },
          initialCameraPosition:
          CameraPosition(target: LatLng(0.0, 0.0), zoom: 11),
          markers: Set.from(markers),
          onTap: (v) {
            currentLoc = v;
            markers.clear();
            markers
                .add(Marker(markerId: MarkerId('loc'), position: currentLoc));

            setState(() {});
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.white,
          textColor: Colors.red[800],
          child: Text('الغاء'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          color: Colors.white,
          textColor: Colors.green[800],
          child: Text('تأكيد'),
          onPressed: () {
            Navigator.pop(context, currentLoc);
          },
        ),
      ],
    );
  }
}
