import 'package:flutter/material.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/section.dart';
import 'package:kul_last/view/companyDetails.dart';
import 'package:kul_last/view/sectionDetails.dart';
import 'package:kul_last/view/sections.dart';

class AllSuggestedCompanies extends StatelessWidget {
  List<Company> companies = [];
  AllSuggestedCompanies(this.companies);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'الشركات المقترحة',
          style: TextStyle(color: Colors.black54),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>CompanyDetails(companies[index])
                  ));
                },
                leading: Container(
                  width: 50,
                  height: 50,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      image: companies[index].imgURL,
                      placeholder: 'assets/picture3.png',
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                title: Text(companies[index].name),
              ),
            );
          },
        ),
      ),
    );
  }
}
