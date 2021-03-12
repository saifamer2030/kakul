import 'package:flutter/material.dart';
import 'package:kul_last/backend/auh.dart';
import 'package:kul_last/home.dart';
import 'package:kul_last/model/userModel.dart';

import 'package:kul_last/view/login.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/companiesmap.dart';
import 'package:kul_last/viewModel/featuredCompanies.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:kul_last/viewModel/offersProvider.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    openLocationService().then((v) {
      if (v == true)
        checkUserSharedPref();
      else
        Navigator.pop(context);
    });
  }

  Future<void> checkUserSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool userFounded = prefs.containsKey('mail');

    if (userFounded) {
      String mail = prefs.getString('mail');
      String pass = prefs.getString('pass');

      userLogin(mail, pass).then((v) {
        if (v is User) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider<SectionProvider>.value(
                            value: SectionProvider(),
                          ),
                          ChangeNotifierProvider<FeaturedCompanyProvider>.value(
                            value: FeaturedCompanyProvider(),
                          ),
                          ChangeNotifierProvider<CompanyProvider>.value(
                            value: CompanyProvider(),
                          ),
                          ChangeNotifierProvider<JobsProvider>.value(
                            value: JobsProvider(),
                          ),
                          ChangeNotifierProvider<CompanyMapProvider>.value(
                            value: CompanyMapProvider(),
                          ),
                          ChangeNotifierProvider<OffersProvider>.value(
                            value: OffersProvider(),
                          ),

                        ],
                        child: Home(v),
                      )));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<SectionProvider>.value(
                    value: SectionProvider(),
                  ),
                  ChangeNotifierProvider<
                      FeaturedCompanyProvider>.value(
                    value: FeaturedCompanyProvider(),
                  ),
                  ChangeNotifierProvider<CompanyProvider>.value(
                    value: CompanyProvider(),
                  ),
                  ChangeNotifierProvider<JobsProvider>.value(
                    value: JobsProvider(),
                  ),
                  ChangeNotifierProvider<OffersProvider>.value(
                    value: OffersProvider(),
                  ),

                ],
                child: Home(null),
              ),
            ),
          );
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => Login()));
        }
      });
    } else
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<SectionProvider>.value(
                value: SectionProvider(),
              ),
              ChangeNotifierProvider<
                  FeaturedCompanyProvider>.value(
                value: FeaturedCompanyProvider(),
              ),
              ChangeNotifierProvider<CompanyProvider>.value(
                value: CompanyProvider(),
              ),
              ChangeNotifierProvider<JobsProvider>.value(
                value: JobsProvider(),
              ),
              ChangeNotifierProvider<OffersProvider>.value(
                value: OffersProvider(),
              ),

            ],
            child: Home(null),
          ),
        ),
      );
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }

  Future<bool> openLocationService() async {
    var location = new Location();
    bool c1 = await location.serviceEnabled();
    if (c1 == false) {
      await location.requestService().then((v) {
        if (v == true)
          return true;
        else
          return false;
      });
    }
    return true;
  }
}
