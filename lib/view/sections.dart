import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kul_last/model/advertisment.dart';
import 'package:kul_last/view/allFeaturedCompanies.dart';
import 'package:kul_last/view/allSections.dart';
import 'package:kul_last/view/allSuggestedCompanies.dart';
import 'package:kul_last/view/sectionDetails.dart';
import 'package:kul_last/viewModel/featuredCompanies.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:kul_last/viewModel/suggestedCompanies.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import '../myColor.dart';
import 'companyDetails.dart';
class Sections extends StatefulWidget {


  @override
  _SectionsState createState() => _SectionsState();
}

class _SectionsState extends State<Sections>  {
  List<Advertisment> adv = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 0), () async {
   await getAllAdvert().then((v) {
   
      setState(() {
        if (v == null)
          adv = null;
        else
          setState(() {
            adv.addAll(v);
          });
      });
    });
  });
  }


  @override
  Widget build(BuildContext context) {
    var featPro = Provider.of<FeaturedCompanyProvider>(context);
    var secPro = Provider.of<SectionProvider>(context);
    print('size:' + secPro.sections.length.toString());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 180,

                child: adv == null
                    ? SpinKitThreeBounce(
                  size: 35,
                  color: const Color(0xff171732),
                )
                    : Swiper(
                  loop: false,
                  duration: 1000,
                  autoplay: true,
                  autoplayDelay: 15000,
                  itemCount: adv.length,
                  pagination: new SwiperPagination(
                    margin: new EdgeInsets.fromLTRB(
                        0.0, 0.0, 0.0, 0.0),
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        activeColor: const Color(0xff171732),
                        size: 8.0,
                        activeSize: 8.0),
                  ),
                  control: new SwiperControl(),
                  viewportFraction: 1,
                  scale: 0.1,
                  outer: true,
                  itemBuilder:
                      (BuildContext context, int index) {
                 
                    return  InkWell(
                      onTap: () async {
                        var url = adv[index].Link;
                        if (await canLaunch(url)) {
                        await launch(url);
                        } else {
                        throw 'Could not launch $url';
                        }
                      },
                      child: Image.network(adv[index].image,
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null)
                              return child;
                            return SpinKitThreeBounce(
                              color: const Color(0xff171732),
                              size: 35,
                            );
                          }),
                    );
                  },
                )
            ),
            SizedBox(
              height: 10,
            ),

            ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      child: Image.asset(
                        'assets/company2.png',
                        scale: 2.5,
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 1,
                      height: 35,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AllFeaturedCompanies(featPro.companies)));
                  },
                  child: Text(
                      translator.translate('More'),
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                title: Text(translator.translate('FeaturedCompanies'),)),
         
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              height: 110,
              child: (featPro.companies.length == 0)
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            MyColor.customColor),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CompanyDetails(featPro.companies[index])));
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          image:
                                              featPro.companies[index].imgURL,
                                          placeholder: 'assets/logo.png',
                                          imageScale: 3,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Image.asset('assets/good.png',
                                            scale: 3),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      featPro.companies[index].name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/tag2.png',
                                          scale: 4,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(featPro.companies[index].secID)
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Divider(),
        
            ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      child: Image.asset(
                        'assets/tag2.png',
                        scale: 2.5,
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 1,
                      height: 35,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
               /* trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AllSections(secPro.sections)));
                  },
                    child: Text(
                    translator.translate('More'),,
                    style: TextStyle(color: MyColor.customColor),
                  )
                ),*/
                title: Text(translator.translate('sections'),)),

       
        
             Expanded(
              child: Container(
                //  height: (secPro.sections.length == 0) ? 50 : 180,
                child: (secPro.sections.length == 0)
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              MyColor.customColor),
                        ),
                      )
                    : Center(
                        child: Scrollbar(
                          child: GridView.builder(
                            itemCount: secPro.sections.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return GridTile(
                                header: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SectionDetails(
                                                    secPro.sections[index].id,
                                                    secPro.sections[index]
                                                        .name)));
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          image: secPro.sections[index].imgURL,
                                          placeholder: 'assets/logo.png',
                                          fit: BoxFit.cover,
                                          width: 70,
                                          height: 70,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(secPro.sections[index].name)
                                    ],
                                  ),
                              
                              
                                ),
                                child: Container(),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ),
           
          
             //  Divider(),
            /*ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      child: Image.asset(
                        'assets/company2.png',
                        scale: 2.5,
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 1,
                      height: 35,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllSuggestedCompanies(
                                SuggestedCompanyProvider.companies)));
                  },
                  child: Text(
                    translator.translate('More'),,
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                title: Text(translator.translate('TheProposedCompanies'),)),
            Consumer<SuggestedCompanyProvider>(
              builder: (context, comp, w) => Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                height: 110,
                child: (SuggestedCompanyProvider.companies.length == 0)
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              MyColor.customColor),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CompanyDetails(
                                      SuggestedCompanyProvider
                                          .companies[index])));
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: 70,
                                    height: 70,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        ClipOval(
                                          child: FadeInImage.assetNetwork(
                                            image: SuggestedCompanyProvider
                                                .companies[index].imgURL,
                                            placeholder:
                                                'assets/picture2.png',
                                            imageScale: 3,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Image.asset(
                                              'assets/good.png',
                                              scale: 3),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        SuggestedCompanyProvider
                                            .companies[index].name,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/tag2.png',
                                            scale: 4,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(SuggestedCompanyProvider
                                              .companies[index].secID)
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
           */
          ],
        ),
      ),
    );
  }
}
