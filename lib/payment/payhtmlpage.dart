import 'dart:async';
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
import 'package:kul_last/home.dart';
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/myColor.dart';
import 'package:kul_last/payment/input_formatters.dart';
import 'package:kul_last/payment/my_strings.dart';
import 'package:kul_last/payment/payment_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:kul_last/model/globals.dart' as globals;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart' as dio;


class Payhtmlpage extends StatefulWidget {
  var htmlString;
  var paymentCard_type;
  var checkoutId;
  var user_id;

  Payhtmlpage(this.htmlString, this.paymentCard_type, this.checkoutId, this.user_id);

  @override
  State<StatefulWidget> createState() {
    return PayhtmlpageState();
  }
}

class PayhtmlpageState extends State<Payhtmlpage> {
  StreamSubscription<String> _onUrlChanged;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    print('${widget.htmlString}');
    _onUrlChanged =
        flutterWebviewPlugin.onUrlChanged.listen((String state) async {
          String url = 'https://kk.vision.com.sa/API/Payment.php';
          Map<String, String> headers = {'Accept': 'application/json'};
          if (state.startsWith('http://www.kakeul.com/')) {
            // do whatever you want
            var formData1 = dio.FormData.fromMap({
              "req_type": "getCheckoutResult",
              "checkout_id": "${widget.checkoutId}",
              "paymentBrand": "${widget.paymentCard_type}e"
            });
            // print('FormData:${formData.fields}');
            dio.Response response1 = await dio.Dio()
                .post(url, data: formData1, options: dio.Options(headers: headers));
            print('Status:${response1.statusCode}');
            var json = jsonDecode(response1.data);
            print('Responsepp:${response1.data.toString()}kkk');
            if (json['success']) {
              creatmyplan(widget.user_id);
              Fluttertoast.showToast(
                  msg: json['message'],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 3,
                  backgroundColor: MyColor.customColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Fluttertoast.showToast(
                  msg: translator.translate('add'),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 10,
                  backgroundColor: MyColor.customColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            } else {

              Fluttertoast.showToast(
                  msg: json['message'],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 10,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          }
        });
  }
  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    var HtmlCode = widget.htmlString;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColor.customColor,
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
