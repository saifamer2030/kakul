import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kul_last/model/plan.dart';
import 'package:kul_last/payment/input_formatters.dart';
import 'package:kul_last/payment/my_strings.dart';
import 'package:kul_last/payment/payment_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


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
  var _autoValidate = false;
  bool _load = false;
  var _paymentCard = PaymentCard();
  var _card = new PaymentCard();

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);

  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCubeGrid(
              color: Theme.of(context).primaryColor,
            ),
          )
        : new Container();
    return new Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Payment'),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: [
                  Expanded(
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
                            _card.name = value;
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
                          //  new CardNumberInputFormatter()
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
                            print(
                                'Num controller has = ${numberController.text}');
                            _paymentCard.number =
                                CardUtils.getCleanedNumber(value);
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
                          //  new CardMonthInputFormatter()
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
                            List<int> expiryDate =
                                CardUtils.getExpiryDate(value);
                            _paymentCard.month = expiryDate[0].toString();
                            _paymentCard.year = expiryDate[1].toString();
                          },
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      width: MediaQuery.of(context).size.width,
                      child: !_load ? _getPayButton() : loadingIndicator),
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

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      _load = false;
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway


//                  '4242424242424242'
      PaymentCard card = PaymentCard(
          name: _paymentCard.name,
          number: _paymentCard.number,
          month: _paymentCard.month,
          year: _paymentCard.year,
          cvv: _paymentCard.cvv,
          type: _paymentCard.type);
      print('${_paymentCard.month}///${_paymentCard.year}');
    }
  }


  Widget _getPayButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.activeBlue,
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
                '٠٠٠٠',
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
              _load = true;
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
                  '٠٠٠٠٠٠',
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
