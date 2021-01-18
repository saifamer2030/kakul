import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/offer.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:kul_last/viewModel/offersProvider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../myColor.dart';
class SimilarJobs extends StatefulWidget {
 String sec,subsec;
 SimilarJobs(this.sec,this.subsec);

  @override
  _SimilarJobsState createState() => _SimilarJobsState();
}

class _SimilarJobsState extends State<SimilarJobs> {
String similarsec,similarsubsec;
List<Job> jobs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

similarsec=widget.sec;
similarsubsec=widget.sec;


    getSimilarJobs(similarsec,similarsubsec).then((v) {
      setState(() {
        if (v == null)
          jobs = null;
        else
          jobs.addAll(v);
      });
    });

  }

  @override
  Widget build(BuildContext context) {

  //var offerPro=Provider.of<OffersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
          translator.translate('OtherSimilarFunctions'),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child:(jobs.length == 0)
                ? Center(child: CircularProgressIndicator())
                :
            ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  trailing: Container(
                    width: 0,
                    height: 0,
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading:Container(
                      child: ClipOval(
                        child:FadeInImage.assetNetwork(
                          image: jobs[index].Image,
                          placeholder:  'assets/logo.png',
                          width: 60,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Text(
                      jobs[index].name,
                      style: TextStyle(color: Colors.black87),
                    ),
                    subtitle: Text(
                      jobs[index].dateAt.split(' ')[0],
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
                                      jobs[index].Experience,
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
                                      jobs[index].workHours,
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
                                      jobs[index].Education,
                                      style: TextStyle(
                                          color: MyColor
                                              .customColor,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Center(
                                    child: Text(translator.translate('AdvertiserType'),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .grey[600])),
                                  ),
                                  Center(
                                    child: Text(
                                      translator.translate('LookingForAnEmployee'),
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
                        jobs[index].details,
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
                        child: Text(translator.translate('ShowTheNumber')),
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
                                        Text(  jobs[index].Mobile,),
                                        InkWell(
                                          onTap: () {
                                            launch("tel://${jobs[index].Mobile}");

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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }
}

