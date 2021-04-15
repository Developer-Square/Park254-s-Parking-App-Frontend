import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BorderContainer.dart';
import 'package:park254_s_parking_app/components/DismissKeyboard.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/SecondaryText.dart';
import 'package:park254_s_parking_app/components/TertiaryText.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

import 'CircleWithIcon.dart';
import 'DottedHorizontalLine.dart';

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
  final String bookingNumber;
  final String parkingSpace;
  final int price;
  final String destination;
  final String address;
  static const routeName = '/receipt';

  PaymentSuccessful(
      {@required this.bookingNumber,
      @required this.parkingSpace,
      @required this.price,
      @required this.destination,
      @required this.address});

  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
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

  Widget _greenCircle() {
    return Stack(
      children: <Widget>[
        _message(),
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

  Widget _message() {
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
                        SecondaryText(content: widget.bookingNumber),
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
                        _messageRow('Space', widget.parkingSpace),
                        _messageRow('Price', 'Kes ${widget.price.toString()}'),
                      ],
                    ),
                  ),
                  flex: 4,
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
                      content: 'Scan Barcode Here',
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
                                child:
                                    PrimaryText(content: widget.destination)),
                            Expanded(
                              child: Text(
                                widget.address,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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

  Widget _icons(){
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
                  child: _greenCircle(),
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
