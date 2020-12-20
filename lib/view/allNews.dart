import 'package:flutter/material.dart';
import 'package:kul_last/model/news.dart';
import 'package:kul_last/viewModel/newsProvider.dart';
import 'package:provider/provider.dart';

import 'package:kul_last/backend/sectionBack.dart';

class AllNews extends StatefulWidget {
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<New> news = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNews().then((v) {
      setState(() {
        news.addAll(v);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black54,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('الأخبار',style: TextStyle(
            color: Colors.black54
          ),),
        ),
        body: (news.length == 0)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Directionality(
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
                            child: FadeInImage.assetNetwork(
                              image: news[index].imgURL,
                              placeholder: 'assets/cover.png',
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
                    );
                  },
                ),
            ));
  }
}
