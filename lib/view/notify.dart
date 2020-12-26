import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../myColor.dart';

class Notify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[100],
                  margin: EdgeInsets.only(bottom: 20,left: 10,right: 10),
                    child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: MyColor.customColor,
                    child: Image.asset('assets/profile2.png'),
                  ),
                  title: Text(translator.translate('NewAlertFromAnotherMember'),),
                ));
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
