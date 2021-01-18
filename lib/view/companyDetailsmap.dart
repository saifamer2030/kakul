import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kul_last/backend/others.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/companyInmap.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/news.dart';
import 'package:kul_last/model/offer.dart';
import 'package:kul_last/view/addNewjob.dart';
import 'package:kul_last/view/addNewnews.dart';
import 'package:kul_last/view/addnewoffer.dart';
import 'package:kul_last/view/jobsInCompany.dart';
import 'package:kul_last/view/offersInCompany.dart';
import 'package:kul_last/view/similarjobs.dart';
import 'package:kul_last/view/similaroffers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../myColor.dart';
import 'newsInCompany.dart';
import 'package:kul_last/model/globals.dart' as globals;

class CompanyDetailsMap extends StatefulWidget {
  CompanyMap company;

  CompanyDetailsMap(this.company);

  @override
  _CompanyDetailsMapState createState() => _CompanyDetailsMapState(company);
}

class _CompanyDetailsMapState extends State<CompanyDetailsMap> {
  CompanyMap company;

  _CompanyDetailsMapState(this.company);

  String address = '';
  List<String> urls = [];
  List<Job> jobs = [];
  List<New> news = [];
  List<Offer> offers = [];



  List<Widget> getCompanyImgWidget() {
    List<Widget> items = [];
    urls.forEach((i) {
      items.add(InkWell(
        onTap: () {
          showDialog(
              context: this.context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: Column(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          i,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
              ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage.assetNetwork(
            image: i,
            placeholder: 'assets/pic4.png',
            width: 80,
            height: 80,
            fit: BoxFit.fill,
          ),
        ),
      ));
    });
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocName(company.lat, company.lng).then((v) {
      setState(() {
        address = v;
      });
    });

    getCompanyImgs(companyID: company.id).then((v) {
      setState(() {
        if (v == null) {
          urls = null;
        } else
          urls.addAll(v);
      });
    });

    getCompanyJobs(companyID: company.id).then((v) {
      setState(() {
        if (v == null)
          jobs = null;
        else
          jobs.addAll(v);
      });
    });

    getCompanyNews(companyID: company.id).then((v) {
      setState(() {
        if (v == null)
          news = null;
        else
          news.addAll(v);
      });
    });
    getCompanyoffers(companyID: company.id).then((v) {
      setState(() {
        if (v == null)
          offers = null;
        else
          offers.addAll(v);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.customColor,
      ),
      body: Container(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  color: Colors.red,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                        image: company.coverURL,
                        placeholder: 'assets/cover.png',
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 5),
                          height: 60,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(widget.company.name),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      //launchURL("");
                                      launchURL(widget.company.instagram);
                                    },
                                    child: Image.asset(
                                      'assets/insta.png',
                                      scale: 3,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchURL(widget.company.youtube);
                                    },
                                    child: Image.asset(
                                      'assets/youtube.png',
                                      scale: 3,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchURL(widget.company.twitter);
                                    },
                                    child: Image.asset(
                                      'assets/twitter.png',
                                      scale: 3,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchURL(widget.company.face);
                                    },
                                    child: Image.asset(
                                      'assets/facebook.png',
                                      scale: 3,
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: InkWell(
                                        onTap: () {
                                          launchURL(widget.company.snapshat);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: MyColor.customColor,
                                          child: Image.asset(
                                            'assets/snap.png',
                                            //   color: MyColor.customColor,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              RaisedButton(
                                color: MyColor.customColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  //   launchURL('elshatlawey90@gmail.com');
                                  var subCont = TextEditingController();
                                  var bodyCont = TextEditingController();

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                Icons.mail,
                                                size: 45,
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(8),
                                                    border: Border.all(
                                                        width: .5,
                                                        color:
                                                        Colors.grey)),
                                                child: TextField(
                                                  controller: subCont,
                                                  textAlign:
                                                  TextAlign.right,
                                                  textDirection:
                                                  TextDirection.rtl,
                                                  decoration:
                                                  InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.all(10),
                                                    border:
                                                    InputBorder.none,
                                                    hintText:
                                                    translator
                                                        .translate(
                                                        'MessageSubject'),
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey[400]),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(8),
                                                    border: Border.all(
                                                        width: .5,
                                                        color:
                                                        Colors.grey)),
                                                child: TextField(
                                                  controller: bodyCont,
                                                  maxLines: 4,
                                                  textAlign:
                                                  TextAlign.right,
                                                  textDirection:
                                                  TextDirection.rtl,
                                                  decoration:
                                                  InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.all(10),
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey[400]),
                                                    border:
                                                    InputBorder.none,
                                                    hintText: translator
                                                        .translate(
                                                        'TheMessage'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    child: Text(
                                                      translator.translate(
                                                          'Cancellation'),
                                                      style: TextStyle(
                                                          color:
                                                          Colors.red),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  InkWell(
                                                    child: Text(
                                                      translator.translate(
                                                          'emphasis'),
                                                      style: TextStyle(
                                                          color:
                                                          Colors.green),
                                                    ),
                                                    onTap: () async {
                                                      if (bodyCont
                                                          .text.isEmpty) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            translator
                                                                .translate(
                                                                'PleaseWriteAMessage'),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                            ToastGravity
                                                                .CENTER,
                                                            timeInSecForIos:
                                                            1,
                                                            backgroundColor:
                                                            MyColor
                                                                .customColor,
                                                            textColor:
                                                            Colors
                                                                .white,
                                                            fontSize: 16.0);
                                                      } else {
                                                        Navigator.pop(
                                                            context);
                                                        showDialog(
                                                            context:
                                                            context,
                                                            barrierDismissible:
                                                            false,
                                                            builder:
                                                                (context) =>
                                                                AlertDialog(
                                                                  content:
                                                                  Row(
                                                                    textDirection:
                                                                    TextDirection.rtl,
                                                                    children: <Widget>[
                                                                      CircularProgressIndicator(),
                                                                      SizedBox(
                                                                        width: 25,
                                                                      ),
                                                                      Text(  translator.translate('SendingMessage ...'),)
                                                                    ],
                                                                  ),
                                                                ));
                                                        await sendMsgToMail(
                                                            body: bodyCont
                                                                .text,
                                                            subject:
                                                            subCont
                                                                .text,
                                                            mail: widget
                                                                .company
                                                                .email)
                                                            .whenComplete(
                                                                () {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                      }
                                                      //Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/messagewhite.png',
                                      scale: 4,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text( translator.translate('SendAMessage'),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 15, bottom: 35),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              image: company.imgURL,
                              placeholder: 'assets/picture2.png',
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (( globals.myCompany.id==company.id)&&(globals.myCompany.Accept=="1"))?
                Container(

                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey)),
                  width:  MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: MyColor.customColor,
                        textColor: Colors.white,
                        onPressed: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNewJob()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.water_damage_rounded),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Text(translator.translate('PostJob'))
                          ],
                        ),
                      ),
                      RaisedButton(
                        color: MyColor.customColor,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNewOffer()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.monetization_on),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Text(translator.translate('AddOffer'))
                          ],
                        ),
                      ),
                      RaisedButton(
                        color: MyColor.customColor,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddNewNews()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.wysiwyg),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Text(translator.translate('AddNews'))
                          ],
                        ),
                      ),

                    ],
                  ),
                )
                    :Container(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey)),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          translator.translate('AboutCompany')
                      ),
                      Divider(),
                      Text(
                        widget.company.description,
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey)),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          translator.translate('ContactInformation'),
                      ),
                      Divider(),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.call),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () {
                                    //   launchURL(widget.company.phone);
                                  },
                                  child: Text(widget.company.phone))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.mail_outline),
                              SizedBox(
                                width: 5,
                              ),
                              Text(widget.company.email)
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  address,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (offers == null)
                    ? Container()
                    : Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey)),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            translator.translate('AvailableJobs'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OffersInCompany(
                                        offers: offers,
                                        companyName: company.name,
                                      )));
                            },
                            child: Text(
                              translator.translate('BrowseMore'),
                              style:
                              TextStyle(color: MyColor.customColor),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      (offers.length == 0)
                          ? Container(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : ExpansionTile(
                        trailing: Container(
                          width: 0,
                          height: 0,
                        ),
                        title: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading:Container(
                            child: ClipOval(
                              child:FadeInImage.assetNetwork(
                                image: offers[0].company_image,
                                placeholder:  'assets/cover.png',
                                width: 60,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(
                            offers[0].title,
                            style: TextStyle(color: Colors.black87),
                          ),
                          subtitle: Text(
                            offers[0].create_date.split(' ')[0],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(
                            Icons.details,
                            color: Colors.black87,
                          ),
                        ),
                        children: <Widget>[
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height:150,
                                  width:  double.infinity,
                                  child: FadeInImage.assetNetwork(
                                    image: offers[0].image,
                                    placeholder:  'assets/cover.png',
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '${ offers[0].old_price} ريال',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red[200],
                                      fontFamily: 'El Messiri',
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    //  textDirection: TextDirection.rtl,
                                  ),
                                ),
                                Text(
                                  '${offers[0].new_price} ريال',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[200],
                                    fontFamily: 'El Messiri',
                                    //  decoration: TextDecoration.lineThrough,
                                  ),
                                  //  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            endIndent: 20,
                            indent: 20,
                            color: Colors.grey,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            child: Text(
                              offers[0].text,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            width: double.infinity,
                            child: RaisedButton(
                              color: MyColor.customColor,
                              textColor: Colors.white,
                              child: Text('اظهار الرقم'),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          content: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Text(offers[0].Mobile),
                                              InkWell(
                                                onTap: () {
                                                  launch("tel://${offers[0].Mobile}");
                                                },
                                                child: Icon(
                                                  Icons.call,
                                                  textDirection:
                                                  TextDirection
                                                      .rtl,
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                              },
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            width: double.infinity,
                            child: RaisedButton(
                              color:    Colors.grey[300],
                              //  textColor: Colors.white,
                              child:  Text(
                                translator.translate('OtherSimilarOffers'),
                                style: TextStyle(
                                    color: Colors.grey[600]),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SimilarOffers(offers[0].IdSections,offers[0].IdSubSection)));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (jobs == null)
                    ? Container()
                    : Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey)),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            translator.translate('AvailableJobs'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JobsInCompany(
                                        jobs: jobs,
                                        companyName: company.name,
                                      )));
                            },
                            child: Text(
                              translator.translate('BrowseMore'),
                              style:
                              TextStyle(color: MyColor.customColor),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      (jobs.length == 0)
                          ? Container(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : ExpansionTile(
                        trailing: Container(
                          width: 0,
                          height: 0,
                        ),
                        title: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading:Container(
                            child: ClipOval(
                              child:FadeInImage.assetNetwork(
                                image: jobs[0].Image,
                                placeholder:  'assets/cover.png',
                                width: 60,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(
                            jobs[0].name,
                            style: TextStyle(color: Colors.black87),
                          ),
                          subtitle: Text(
                            jobs[0].dateAt.split(' ')[0],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(
                            Icons.details,
                            color: Colors.black87,
                          ),
                        ),
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Table(
                                    defaultColumnWidth:
                                    FlexColumnWidth(1),
                                    border: TableBorder(
                                      horizontalInside: BorderSide(
                                          width: 1,
                                          color: Colors.grey),
                                      verticalInside: BorderSide(
                                          width: 1,
                                          color: Colors.grey),
                                    ),
                                    children: [
                                      TableRow(children: [
                                        Text(
                                          translator.translate('ExperienceLevel'),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                              Colors.grey[600]),
                                        ),
                                        Center(
                                          child: Text(
                                            jobs[0].Experience,
                                            style: TextStyle(
                                                color: MyColor
                                                    .customColor,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Center(
                                          child: Text(translator.translate('TypeOfEmployment'),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .grey[600])),
                                        ),
                                        Center(
                                          child: Text(
                                            jobs[0].workHours,
                                            style: TextStyle(
                                                color: MyColor
                                                    .customColor,
                                                fontSize: 12),
                                          ),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Center(
                                          child: Text(
                                              translator.translate('EducationalLevel'),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .grey[600])),
                                        ),
                                        Center(
                                          child: Text(
                                            jobs[0].Education,
                                            style: TextStyle(
                                                color: MyColor
                                                    .customColor,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Center(
                                          child: Text('نوع المعلن',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .grey[600])),
                                        ),
                                        Center(
                                          child: Text(
                                            'باحث عن موظف',
                                            style: TextStyle(
                                                color: MyColor
                                                    .customColor,
                                                fontSize: 11),
                                          ),
                                        )
                                      ])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            endIndent: 20,
                            indent: 20,
                            color: Colors.grey,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            child: Text(
                              jobs[0].details,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            width: double.infinity,
                            child: RaisedButton(
                              color: MyColor.customColor,
                              textColor: Colors.white,
                              child: Text(translator
                                  .translate('ShowTheNumber'),),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          content: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Text(  jobs[0].Mobile,),
                                              InkWell(
                                                onTap: () {
                                                  launch("tel://${jobs[0].Mobile}");

                                                },
                                                child: Icon(
                                                  Icons.call,
                                                  textDirection:
                                                  TextDirection
                                                      .rtl,
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                              },
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            width: double.infinity,
                            child: RaisedButton(
                              color:    Colors.grey[300],
                              //  textColor: Colors.white,
                              child:  Text(
                                translator.translate('OtherSimilarOffers'),
                                style: TextStyle(
                                    color: Colors.grey[600]),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SimilarJobs(jobs[0].IdSections,jobs[0].IdSubSection)));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (news == null)
                    ? Container()
                    : Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey)),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            translator.translate('LatestNews'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsInCompany(
                                        news: news,
                                        companyName: company.name,
                                      )));
                            },
                            child: Text(
                              translator.translate('BrowseMore'),
                              style:
                              TextStyle(color: MyColor.customColor),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      (news.length == 0)
                          ? Container(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : ExpansionTile(
                        trailing: Container(
                          width: 0,
                          height: 0,
                        ),
                        title: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Container(
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                image: news[0].imgURL,
                                placeholder: 'assets/cover.png',
                                width: 60,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(
                            news[0].name,
                            style: TextStyle(color: Colors.black87),
                          ),
                          subtitle: Text(
                            news[0].date.split(' ')[0],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(
                            Icons.details,
                            color: Colors.black87,
                          ),
                        ),
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20),
                            child: Text(
                              news[0].topic,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (urls == null)
                    ? Container()
                    : Container(
                  // margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: .5, color: Colors.grey)),
                    child: (urls.length == 0)
                        ? Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:getCompanyImgWidget(),
                    )),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  launchURL(String socialURL) async {
    var url = "https:$socialURL";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    /*if (await canLaunch(url)) {
      
      await launch(url,);
    } else {
      print('Could not launch $url');
    }
  }*/
  }

  Future<dynamic> sendMsgToMail(
      {String mail, String subject, String body}) async {
    String url = "mailto:$mail?subject=$subject&body=$body";
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      //throw 'Could not launch $url';

      return false;
    }
  }
}
