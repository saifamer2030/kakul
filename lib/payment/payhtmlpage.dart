import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/payment/input_formatters.dart';
import 'package:kul_last/payment/my_strings.dart';
import 'package:kul_last/payment/payment_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class Payhtmlpage extends StatefulWidget {
  var htmlString;

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
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    print('${widget.htmlString}');
  }

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    var HtmlCode = widget.htmlString;
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(Strings.appName),
      ),
      body: Container(
        child: Center(
          child:


    /*      WebView(
              initialUrl: new Uri.dataFromString(
                      widget.htmlString,
                      mimeType: 'text/html')
                  .toString(),
              javascriptMode: JavascriptMode.unrestricted),*/

              WebviewScaffold(
            url: new Uri.dataFromString(
              HtmlCode,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString(),
          ),
        ),
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString(widget.htmlString);
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
