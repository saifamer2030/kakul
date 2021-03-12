import 'package:flutter/material.dart';
import 'package:kul_last/view/similarjobs.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:provider/provider.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../myColor.dart';

class Notify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var jobPro=Provider.of<JobsProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            padding: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child:Consumer<JobsProvider>(
              builder: (context, job, w) {
                return (jobPro.jobs.length == 0)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: jobPro.jobs.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                        //ListTile(
                          leading: CircleAvatar(
                            backgroundColor: MyColor.customColor,
                            child: Image.asset('assets/profile2.png'),
                          ),
                          title: Text('${translator.translate('NewJobAlertFromCompany')}${jobPro.jobs[index].name}'),
                          subtitle: Text(
                            jobPro.jobs[index].dateAt.split(' ')[0],
                            style: TextStyle(color: Colors.grey),
                          ),
                       // ),
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
                                          jobPro.jobs[index].Experience,

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
                                          jobPro.jobs[index].workHours,
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
                                          jobPro.jobs[index].Education,

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
                            jobPro.jobs[index].details,
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
                            child: Text(translator.translate('ShowTheNumber'),),
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
                                            Text(jobPro.jobs[index].Mobile,),
                                            InkWell(
                                              onTap: () {
                                                launch("tel://${jobPro.jobs[index].Mobile}");

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
                                  builder: (context) => SimilarJobs(jobPro.jobs[index].IdSections,jobPro.jobs[index].IdSubSection)));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );






                  },
                );

              },
            ),


          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey[100],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/alarm.png',
                    scale: 3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(translator.translate('Alerts'),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
