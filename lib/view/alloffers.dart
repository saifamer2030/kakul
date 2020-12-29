import 'package:flutter/material.dart';
import 'package:kul_last/view/similaroffers.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:kul_last/viewModel/offersProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../myColor.dart';

class AllOffers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  var offerPro=Provider.of<OffersProvider>(context);
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Consumer<JobsProvider>(
            builder: (context, job, w) {
              return (offerPro.offer.length == 0)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: offerPro.offer.length,
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
                                  image:offerPro.offer[index].company_image,
                                  placeholder:  'assets/cover.png',
                                  width: 60,
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            title: Text(
                              offerPro.offer[index].title,
                              style: TextStyle(color: Colors.black87),
                            ),
                            subtitle: Text(
                              offerPro.offer[index].create_date.split(' ')[0],
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
                                      image:offerPro.offer[index].image,
                                      placeholder:  'assets/cover.png',
                                      width: 60,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      '${ offerPro.offer[index].old_price} ريال',
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
                                    '${offerPro.offer[index].new_price} ريال',
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
                                offerPro.offer[index].text,
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
                                child: Text('اظهار الرقم'),
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
                                                Text(offerPro.offer[index].Mobile),
                                                InkWell(
                                                  onTap: () {
                                                    launch("tel://${offerPro.offer[index].Mobile}");
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
                                  'عروض اخرى مشابهة',
                                  style: TextStyle(
                                      color: Colors.grey[600]),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SimilarOffers(offerPro.offer[index].IdSections,offerPro.offer[index].IdSubSection)));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    );
            },
          ),
        ));
  }
}

