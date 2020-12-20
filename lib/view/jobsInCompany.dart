import 'package:flutter/material.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/myColor.dart';

class JobsInCompany extends StatelessWidget {
  List<Job> jobs;
  String companyName;

  JobsInCompany({this.jobs, this.companyName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
          ' وظائف $companyName',
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
                leading: Container(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/cover.png',
                      fit: BoxFit.fill,
                      width: 60,
                      height: 80,
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
                                'مستوى الخبرة',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                              Center(
                                child: Text(
                                  'حديث التخرج',
                                  style: TextStyle(
                                      color: MyColor.customColor, fontSize: 12),
                                ),
                              ),
                              Center(
                                child: Text('نوع العمل',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600])),
                              ),
                              Center(
                                child: Text(
                                  jobs[index].workHours,
                                  style: TextStyle(
                                      color: MyColor.customColor, fontSize: 12),
                                ),
                              )
                            ]),
                            TableRow(children: [
                              Center(
                                child: Text('المستوى التعليمي',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600])),
                              ),
                              Center(
                                child: Text(
                                  'بكالوريوس',
                                  style: TextStyle(
                                      color: MyColor.customColor, fontSize: 12),
                                ),
                              ),
                              Center(
                                child: Text('نوع المعلن',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600])),
                              ),
                              Center(
                                child: Text(
                                  'باحث عن موظف',
                                  style: TextStyle(
                                      color: MyColor.customColor, fontSize: 11),
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
                    jobs[index].details,
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
                    child: Text('اظهار الرقم'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('01093138717'),
                                    Icon(
                                      Icons.call,
                                      textDirection: TextDirection.rtl,
                                    )
                                  ],
                                ),
                              ));
                    },
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                  color: Colors.grey[300],
                  height: 60,
                  child: Center(
                    child: Text(
                      'وظائف اخرى مشابهة',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
