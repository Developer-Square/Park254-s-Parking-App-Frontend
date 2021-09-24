import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park254_s_parking_app/components/BorderContainer.dart';
import 'package:park254_s_parking_app/components/DismissKeyboard.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/SecondaryText.dart';
import 'package:park254_s_parking_app/components/TertiaryText.dart';
import 'package:park254_s_parking_app/components/parking%20lots/myparking_screen.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/dataModels/VehicleModel.dart';
import 'package:park254_s_parking_app/functions/bookings/getBookingById.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:park254_s_parking_app/pages/search page/search_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../CircleWithIcon.dart';
import '../DottedHorizontalLine.dart';
import '../helper_functions.dart';

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
///   )
///);
class PaymentSuccessful extends StatefulWidget {
  final int price;
  final String destination;
  final TimeOfDay arrivalTime;
  final TimeOfDay leavingTime;
  final String bookingId;
  static const routeName = '/receipt';

  PaymentSuccessful({
    @required this.bookingId,
    @required this.price,
    @required this.destination,
    @required this.arrivalTime,
    @required this.leavingTime,
  });

  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  String transactionYear;
  String transactionMonth;
  String transactionDay;
  String mpesaReceiptNumber;
  NavigationProvider navigationDetails;
  UserWithTokenModel userDetails;
  VehicleModel vehicleDetails;
  GlobalKey globalKey = new GlobalKey();
  Map<String, dynamic> _dataMap;
  String _inputErrorText;
  String numberPlate;
  String vehicleModel;

  @override
  initState() {
    super.initState();
    if (mounted) {
      navigationDetails =
          Provider.of<NavigationProvider>(context, listen: false);
      userDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      vehicleDetails = Provider.of<VehicleModel>(context, listen: false);

      if (vehicleDetails != null && userDetails != null) {
        vehicleDetails.fetch(
            token: userDetails.user.accessToken.token,
            owner: userDetails.user.user.id);

        if (vehicleDetails.vehicleData.vehicles != null) {
          Vehicle vehicle =
              vehicleDetails.findByOwnerId(id: userDetails.user.user.id);
          numberPlate = vehicle.plate;
          vehicleModel = vehicle.model;

          _dataMap = {
            'numberPlate': numberPlate ?? 'No number plate',
            'model': vehicleModel ?? 'No model',
            'bookingId': widget.bookingId,
          };
        }
      }
    }
  }

  /// Creates custom row with title and value
  Widget _messageRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SecondaryText(content: title),
          TertiaryText(content: value),
        ],
      ),
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
                        _messageRow(
                            'Booking Id',
                            widget.bookingId != null
                                ? widget.bookingId.substring(0, 16)
                                : 'No bookingId'),
                        _messageRow(
                            'Mpesa Receipt No.',
                            mpesaReceiptNumber != null
                                ? mpesaReceiptNumber.toString()
                                : ''),
                        _messageRow('Price', 'Kes ${widget.price.toString()}'),
                        _messageRow(
                            'Number plate',
                            numberPlate != null
                                ? numberPlate.toString()
                                : 'No model'),
                        _messageRow('Date',
                            '${transactionYear ?? ''}-${transactionMonth ?? ''}-${transactionDay ?? ''}'),
                        // All this is done to be able get the exact UI we want.
                        _messageRow('Time',
                            '${widget.arrivalTime.minute > 9 ? ' ' + '${widget.arrivalTime.hour.toString()}:${widget.arrivalTime.minute.toString()}' : ' ' + '${widget.arrivalTime.hour.toString()}:0${widget.arrivalTime.minute.toString()}'} - ${widget.leavingTime.minute > 9 ? ' ' + '${widget.leavingTime.hour.toString()}:${widget.leavingTime.minute.toString()}' : ' ' + '${widget.leavingTime.hour.toString()}:0${widget.leavingTime.minute.toString()}'}'),
                      ],
                    ),
                  ),
                  flex: 10,
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
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
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
                    child: RepaintBoundary(
                      key: globalKey,
                      child: QrImage(
                          data: jsonEncode(_dataMap),
                          size: 0.5 * bodyHeight,
                          errorStateBuilder: (context, ex) {
                            log('[QR] Error - $ex');
                            setState(() {
                              _inputErrorText =
                                  'Error! Maybe your input value is too long';
                            });
                          }),
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
          flex: 2,
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
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage(
                                activeTab: 'myparking',
                              ))),
                      child: Center(
                        child: CircleWithIcon(
                          icon: Icons.home,
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
        InkWell(
          onTap: () async {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            navigationDetails.setNavigation();
            navigationDetails.setCurrentLocation(position);
            buildNotification(
                'On arrival, present the QR Code for scanning', 'info');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SearchPage()));
          },
          child: CircleWithIcon(
            icon: Icons.near_me,
            bgColor: globals.primaryColor,
            iconColor: globals.textColor,
            sizeFactor: 2,
          ),
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
    if (transactionDetails != null) {
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
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
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
                    flex: 17,
                  ),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    child: _dottedLine(),
                    flex: 29,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
