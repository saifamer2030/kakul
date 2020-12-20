import 'package:flutter/material.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/userModel.dart';
import 'package:kul_last/view/allNews.dart';
import 'package:kul_last/view/companyDetails.dart';
import 'package:kul_last/view/login.dart';
import 'package:kul_last/view/myaccount.dart';
import 'package:kul_last/view/registerNewCompany.dart';
import 'package:kul_last/viewModel/newsProvider.dart';
import 'package:provider/provider.dart';

class MyMenu extends StatelessWidget {
  User user;
  Company userCompany;
  MyMenu(this.user, this.userCompany);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.4,
        color: Colors.grey[100],
        // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 4),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              color: Colors.grey[100],
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          if (userCompany == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          } else
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyDetails(userCompany)));
                        },
                        leading: Icon(Icons.assessment),
                        title: Text('شركتي'),
                        trailing: Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          if (user == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          } else
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Account(user)));
                        },
                        leading: Icon(Icons.perm_contact_calendar),
                        title: Text('حسابي'),
                        trailing: Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllNews()));
                        },
                        leading: Image.asset('assets/news.png', scale: 3.5),
                        title: Text('الأخبار'),
                        trailing: Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      /*Divider(),
                      ListTile(
                        leading: Icon(Icons.receipt),
                        title: Text('المقالات'),
                        trailing: Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                     
                     */
                      Divider(),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewCompany()));
                        },
                        leading: Image.asset('assets/tag2.png', scale: 3.5),
                        title: Text('تسجيل شركة'),
                        trailing: Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        leading: Icon(Icons.exit_to_app),
                        title: Text('تسجيل خروج'),
                        trailing: Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
