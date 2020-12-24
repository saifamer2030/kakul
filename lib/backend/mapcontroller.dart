import 'dart:async';
import 'package:kul_last/model/map_marker.dart';
import 'package:kul_last/view/companies.dart';

import 'sectionBack.dart';

class MapController{
  Stream<List<MapMarker>> get maplistview async*{
    yield await getAllCompanies();
  }



  }
