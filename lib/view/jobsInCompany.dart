import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/myColor.dart';
import 'package:kul_last/view/similarjobs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:localize_and_translate/localize_and_translate.dart';
class JobsInCompany extends StatelessWidget {
  List<Job> jobs;
  String companyName;
  String companyId;

  JobsInCompany({this.jobs, this.companyName, this.companyId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
          '${translator.translate('position')} $companyName',
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
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
                //*************
                trailing:companyId==globals.myCompany.id?IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                      new CupertinoAlertDialog(
                        title: new Text("تنبية"),
                        content: new Text("هل تريد حذف هذا الوظيفة؟"),
                        actions: [
                          CupertinoDialogAction(
                              isDefaultAction: false,
                              child: new FlatButton(
                                onPressed: () async {
                                  await deleteJob(
                                    id:jobs[index].id,
                                  )
                                      .then((v) {
                                    Fluttertoast.showToast(
                                        msg: "تمت الحذف بنجاح",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        backgroundColor: MyColor.customColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pop(context);
                                  }).whenComplete(() {
                                    Navigator.pop(context);
                                     Navigator.pop(context);

                                  }).catchError((e) {
                                    Fluttertoast.showToast(
                                        msg: e,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        backgroundColor: MyColor.customColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    //  showSnackMsg(e.toString());
                                    print('ErrorRegCompany:$e');
                                  }).then((v) {});
                                }
                                ,
                                child: Text("موافق"),
                              )),
                          CupertinoDialogAction(
                              isDefaultAction: false,
                              child: new FlatButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: Text("إلغاء"),
                              )),
                        ],
                      ),
                    );
                  },
                ): Icon(
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

                                child: Text(translator.translate('EducationalLevel'),
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
                    child: Text(translator.translate('showTheNumber'),),
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
                                    Text(jobs[index].Mobile,),
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
                Container(
                  height: 60,
                  margin: EdgeInsets.only(
                      left: 20, right: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    color:    Colors.grey[300],
                    //  textColor: Colors.white,
                    child:  Text(
                    translator.translate('OtherSimilarFunctions'),
                      style: TextStyle(
                          color: Colors.grey[600]),

                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SimilarJobs(jobs[index].IdSections,jobs[index].IdSubSection)));
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
      ),
    );
  }
}
