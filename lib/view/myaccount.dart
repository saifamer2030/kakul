import 'package:flutter/material.dart';
import 'package:kul_last/model/userModel.dart';

class Account extends StatelessWidget {
  User user;
  Account(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 4,
              bottom: MediaQuery.of(context).size.height / 4,
              left: 20,
              right: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/user.png',
                  scale: 1.5,
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user.name),
                ),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(user.mail),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
