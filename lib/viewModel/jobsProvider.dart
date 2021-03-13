
import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/jobs.dart';

class JobsProvider extends ChangeNotifier {
   List<Job> jobs = [];

  JobsProvider() {
    if(jobs.isEmpty)
    getAllJobs().then((v) async {
      jobs.addAll(v);
    
      notifyListeners();
    });
  }
}