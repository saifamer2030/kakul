import 'package:flutter/material.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/offer.dart';
import 'package:kul_last/myColor.dart';
import 'package:kul_last/view/similaroffers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

class OffersInCompany extends StatelessWidget {
  List<Offer> offers;
  String companyName;

  OffersInCompany({this.offers, this.companyName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
          ' ${translator.translate('Jobs')} $companyName',
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return  ExpansionTile(
              trailing: Container(
                width: 0,
                height: 0,
              ),
              title: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading:Container(
                  child: ClipOval(
                    child:FadeInImage.assetNetwork(
                      image:offers[index].company_image,
                      placeholder:  'assets/cover.png',
                      width: 60,
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: Text(
                  offers[index].title,
                  style: TextStyle(color: Colors.black87),
                ),
                subtitle: Text(
                  offers[index].create_date.split(' ')[0],
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.details,
                  color: Colors.black87,
                ),
              ),
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height:150,
                        width:  double.infinity,
                        child: FadeInImage.assetNetwork(
                          image:offers[index].image,
                          placeholder:  'assets/cover.png',
                          width: 60,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${offers[index].old_price} ريال',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[200],
                            fontFamily: 'El Messiri',
                            decoration: TextDecoration.lineThrough,
                          ),
                          //  textDirection: TextDirection.rtl,
                        ),
                      ),
                      Text(
                        '${offers[index].new_price} ريال',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[200],
                          fontFamily: 'El Messiri',
                          //  decoration: TextDecoration.lineThrough,
                        ),
                        //  textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20, right: 20),
                  child: Text(
                    offers[index].text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.grey[600]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20, right: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    color: MyColor.customColor,
                    textColor: Colors.white,
                    child: Text(translator.translate('ShowTheNumber')),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                content: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text(offers[index].Mobile),
                                    InkWell(
                                      onTap: () {
                                        launch("tel://${offers[index].Mobile}");
                                      },
                                      child: Icon(
                                        Icons.call,
                                        textDirection:
                                        TextDirection
                                            .rtl,
                                      ),
                                    )
                                  ],
                                ),
                              ));
                    },
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(
                      left: 20, right: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    color:    Colors.grey[300],
                    //  textColor: Colors.white,
                    child:  Text(
                      translator.translate('OtherSimilarOffers'),
                      style: TextStyle(
                          color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SimilarOffers(offers[index].IdSections,offers[index].IdSubSection)));
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
