import 'package:flutter/material.dart';

import '../myColor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class Msg extends StatelessWidget {
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
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    ListTile(
                    leading: CircleAvatar(
                    backgroundColor: MyColor.customColor,
                    child: Image.asset('assets/profile.png'),
                  ),
                  title: Text(translator.translate('MohammedMustafa'),),
                  subtitle: Text(translator.translate('Sure,NoproblemAwaitsYou'),),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('2:50'),Text('PM')
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
                  Text(translator.translate('Messages'),),
                ],
              ),
            ),
          )
       
       
        ],
      ),
    );
  
  
  }
}