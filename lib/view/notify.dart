import 'package:flutter/material.dart';
import 'package:kul_last/viewModel/jobsProvider.dart';
import 'package:provider/provider.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import '../myColor.dart';

class Notify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var jobPro=Provider.of<JobsProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            padding: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child:Consumer<JobsProvider>(
              builder: (context, job, w) {
                return (jobPro.jobs.length == 0)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: jobPro.jobs.length,
                  itemBuilder: (context, index) {
                    return Container(
                        color: Colors.grey[100],
                        margin: EdgeInsets.only(bottom: 20,left: 10,right: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: MyColor.customColor,
                            child: Image.asset('assets/profile2.png'),
                          ),
                          title: Text('تنبيه بوظيفة جديدة من شركة  ${jobPro.jobs[index].name}'),
                          subtitle: Text(
                            jobPro.jobs[index].dateAt.split(' ')[0],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ));
                  },
                );

              },
            ),


          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey[100],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/alarm.png',
                    scale: 3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(translator.translate('Alerts'),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
