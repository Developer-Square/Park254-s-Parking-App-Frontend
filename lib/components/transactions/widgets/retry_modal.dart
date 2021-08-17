import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/functions/transactions/pay.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';

void retryFunction(transactionDetails, total, token, createdAt, context) {
  transactionDetails.fetch(
      phoneNumber: 254796867328,
      amount: total,
      token: token,
      createdAt: createdAt);
  Navigator.pop(context);
}

/// Builds out the comment section modal to allow users to
/// view and comment on pictures.
/// Requires [context].
void retryModal(BuildContext parentContext, transactionDetails, int total,
    String token, String createdAt) {
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
                          FlatButton(
                            onPressed: () => retryFunction(transactionDetails,
                                total, token, createdAt, context),
                            color: globals.primaryColor,
                            textColor: Colors.white,
                            minWidth: 30.0,
                            height: 30.0,
                            child: Text('Ok'),
                          ),
                          SizedBox(width: 15.0),
                          FlatButton(
                            onPressed: () => Navigator.pop(parentContext),
                            color: Colors.red,
                            textColor: Colors.white,
                            minWidth: 30.0,
                            height: 30.0,
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
