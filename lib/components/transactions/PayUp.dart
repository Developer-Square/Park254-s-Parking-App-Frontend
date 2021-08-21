import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/GoButton.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/transactions/widgets/retry_modal.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/transactions/pay.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';
import 'package:provider/provider.dart';

import '../helper_functions.dart';

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

  PayUp(
      {@required this.total,
      @required this.timeDatePicker,
      @required this.toggleDisplay,
      @required this.receiptGenerator});
  @override
  _PayUpState createState() => _PayUpState();
}

class _PayUpState extends State<PayUp> {
  int resultCode;
  String resultDesc;
  // Transaction details from the store.
  TransactionModel transactionDetails;
  // User's details from the store.
  UserWithTokenModel storeDetails;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
    }
  }

  callPaymentMethod(transactionDetails) async {
    String access = storeDetails.user.accessToken.token;
    if (access != null) {
      transactionDetails.setLoading(true);
      pay(
              phoneNumber: 254796867328,
              amount: widget.total,
              token: access,
              setCreatedAt: transactionDetails.setCreatedAt,
              setTransaction: transactionDetails.setTransaction,
              setLoading: transactionDetails.setLoading)
          .then((value) {
        log('Inside callPayment function');
        log(value.resultCode.toString());
        // If resultCode is equal to 0 then the transcation other than that.
        // then it failed.
        if (value.resultCode == 0) {
          buildNotification('Payment Successful', 'success');
          // Move the payment successful page.
          widget.receiptGenerator();
        }
        // If the transaction failed and the user has not retried it then show retry modal.
        else if (value.resultCode == 503) {
          buildNotification(resultDesc ?? 'Transaction failed', 'error');

          retryModal(context, transactionDetails, widget.total, access,
              widget.receiptGenerator);
        }
      }).catchError((err) {
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
    transactionDetails = Provider.of<TransactionModel>(context);
    resultCode = transactionDetails.transaction.resultCode;
    resultDesc = transactionDetails.transaction.resultDesc;
    log('In payUp.dart');
    log(resultCode.toString());

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
                      onTap: () => callPaymentMethod(transactionDetails),
                      title: 'Pay Up'),
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
