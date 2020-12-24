import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/userModel.dart';
import 'package:kul_last/view/companies.dart';

import 'package:kul_last/view/jobs.dart';
import 'package:kul_last/view/mapcluster.dart';
import 'package:kul_last/view/maps.dart';
import 'package:kul_last/view/menu.dart';
import 'package:kul_last/view/msg.dart';
import 'package:kul_last/view/notify.dart';
import 'package:kul_last/view/sections.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/sections.dart';

import 'package:provider/provider.dart';

import 'package:kul_last/backend/sectionBack.dart';

import 'myColor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
class Home extends StatefulWidget {
  User user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState(user);
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  User user;
  _HomeState(this.user);
  TabController controller;
  Company userCompany;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (user != null) {
      getUserCompany(user.id).then((v) {
        userCompany = v;
        setState(() {});
        //updateMyCompanyDistance(userCompany);
      });
    }
    controller = new TabController(length: 3, vsync: this, initialIndex: 2);

    controller.addListener(() {
      setState(() {
        print('d');
      });
      if (homeIndex != 0) {
        setState(() {
          homeIndex = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  int homeIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var compPro = Provider.of<CompanyProvider>(context);
     var secProv=Provider.of<SectionProvider>(context);
  
    return Scaffold(
      key: scaffoldKey,
      endDrawer: MyMenu(user, userCompany),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              controller.index = index;
            });
          },
          currentIndex: controller.index,
          selectedItemColor: MyColor.customColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.work,
                  color: (controller.index) == 0
                      ? MyColor.customColor
                      : Colors.grey),
              title: Text(translator.translate('Jobs'),),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/company.png',
                  scale: 3,
                  color: (controller.index) == 1
                      ? MyColor.customColor
                      : Colors.grey),
              title: Text('الشركات'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/tag2.png',
                  scale: 3,
                  color: (controller.index) == 2
                      ? MyColor.customColor
                      : Colors.grey),
              title: Text('الرئيسية'),
            ),
          ]),
    
   floatingActionButton:  Row(
     children: <Widget>[
       SizedBox(width: 30,),
       FloatingActionButton(
                      backgroundColor: Colors.black87,
                      child: Icon(
                        Icons.clear_all,
                        size: 30,
                        color: Colors.orange[200],
                      ),
                      onPressed: () {
                         Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MapCluster(compPro.companies,secProv)));
                },
                    ),
     ],
   ),
    /*  floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: Colors.orange[200]),
        marginRight: MediaQuery.of(context).size.width - 70,
        overlayColor: Colors.black87,
        overlayOpacity: .5,
        backgroundColor: Colors.black87,
        children: [
          SpeedDialChild(
              backgroundColor: MyColor.customColor,
              child: Icon(
                Icons.my_location,
                size: 28,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Maps(compPro.companies)));
              }),
          SpeedDialChild(
              backgroundColor: MyColor.customColor,
              child: Icon(
                Icons.group_work,
                size: 28,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Maps(compPro.companies)));
              })
        ],
      ),
     */
     
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                      },
                      child: Image.asset(
                        'assets/menu.png',
                        scale: 1.8,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/logo.png',
                      scale: 1.8,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 8, top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'assets/search.png',
                            scale: 1.8,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  homeIndex = 1;
                                });
                              },
                              child: Image.asset(
                                'assets/message.png',
                                scale: 2.8,
                              )),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  homeIndex = 2;
                                });
                              },
                              child: Image.asset(
                                'assets/alarm.png',
                                scale: 2.8,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            /*  TabBar(
              labelColor: MyColor.customColor,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 5,
              indicatorColor: MyColor.customColor,
              controller: controller,
              tabs: <Tab>[
                Tab(
                  icon: Icon(Icons.work,
                      color: (controller.index) == 0
                          ? MyColor.customColor
                          : Colors.grey),
                  text: 'الوظائف',
                ),
                /*   Tab(
                  icon: Image.asset('assets/Construction.png',
                      scale: 3,
                      color: (controller.index) == 1
                          ? MyColor.customColor
                          : Colors.grey),
                  text: 'المقالات',
                ),
           
           */
                Tab(
                  icon: Image.asset('assets/company.png',
                      scale: 3,
                      color: (controller.index) == 1
                          ? MyColor.customColor
                          : Colors.grey),
                  text: 'الشركات',
                ),
                Tab(
                  icon: Image.asset('assets/tag2.png',
                      scale: 3,
                      color: (controller.index) == 2
                          ? MyColor.customColor
                          : Colors.grey),
                  text: 'الرئيسية',
                ),
              ],
            ),
          
          */
          Expanded(
            child:
            (homeIndex == 0)
                ? Container(
                
                  child: TabBarView(
                      controller: controller,
                      children: <Widget>[
                        //jobs
                        Jobs(),

                        //  RegisterCompany(),

                        //Companies
                        Companies(),

                        //Sections
                        Sections()
                      ],
                    ),
                )
                : (homeIndex == 1) ? Msg() : Notify()
          )
          ],
        ),
      ),
    );
  }
}
/**
 * 
 *   FloatingActionButton(
                  backgroundColor: Colors.black87,
                  child: Icon(
                    Icons.clear_all,
                    size: 30,
                    color: Colors.orange[200],
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Maps()));
                  },
                ),
 */
