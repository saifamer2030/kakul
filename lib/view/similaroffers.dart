import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/offer.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:kul_last/viewModel/offersProvider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../myColor.dart';
class SimilarOffers extends StatefulWidget {
 String sec,subsec;
  SimilarOffers(this.sec,this.subsec);

  @override
  _SimilarOffersState createState() => _SimilarOffersState();
}

class _SimilarOffersState extends State<SimilarOffers> {
String similarsec,similarsubsec;
List<Offer> offers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

similarsec=widget.sec;
similarsubsec=widget.sec;


    getSimilaroffers(similarsec,similarsubsec).then((v) {
      setState(() {
        if (v == null)
          offers = null;
        else
          offers.addAll(v);
      });
    });

  }

  @override
  Widget build(BuildContext context) {

  //var offerPro=Provider.of<OffersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        centerTitle: true,
        title: Text(
          translator.translate('OtherSimilarOffers'),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child:(offers.length == 0)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  trailing: Container(
                    width: 0,
                    height: 0,
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading:Container(
                      child: ClipOval(
                        child:FadeInImage.assetNetwork(
                          image: offers[index].company_image,
                          placeholder:  'assets/logo.png',
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
                              image: offers[index].image,
                              placeholder:  'assets/cover.png',
                              width: 60,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '${ offers[index].old_price} ريال',
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
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        offers[index].text,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: RaisedButton(
                        color: MyColor.customColor,
                        textColor: Colors.white,
                        child: Text(translator.translate('ShowTheNumber')),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
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
                  ],
                );
              },
            ),
          )),
    );
  }
}

