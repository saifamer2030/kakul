import 'package:flutter/material.dart';
import 'package:kul_last/view/allFeaturedCompanies.dart';
import 'package:kul_last/view/allSections.dart';
import 'package:kul_last/view/allSuggestedCompanies.dart';
import 'package:kul_last/view/sectionDetails.dart';
import 'package:kul_last/viewModel/featuredCompanies.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:kul_last/viewModel/suggestedCompanies.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../myColor.dart';
import 'companyDetails.dart';

class Sections extends StatelessWidget {
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
              child: Image.asset(
                'assets/baner.png',
                fit: BoxFit.fill,
              ),
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
                    'المزيد',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                title: Text('الشركات المميزة')),
         
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
                                          placeholder: 'assets/picture2.png',
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
                    'المزيد',
                    style: TextStyle(color: MyColor.customColor),
                  )
                ),*/
                title: Text('الأقسام')),

       
        
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
                                          placeholder: 'assets/picture3.png',
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
                    'المزيد',
                    style: TextStyle(color: MyColor.customColor),
                  ),
                ),
                title: Text('الشركات المقترحة')),
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
