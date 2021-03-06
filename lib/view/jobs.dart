import 'package:flutter/material.dart';
import 'package:kul_last/view/similarjobs.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import '../myColor.dart';

class Jobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  var jobPro=Provider.of<JobsProvider>(context);
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Consumer<JobsProvider>(
            builder: (context, job, w) {
              return (jobPro.jobs.length == 0)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: jobPro.jobs.length,
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
                                  image: jobPro.jobs[index].Image,
                                  placeholder:  'assets/logo.png',
                                  width: 60,
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            title: Text(
                              jobPro.jobs[index].name,
                              style: TextStyle(color: Colors.black87),
                            ),
                            subtitle: Text(
                              jobPro.jobs[index].dateAt.split(' ')[0],
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
        ));
  }
}

/*
Card(
                child: ExpansionTile(
                  trailing: Container(
                    width: 0,
                    height: 0,
                  ),
                  title: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        translator.translate('SocialMediaMarketerWantedFromHome'),,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 30,
                        child: Center(
                          child: Scrollbar(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Icon(
                                  Icons.perm_identity,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                Text(
                                  translator.translate('AlRaedCompany'),,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                Text(
                                  translator.translate('AlRiyadh,SaudiArabia'),,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.pin_drop,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                Text(
                                  '50 كم',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.date_range,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                Text(
                                  '5/12/2020',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Table(
                              defaultColumnWidth: FlexColumnWidth(1),
                              border: TableBorder(
                                horizontalInside:
                                    BorderSide(width: 1, color: Colors.grey),
                                verticalInside:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              children: [
                                TableRow(children: [
                                  Text(
                                    translator.translate('ExperienceLevel'),,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  Center(
                                    child: Text(
                                      translator.translate('RecentGraduate'),,
                                      style: TextStyle(
                                          color: MyColor.customColor,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Center(
                                    child: Text(translator.translate('TypeOfEmployment'),,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600])),
                                  ),
                                  Center(
                                    child: Text(
                                      translator.translate('FreeWork'),,
                                      style: TextStyle(
                                          color: MyColor.customColor,
                                          fontSize: 12),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Center(
                                    child: Text(translator.translate('EducationalLevel'),,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600])),
                                  ),
                                  Center(
                                    child: Text(
                                      translator.translate('BA'),
                                      style: TextStyle(
                                          color: MyColor.customColor,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Center(
                                    child: Text(translator.translate('AdvertiserType'),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600])),
                                  ),
                                  Center(
                                    child: Text(
                                      translator.translate('LookingForAnEmployee'),
                                      style: TextStyle(
                                          color: MyColor.customColor,
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
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'هنا يتم وضع وصف عن الوظيفة المعروضة هنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضةهنا يتم وضع وصف عن الوظيفة المعروضة'translator.translate('HereIsADescriptionOfTheJobOffered')
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: RaisedButton(
                        color: MyColor.customColor,
                        textColor: Colors.white,
                        child: Text(translator.translate('ShowTheNumber')),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 10),
                      color: Colors.grey[300],
                      height: 60,
                      child: Center(
                        child: Text(
                          translator.translate('OtherSimilarFunctions'),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  ],
                ),
              );
            */
