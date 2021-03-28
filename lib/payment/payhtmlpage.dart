import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/payment/input_formatters.dart';
import 'package:kul_last/payment/my_strings.dart';
import 'package:kul_last/payment/payment_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:flutter_html/flutter_html.dart';


class Payhtmlpage extends StatefulWidget {
  String htmlString;
  Payhtmlpage(this.htmlString);
  @override
  State<StatefulWidget> createState() {
    return PayhtmlpageState();
  }
}

class PayhtmlpageState extends State<Payhtmlpage> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: new AppBar(
          centerTitle: true,
          title: new Text(Strings.appName),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Html(
            data:widget.htmlString,

          ),
        )
    );
  }

  @override
  void dispose() {

    super.dispose();
  }

}