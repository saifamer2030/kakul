
import 'package:flutter/material.dart';
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/jobs.dart';
import 'package:kul_last/model/message.dart';
import 'package:kul_last/model/offer.dart';

class OffersProvider extends ChangeNotifier {
   List<Offer> offer = [];
   OffersProvider() {
    if(offer.isEmpty)
      getAlloffers().then((v) async {
        offer.addAll(v);
    
      notifyListeners();
    });
  }
}