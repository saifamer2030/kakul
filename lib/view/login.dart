import 'package:flutter/material.dart';
import 'package:kul_last/backend/auh.dart';
import 'package:kul_last/home.dart';
import 'package:kul_last/model/userModel.dart';
import 'package:kul_last/view/registerNewCompany.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/featuredCompanies.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../myColor.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;

  var mailController = TextEditingController();
  var passController = TextEditingController();

  var key = GlobalKey<ScaffoldState>();

  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<
                                          SectionProvider>.value(
                                        value: SectionProvider(),
                                      ),
                                      ChangeNotifierProvider<
                                          FeaturedCompanyProvider>.value(
                                        value: FeaturedCompanyProvider(),
                                      ),
                                      ChangeNotifierProvider<
                                          CompanyProvider>.value(
                                        value: CompanyProvider(),
                                      ),
                                      ChangeNotifierProvider<
                                          JobsProvider>.value(
                                        value: JobsProvider(),
                                      ),
                                    ],
                                    child: Home(null),
                                  )));
                    },
                    child: Text(
                      'دخول مباشر',
                      style: TextStyle(
                        color: MyColor.customColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                  child: Card(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'assets/user.png',
                          scale: 1.5,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: mailController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(18),
                              hintText: 'البريد الألكتروني',
                              fillColor: Colors.grey[200],
                              filled: true),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(18),
                              hintText: 'كلمة المرور',
                              fillColor: Colors.grey[200],
                              filled: true),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              onChanged: (v) {
                                setState(() {
                                  rememberMe = v;
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: MyColor.customColor,
                              value: rememberMe,
                            ),
                            Text('تذكرني')
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 120,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: MyColor.customColor,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              userLogin(
                                      mailController.text, passController.text)
                                  .then((v) {
                                if (v is String) {
                                  showSnackError(v);
                                } else {
                                  if (rememberMe) {
                                    //Save to sharedPref
                                    saveUserTosharedPref(mailController.text,
                                        passController.text);
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MultiProvider(
                                                providers: [
                                                  ChangeNotifierProvider<
                                                      SectionProvider>.value(
                                                    value: SectionProvider(),
                                                  ),
                                                  ChangeNotifierProvider<
                                                      FeaturedCompanyProvider>.value(
                                                    value:
                                                        FeaturedCompanyProvider(),
                                                  ),
                                                  ChangeNotifierProvider<
                                                      CompanyProvider>.value(
                                                    value: CompanyProvider(),
                                                  ),
                                                  ChangeNotifierProvider<
                                                      JobsProvider>.value(
                                                    value: JobsProvider(),
                                                  ),
                                                ],
                                                child: Home(v),
                                              )));
                                }
                              }).catchError((e) {
                                showSnackError(e.toString());
                              }).whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                              });
                            },
                            child: Text('دخول'),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewCompany()));
                          },
                          child: Text(
                            'ليس لديك حساب سجل الأن',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                color: Colors.black54),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              (loading == true)
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              MyColor.customColor),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  showSnackError(String msg) {
    key.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.right,
        style: TextStyle(fontFamily: 'jareda'),
      ),
    ));
  }

  Future<void> saveUserTosharedPref(String mail, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mail', mail);
    prefs.setString('pass', pass);
  }
}
