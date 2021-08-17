import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BorderContainer.dart';
import 'package:park254_s_parking_app/components/DismissKeyboard.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/SecondaryText.dart';
import 'package:park254_s_parking_app/components/TertiaryText.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:provider/provider.dart';

import '../CircleWithIcon.dart';
import '../DottedHorizontalLine.dart';

/// Creates a receipt
///
/// E.g.
///```dart
/// Navigator.pushNamed(
///   context,
///   PaymentSuccessful.routeName,
///   arguments: ReceiptArguments(
///      bookingNumber: 'haaga5441',
///      destination: 'Nairobi',
///      parkingSpace: 'pajh5114',
///      price: 10,
///      address: '100 West 33rd Street, Nairobi Industrial Area, 00100, Kenya'
///   )
///);
class PaymentSuccessful extends StatefulWidget {
  final String parkingSpaces;
  final int price;
  final String destination;
  final String address;
  final TimeOfDay arrivalTime;
  final TimeOfDay leavingTime;
  static const routeName = '/receipt';

  PaymentSuccessful(
      {@required this.parkingSpaces,
      @required this.price,
      @required this.destination,
      @required this.address,
      @required this.arrivalTime,
      @required this.leavingTime});

  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  String transactionYear;
  String transactionMonth;
  String transactionDay;
  String mpesaReceiptNumber;

  /// Creates custom row with title and value
  Widget _messageRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SecondaryText(content: title),
        TertiaryText(content: value),
      ],
    );
  }

  Widget _containerWithBorderRadius(Widget child) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: width * 0.8,
      child: child,
    );
  }

  Widget _greenCircle(transactionDetails) {
    return Stack(
      children: <Widget>[
        _message(transactionDetails),
        Align(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: globals.textColor,
            ),
            height: 30,
            width: 30,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: globals.primaryColor,
                ),
                height: 20,
                width: 20,
              ),
              heightFactor: 1.5,
              widthFactor: 1.5,
            ),
          ),
          alignment: Alignment.topCenter,
        ),
      ],
    );
  }

  Widget _message(transactionDetails) {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
          flex: 1,
        ),
        Expanded(
          child: _containerWithBorderRadius(
            Column(
              children: <Widget>[
                Expanded(
                  child: BorderContainer(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        PrimaryText(content: 'Payment Successful'),
                      ],
                    ),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: width / 20, right: width / 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _messageRow('Mpesa Receipt No.',
                            mpesaReceiptNumber.toString() ?? ''),
                        _messageRow('Price', 'Kes ${widget.price.toString()}'),
                        _messageRow('Date',
                            '${transactionYear ?? ''}-${transactionMonth ?? ''}-${transactionDay ?? ''}'),
                        // All this is done to be able get the exact UI we want.
                        _messageRow('Time',
                            '${widget.arrivalTime.minute > 9 ? ' ' + '${widget.arrivalTime.hour.toString()}:${widget.arrivalTime.minute.toString()}' : ' ' + '${widget.arrivalTime.hour.toString()}:0${widget.arrivalTime.minute.toString()}'} - ${widget.leavingTime.minute > 9 ? ' ' + '${widget.leavingTime.hour.toString()}:${widget.leavingTime.minute.toString()}' : ' ' + '${widget.leavingTime.hour.toString()}:0${widget.leavingTime.minute.toString()}'}'),
                      ],
                    ),
                  ),
                  flex: 8,
                ),
              ],
            ),
          ),
          flex: 9,
        ),
      ],
    );
  }

  Widget _receipt() {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          child: _containerWithBorderRadius(
            Container(
              padding: EdgeInsets.only(
                  left: width / 5,
                  right: width / 5,
                  top: width / 10,
                  bottom: width / 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/qrcode.png'),
                      fit: BoxFit.cover,
                    ),
                    flex: 7,
                  ),
                  Expanded(
                    child: SecondaryText(
                      content: 'Scan QrCode Here',
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: _containerWithBorderRadius(
                      Container(
                        padding: EdgeInsets.all(width / 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: PrimaryText(content: widget.destination))
                          ],
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: CircleWithIcon(
                          icon: Icons.close,
                          bgColor: Colors.white,
                          iconColor: globals.textColor,
                          sizeFactor: 2,
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Center(
                child: _icons(),
              ),
            ],
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget _dottedLine() {
    return Stack(
      children: <Widget>[
        _receipt(),
        Center(
          child: Container(
            height: 10,
            child: Center(
              child: CustomPaint(
                painter: DotedHorizontalLine(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _icons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CircleWithIcon(
          icon: Icons.near_me,
          bgColor: globals.primaryColor,
          iconColor: globals.textColor,
          sizeFactor: 2,
        ),
        CircleWithIcon(
          icon: Icons.error_outline,
          bgColor: Colors.red,
          iconColor: Colors.white,
          sizeFactor: 1,
        ),
        CircleWithIcon(
          icon: Icons.call,
          bgColor: globals.primaryColor,
          iconColor: globals.textColor,
          sizeFactor: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final transactionDetails = Provider.of<TransactionModel>(context);
    mpesaReceiptNumber = transactionDetails.transaction.mpesaReceiptNumber;
    transactionYear = transactionDetails.transaction.transactionDate
        .toString()
        .substring(0, 4);
    transactionMonth = transactionDetails.transaction.transactionDate
        .toString()
        .substring(4, 6);
    transactionDay = transactionDetails.transaction.transactionDate
        .toString()
        .substring(6, 8);
    log(mpesaReceiptNumber);

    return SafeArea(
      child: Scaffold(
        backgroundColor: globals.textColor,
        resizeToAvoidBottomPadding: true,
        body: DismissKeyboard(
          child: Container(
            padding: EdgeInsets.all(width / 20),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _greenCircle(transactionDetails),
                  flex: 10,
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                Expanded(
                  child: _dottedLine(),
                  flex: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
