import 'package:flutter/material.dart';
import 'package:kul_last/model/news.dart';

import 'package:kul_last/backend/sectionBack.dart';

class NewsProvicer extends ChangeNotifier {
  static List<New> news = [];

  NewsProvicer() {
    if (news.isEmpty)
      getAllNews().then((v) async {
        news.addAll(v);

        notifyListeners();
      });
  }
}
