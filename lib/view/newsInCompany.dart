import 'package:flutter/material.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/news.dart';
import 'package:kul_last/myColor.dart';

class NewsInCompany extends StatelessWidget {
  List<New> news;
  String companyName;

  NewsInCompany({this.news, this.companyName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
          ' اخبار $companyName',
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: news.length,
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
                                    child:FadeInImage.assetNetwork(
                                      image: news[index].imgURL,
                                      placeholder:  'assets/cover.png',
                                      width: 60,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ), 
                                  ),
                                ),
                                title: Text(
                                  news[index].name,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                subtitle: Text(
                                  news[index].date.split(' ')[0],
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: Icon(
                                  Icons.details,
                                  color: Colors.black87,
                                ),
                              ),
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    news[index].topic,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                ],
                            )
                  
                  ;
          },
        ),
      ),
    );
  }
}
