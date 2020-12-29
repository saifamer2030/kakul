import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:kul_last/model/message.dart';

import '../myColor.dart';

class Msg extends StatefulWidget {
  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  List<Message> message = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    Timer(Duration(seconds: 0), () async {
      getCompanymessage(globals.myCompany.id).then((v) async {
        setState(() {
          message.addAll(v);
        });
      });
      print("hhh1");
    });

  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
          child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10, 20,10, 10),
            padding: EdgeInsets.only(top: 25),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: (message.length == 0)
                ? Center(child: Text("لا يوجد رسائل بعد"))
                : ListView.builder(
              itemCount: message.length,
              itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    ListTile(
                    leading: CircleAvatar(
                    backgroundColor: MyColor.customColor,
                    child: Image.asset('assets/profile.png'),
                  ),
                  title: Text('Admin'),
                  subtitle: Text(message[index].text),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Text(message[index].create_date.split(' ')[1].split('.')[0],),
                    ],
                  ),
                ),
                Divider(height: 1,endIndent: 20,indent: 20,)
                  ],
                );
              },
            ),
          )
       ,
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 8, 30,8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey[100],

              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/message.png',scale: 3,)
                  
                  ,SizedBox(width: 10,),
                  Text('الرسائل'),
                ],
              ),
            ),
          )
       
       
        ],
      ),
    );
  
  
  }
}