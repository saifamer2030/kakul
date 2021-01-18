import 'package:flutter/material.dart';
import 'package:kul_last/model/section.dart';
import 'package:kul_last/view/sectionDetails.dart';
import 'package:kul_last/view/sections.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
class AllSections extends StatelessWidget {
  List<Section> sections = [];
  AllSections(this.sections);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
            translator.translate('sections'),
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
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(

                contentPadding: EdgeInsets.all(10),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>SectionDetails(sections[index].id, 
                    sections[index].name)
                  ));
                },
                leading: Container(
                  width: 50,
                  height: 50,
                                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      image: sections[index].imgURL,
                      placeholder: 'assets/logo.png',
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                title: Text(sections[index].name),
              ),
            );
          },
        ),
      ),
    );
  }
}
