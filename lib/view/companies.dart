import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/section.dart';
import 'package:kul_last/model/subSection.dart';
import 'package:kul_last/view/companyDetails.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../myColor.dart';

class Companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  List<Section> sections = [];

  Section selectedSection;

  List<SubSection> subSections = [];

  SubSection selectedSubSection;
  List<Company> filteredList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSections().then((v) {
      setState(() {
        sections.addAll(v);
      });
    });
  }

  bool filter = false;

  @override
  Widget build(BuildContext context) {
    var comPro = Provider.of<CompanyProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh: ()async{
          setState(() {
            filter=false;
          });
          return true;
        },
              child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, left: 5, right: 5),
              padding: EdgeInsets.only(right: 5, top: 20, bottom: 20),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 48,
                        color: Colors.grey[100],
                        child: DropdownButton(
                            value: selectedSection,
                            hint: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                  translator.translate('TheMainSection'),
                                style: TextStyle(fontFamily: 'jareda'),
                              ),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black54),
                            underline: Container(),
                            onChanged: (sec) {
                              setState(() {
                                selectedSection = sec;
                              });
                              getAllSubSections(selectedSection.id).then((v) {
                                setState(() {
                                  subSections.addAll(v);
                                });
                              });
                            },
                            items: getSectionsDropDown()),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 48,
                        color: Colors.grey[100],
                        child: DropdownButton(
                          value: selectedSubSection,
                          hint: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                translator.translate('Subsection'),
                              style: TextStyle(fontFamily: 'jareda'),
                            ),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black54),
                          underline: Container(),
                          onChanged: (sec) {
                            setState(() {
                              selectedSubSection = sec;
                            });
                          },
                          items: getSubSectionsDropDown(),
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  /*Expanded(
                      flex: 1,
                      child: Container(
                        height: 48,
                        color: Colors.grey[100],
                        child: DropdownButton<String>(
                          value: dropDownVal,
                          hint: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              translator.translate('City'),,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(),
                          onChanged: (String newValue) {},
                          items: <String>['One', 'Two', 'Free', 'Four']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )),
                
                */
                  Container(
                    height: 48,
                    width: 60,
                    child: RaisedButton(
                      onPressed: () {
                        fileterData(comPro.companies, selectedSection,
                            selectedSubSection);
                      },
                      color: MyColor.customColor,
                      textColor: Colors.white,
                      child: Text(translator.translate('Show'),),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: (comPro.companies.length == 0)
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              MyColor.customColor),
                        ),
                      )
                    : (filter == true)
                        ? ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 5, right: 5),
                                color: Colors.white,
                                height: 140,
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompanyDetails(
                                                        filteredList[index])));
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          width: 120,
                                          height: double.infinity,
                                          child: FadeInImage.assetNetwork(
                                            image: filteredList[index].imgURL,
                                            placeholder: 'assets/t1.png',
                                            width: 100,
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(right: 3, top: 3),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(filteredList[index].name),
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
                                                  Text(translator.translate('Building'),)
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.space_bar,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    (filteredList[index].distanceBetween!=null)?
                                                      '${filteredList[index].distanceBetween}${translator.translate('kilo')}'
                                                      :'')
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      (filteredList[index]
                                                          .locationName
                                                          .toString()=='null')?
                                                          '':
                                                      filteredList[index]
                                                          .locationName
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                    Container(
                                      height: double.infinity,
                                      width: 100,
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RatingBar(
                                            initialRating: 3,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: MyColor.customColor,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          Divider(),
                                          RaisedButton(
                                            onPressed: () {
                                              contactCompany(
                                                  phone: filteredList[index]
                                                      .phone);
                                            },
                                            textColor: Colors.white,
                                            color: MyColor.customColor,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.call),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(translator.translate('Contact'),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: comPro.companies.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 5, right: 5),
                                color: Colors.white,
                                height: 140,
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompanyDetails(comPro
                                                        .companies[index])));
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          width: 120,
                                          height: double.infinity,
                                          child: FadeInImage.assetNetwork(
                                            image:
                                                comPro.companies[index].imgURL,
                                            placeholder: 'assets/t1.png',
                                            width: 100,
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(right: 3, top: 3),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  comPro.companies[index].name),
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
                                                  Text(translator.translate('Building'),)
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.space_bar,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text((comPro.companies[index]
                                                              .distanceBetween !=
                                                          null)
                                                      ? '${comPro.companies[index].distanceBetween}${translator.translate('kilo')}'
                                                      : '')
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      (comPro.companies[index]
                                                                  .locationName
                                                                  .toString() !=
                                                              "null")
                                                          ? comPro
                                                              .companies[index]
                                                              .locationName
                                                              .toString()
                                                          : '',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                    Container(
                                      height: double.infinity,
                                      width: 100,
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RatingBar(
                                            initialRating: 3,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: MyColor.customColor,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          Divider(),
                                          RaisedButton(
                                            onPressed: () {
                                              contactCompany(
                                                  phone: comPro
                                                      .companies[index].phone);
                                            },
                                            textColor: Colors.white,
                                            color: MyColor.customColor,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.call),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(translator.translate('Contact'),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )),
          ],
        ),
      ),
    );
  }

  Future<dynamic> contactCompany({String phone}) async {
    String url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      //throw 'Could not launch $url';

      return false;
    }
  }

  List<DropdownMenuItem> getSectionsDropDown() {
    List<DropdownMenuItem> items = [];
    sections.forEach((sec) {
      items.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(sec.name),
        ),
        value: sec,
      ));
    });
    return items;
  }

  List<DropdownMenuItem> getSubSectionsDropDown() {
    List<DropdownMenuItem> items = [];
    subSections.forEach((sec) {
      items.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(sec.name),
        ),
        value: sec,
      ));
    });
    return items;
  }

  void fileterData(
    List<Company> companies,
    Section selectedSection,
    SubSection selectedSubSection,
  ) {
    if (selectedSection != null) {
      filteredList.clear();
      if (selectedSubSection != null) {
        companies.forEach((company) {
          if (company.secID == selectedSection.name &&
              company.subSecID == selectedSubSection.name) {
            filteredList.add(company);
          }
        });
      } else {
        companies.forEach((company) {
          if (company.secID == selectedSection.name) {
            filteredList.add(company);
          }
        });
      }
      print('Size:${filteredList.length}');
      filter = true;
      setState(() {});
    }
  }
}
