import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/companyInmap.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:kul_last/model/message.dart';
import 'package:kul_last/model/photo.dart';
import 'package:kul_last/view/companyDetailsmap.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../myColor.dart';

class PhotoSwiper extends StatefulWidget {
  CompanyMap company;

  PhotoSwiper(this.company);

  @override
  _PhotoSwiperState createState() => _PhotoSwiperState();
}

class _PhotoSwiperState extends State<PhotoSwiper> {
  List<Photo> photos = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    Timer(Duration(seconds: 0), () async {
      getCompanyphoto(widget.company.id).then((v) async {
        setState(() {
          photos.addAll(v);
        });
      });
      print("hhh1");
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,

          child: (photos == null||photos.length==0)
              ?  Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FadeInImage.assetNetwork(
            image: widget.company.coverURL,
            placeholder: 'assets/cover.png',
            fit: BoxFit.cover,
          ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 15, top: 35),
                      child: ClipOval(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyDetailsMap(widget.company)));
                          },
                          child: FadeInImage.assetNetwork(
                            image: widget.company.imgURL,
                            placeholder: 'assets/picture2.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
              :
          new PageView.builder(
            scrollDirection: Axis.vertical,
            pageSnapping:false,
            onPageChanged:(num){
              print("currentpage$num" );
            },
            key: PageStorageKey(""),
            itemCount: photos.length,
            itemBuilder: (context,index){
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(photos[index].Url,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null)
                            return child;
                          return SpinKitThreeBounce(
                            color: const Color(0xff171732),
                            size: 35,
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 15, top: 35),
                      child: ClipOval(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyDetailsMap(widget.company)));
                                    },
                          child: FadeInImage.assetNetwork(
                            image: widget.company.imgURL,
                            placeholder: 'assets/picture2.png',
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )


          // Swiper(
          //   loop: false,
          //   duration: 1000,
          //   autoplay: true,
          //   autoplayDelay: 15000,
          //   itemCount: photos.length,
          //   pagination: new SwiperPagination(
          //     margin: new EdgeInsets.fromLTRB(
          //         0.0, 0.0, 0.0, 0.0),
          //     builder: new DotSwiperPaginationBuilder(
          //         color: Colors.grey,
          //         activeColor: const Color(0xff171732),
          //         size: 8.0,
          //         activeSize: 8.0),
          //   ),
          //   control: new SwiperControl(),
          //   viewportFraction: 1,
          //   scale: 0.1,
          //   outer: true,
          //   itemBuilder:
          //       (BuildContext context, int index) {
          //
          //     return  InkWell(
          //       onTap: () async {
          //         if ( globals.myCompany.id==widget.company.id){
          //           showAlertDialog(context,photos[index].id);
          //         }
          //
          //       },
          //       child: Image.network(photos[index].Url,
          //           fit: BoxFit.fill,
          //           loadingBuilder: (BuildContext context,
          //               Widget child,
          //               ImageChunkEvent loadingProgress) {
          //             if (loadingProgress == null)
          //               return child;
          //             return SpinKitThreeBounce(
          //               color: const Color(0xff171732),
          //               size: 35,
          //             );
          //           }),
          //     );
          //   },
          // )
      ),
    );
  
  
  }
  // showAlertDialog(BuildContext context,String id) {
  //
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text("إلغاء"),
  //     onPressed:  () {
  //       Navigator.pop(
  //           context);
  //     },
  //   );
  //   Widget continueButton = FlatButton(
  //     child: Text("تأكيد"),
  //     onPressed:  () {
  //       Timer(Duration(seconds: 0), () async {
  //         await deletCompanyphoto(id).then((value) {
  //           Fluttertoast.showToast(
  //               msg:
  //               "تم الحذف بنجاح",
  //               toastLength: Toast
  //                   .LENGTH_SHORT,
  //               gravity:
  //               ToastGravity
  //                   .CENTER,
  //               timeInSecForIos:
  //               1,
  //               backgroundColor:
  //               MyColor
  //                   .customColor,
  //               textColor:
  //               Colors
  //                   .white,
  //               fontSize: 16.0);
  //         });
  //         Navigator.pop(
  //             context);
  //       });
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("حذف الصورة"),
  //     content: Text("هل انت متاكد من انك تريد حذف الصورة؟"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

}