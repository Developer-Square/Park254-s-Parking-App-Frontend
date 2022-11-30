import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/functions/transactions/fetchTransaction.dart';
import 'package:path/path.dart';

import '../../helper_functions.dart';

void retryFunction({
  dynamic transactionDetails,
  int total,
  String token,
  BuildContext context,
  Function receiptGenerator,
  Function cancelBooking,
}) {
  transactionDetails.setLoading(true);
  fetchTransaction(
          phoneNumber: 254796867328,
          amount: total,
          token: token,
          setTransaction: transactionDetails.setTransaction,
          setLoading: transactionDetails.setLoading,
          createdAt: transactionDetails.createdAt)
      .then((value) {
    if (value.resultCode == 0) {
      buildNotification('Payment Succesful', 'success');
      // Move the payment successful page.
      receiptGenerator();
    } else if (value.resultCode == 503) {
      buildNotification(value.resultDesc, 'error');
      cancelBooking();
    }
  });

  Navigator.pop(context);
}

/// Builds out the comment section modal to allow users to
/// view and comment on pictures.
/// Requires [context].
void retryModal({
  BuildContext parentContext,
  dynamic transactionDetails,
  int total,
  String token,
  Function receiptGenerator,
  Function cancelBooking,
}) {
  showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 250),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: globals.primaryColor),
                  height: 40.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Retry Transaction',
                          style:
                              globals.buildTextStyle(16.0, true, Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(parentContext);
                            cancelBooking();
                          },
                          child: const Icon(Icons.close, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70.0, left: 5.0, right: 5.0),
                  child: Column(children: <Widget>[
                    Text('Would you like to retry the transaction?',
                        style:
                            globals.buildTextStyle(15.0, true, Colors.black)),
                    SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: () => retryFunction(
                                transactionDetails: transactionDetails,
                                total: total,
                                token: token,
                                context: context,
                                receiptGenerator: receiptGenerator,
                                cancelBooking: cancelBooking),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: globals.primaryColor,
                              fixedSize: Size(30.0, 30.0),
                            ),
                            child: Text('Ok'),
                          ),
                          SizedBox(width: 15.0),
                          TextButton(
                            onPressed: () {
                              cancelBooking();
                              Navigator.pop(parentContext);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              textStyle: TextStyle(color: Colors.white),
                              fixedSize: Size(30.0, 30.0),
                            ),
                            child: Text('Cancel'),
                          ),
                        ])
                  ]),
                )
              ],
            ),
          ),
        );
      });
}
