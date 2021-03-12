import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/view/similaroffers.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:kul_last/viewModel/offersProvider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../myColor.dart';
class PanesPage extends StatefulWidget {

  @override
  _PanesPageState createState() => _PanesPageState();
}

class _PanesPageState extends State<PanesPage> {
  List<Plan> plans = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 0), () async {
     await getallplans().then((v) async {
       setState(() {
         plans.addAll(v);
         print("ppll${plans.length}");

       });


      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: (plans.length == 0)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                return  ExpansionTile(
                  trailing: Container(
                    width: 0,
                    height: 0,
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading:Container(
                      child: ClipOval(
                        child:FadeInImage.assetNetwork(
                          image:plans[index].image,
                          placeholder:  'assets/logo.png',
                          width: 60,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Text(
                      plans[index].name,
                      style: TextStyle(color: Colors.black87),
                    ),
                    subtitle: Text(
                      "${plans[index].price} ريال لمدة ${plans[index].duration} شهر",
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
                            height:150,
                            width:  double.infinity,
                            child: FadeInImage.assetNetwork(
                              image:plans[index].image,
                              placeholder:  'assets/logo.png',
                              width: 60,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
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
                        plans[index].text,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.grey[600]),
                      ),
                    ),

                    Divider(
                      endIndent: 20,
                      indent: 20,
                      color: Colors.grey,
                    ),
                    Container(
                      width: 100,
                      child: RaisedButton(
                        color: MyColor.customColor,
                        textColor: Colors.white,
                        onPressed: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PanesPage()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.monetization_on),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Text(translator.translate('subcribe'))
                          ],
                        ),
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

