import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/myColor.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'companyDetails.dart';

class SectionDetails extends StatefulWidget {
  String sectionID, secName;
  SectionDetails(this.sectionID, this.secName);
  @override
  _SectionDetailsState createState() =>
      _SectionDetailsState(sectionID, secName);
}

class _SectionDetailsState extends State<SectionDetails> {
  String secID, secName;
  List<Company> companies = [];

  _SectionDetailsState(this.secID, this.secName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanySection(secID).then((v) {
      if (v is List<Company>) {
        setState(() {
          companies.addAll(v);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey[100],
        title: Text(
          secName,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: (companies.length == 0)
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(MyColor.customColor),
              ),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print('Id:${companies[index].id}');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CompanyDetails(companies[index])));
                    },
                    child: Card(
                      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          image: companies[index].imgURL,
                                          placeholder: 'assets/picture3.png',
                                          fit: BoxFit.cover,
                                          width: 70,
                                          height: 70,
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
                  
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        companies[index].name,
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
                                          Text(secName)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Icon(Icons.details)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
