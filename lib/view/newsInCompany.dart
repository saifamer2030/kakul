import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/news.dart';
import 'package:kul_last/myColor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:kul_last/model/globals.dart' as globals;

class NewsInCompany extends StatelessWidget {
  List<New> news;
  String companyName;
  String companyId;

  NewsInCompany({this.news, this.companyName, this.companyId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
            translator.translate('News'),
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
                                trailing:companyId==globals.myCompany.id?IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                      new CupertinoAlertDialog(
                                        title: new Text("تنبية"),
                                        content: new Text("هل تريد حذف هذا الخبر؟"),
                                        actions: [
                                          CupertinoDialogAction(
                                              isDefaultAction: false,
                                              child: new FlatButton(
                                                onPressed: () async {
                                                  await deleteNews(
                                                    id:news[index].id,
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
