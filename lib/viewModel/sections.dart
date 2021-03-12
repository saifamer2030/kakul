import 'package:flutter/foundation.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/section.dart';

class SectionProvider extends ChangeNotifier {
   List<Section> sections = [];

  SectionProvider() {
    if(sections.isEmpty)
    getAllSections().then((v) {
      sections.addAll(v);
      notifyListeners();
    });
  }
}
