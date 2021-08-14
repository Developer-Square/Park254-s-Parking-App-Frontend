import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/GoButton.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/functions/transactions/pay.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'load_location.dart';

/// Creates a Pay Up pop up that prompts user to pay
///
/// ```dart
/// PayUp(
///   total: amount,
///   timeDatePicker: _timeDatePicker(),
///   toggleDisplay: () => _togglePayUp(),
///   receiptGenerator: () => _generateReceipt(),
/// )
///```
class PayUp extends StatefulWidget {
  final int total;
  final Widget timeDatePicker;
  final Function toggleDisplay;
  final Function receiptGenerator;
  Function showHideLoader;

  PayUp(
      {@required this.total,
      @required this.timeDatePicker,
      @required this.toggleDisplay,
      @required this.receiptGenerator,
      this.showHideLoader});
  @override
  _PayUpState createState() => _PayUpState();
}

class _PayUpState extends State<PayUp> {
  final storage = new FlutterSecureStorage();

  callPaymentMethod() async {
    widget.showHideLoader(true);
    String access = await storage.read(key: 'accessToken');
    if (access != null) {
      pay(phoneNumber: 254796867328, amount: widget.total, token: access)
          .then((value) {
        if (value != null) {
          buildNotification('Payment Successful', 'success');
          widget.showHideLoader(false);
          log(value.transactions[0].toString());
        }
      }).catchError((err) {
        widget.showHideLoader(false);
        log("In PayUp.dart");
        log(err.toString());
        buildNotification(err.message.toString(), 'error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Center(
        child: SizedBox(
          height: height / 2,
          width: width * 0.9,
          child: Container(
            padding: EdgeInsets.all(width / 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: widget.toggleDisplay,
                        child: Icon(
                          Icons.close,
                          color: globals.textColor,
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PrimaryText(content: 'Total'),
                        PrimaryText(content: "Kes ${widget.total.toString()}"),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: widget.timeDatePicker,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: GoButton(
                      onTap: () => callPaymentMethod(), title: 'Pay Up'),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
