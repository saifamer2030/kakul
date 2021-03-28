import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kul_last/backend/sectionBack.dart';
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/payment/input_formatters.dart';
import 'package:kul_last/payment/my_strings.dart';
import 'package:kul_last/payment/payment_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:kul_last/model/globals.dart' as globals;

class CreditCardPage extends StatefulWidget {
  Plan plan;
  CreditCardPage(this.plan);
  @override
  State<StatefulWidget> createState() {
    return CreditCardPageState();
  }
}

class CreditCardPageState extends State<CreditCardPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;
  var _card = new PaymentCard();

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(Strings.appName),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(
                        Icons.person,
                        size: 40.0,
                      ),
                      hintText: 'What name is written on card?',
                      labelText: 'Card Name',
                    ),
                    onSaved: (String value) {
                      setState(() {
                        _card.name = value;
                        _paymentCard.name =value;
                      });
                    },
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                    value.isEmpty ? Strings.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      // new CardNumberInputFormatter()
                      CreditCardNumberInputFormatter(onCardSystemSelected:
                          (CardSystemData cardSystemData) {
                        print(cardSystemData.system);
                      })
                    ],
                    controller: numberController,
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: CardUtils.getCardIcon(_paymentCard.type),
                      hintText: 'What number is written on card?',
                      labelText: 'Number',
                    ),
                    onSaved: (String value) {
                      print('onSaved = $value');
                      print('Num controller has = ${numberController.text}');
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                    },
                    validator: CardUtils.validateCardNum,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      CreditCardCvcInputFormatter()
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: new Image.asset(
                        'assets/images/card_cvv.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'Number behind the card',
                      labelText: 'CVV',
                    ),
                    validator: CardUtils.validateCVV,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _paymentCard.cvv = int.parse(value);
                    },
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      // new CardMonthInputFormatter()
                      CreditCardExpirationDateFormatter()
                    ],
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: new Image.asset(
                        'assets/images/calender.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'MM/YY',
                      labelText: 'Expiry Date',
                    ),
                    validator: CardUtils.validateDate,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      List<int> expiryDate = CardUtils.getExpiryDate(value);
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    },
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  new Container(
                    alignment: Alignment.center,
                    child: _getPayButton(),
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  Future<void> _validateInputs() async {
    try {
             List<Placemark> p = await Geolocator().placemarkFromCoordinates(
                 double.parse(globals.lat.toString().trim()),
                 double.parse(globals.lng.toString().trim())
             );

             Placemark place = p[0];
             String name = place.name;
             String subLocality = place.subLocality;
             String locality = place.locality;
             String administrativeArea = place.administrativeArea;
             String postalCode = place.postalCode;
             String country = place.country;

          String   Address ="n:${name}, sub:${subLocality}, loc:${locality}, ad:${administrativeArea} pp:${postalCode}, c:${country}";
             print("yyy$Address");
             await paydata(globals.myCompany.id,widget.plan.id,widget.plan.price,
                 _paymentCard.type,_paymentCard.number,_paymentCard.month,_paymentCard.year,
                 _paymentCard.cvv,_paymentCard.name,context,name,locality,administrativeArea,postalCode).then((v) async {
               // Navigator.pop(context);Navigator.pop(context);Navigator.pop(context);
             });
    } catch (e) {
             print(e);
           }


    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: Colors.black,//CupertinoColors.activeBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              Strings.pay,
              style: const TextStyle(fontSize: 17.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: new Text(
                '${widget.plan.price}',
                style: const TextStyle(fontSize: 17.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: new Text(
                'SAR',
                style: const TextStyle(fontSize: 17.0),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).accentColor,
        width: MediaQuery.of(context).size.width,
        child: new FlatButton(
          onPressed: () {
            setState(() {
              _validateInputs();
            });
          },
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
          textColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                Strings.pay.toUpperCase(),
                style: const TextStyle(fontSize: 17.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: new Text(
                  '${widget.plan.price}',
                  style: const TextStyle(fontSize: 17.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: new Text(
                  'SAR',
                  style: const TextStyle(fontSize: 17.0),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }
}