import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/DismissKeyboard.dart';
import 'package:park254_s_parking_app/components/GoButton.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/parking%20lots/myparking_screen.dart';
import 'package:park254_s_parking_app/components/transactions/PayUp.dart';
import 'package:park254_s_parking_app/components/transactions/PaymentSuccessful.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/config/receiptArguments.dart';
import 'package:park254_s_parking_app/dataModels/BookingProvider.dart';
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:provider/provider.dart';
import '../config/globals.dart' as globals;
import './PrimaryText.dart';
import './SecondaryText.dart';
import './BorderContainer.dart';
import 'package:park254_s_parking_app/components/TimeDatePicker.dart';

import 'SecondaryText.dart';

///Creates a booking page
///
/// Requires [bookingNumber], [destination], [parkingLotNumber], [price], and [imagePath]
/// E.g
/// ```dart
/// Navigator.pushNamed(
///   context,
///   Booking.routeName,
///   arguments: BookingArguments(
///      bookingNumber: 'haaga5441',
///      destination: 'Nairobi',
///      parkingLotNumber: 'pajh5114',
///      price: 10,
///      imagePath: 'assets/images/Park254_logo.png'
///   )
///);
///```
class Booking extends StatefulWidget {
  final String bookingNumber;
  final String destination;
  final String parkingLotNumber;
  final int price;
  final String imagePath;
  final String address;
  final DateTime entryDate;
  final DateTime exitDate;
  static const routeName = '/booking';

  Booking({
    @required this.bookingNumber,
    @required this.destination,
    @required this.parkingLotNumber,
    @required this.price,
    @required this.imagePath,
    @required this.address,
    this.entryDate,
    this.exitDate,
  });

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime leavingDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();
  DateTime lastDate = DateTime.now().add(Duration(days: 30));
  DateTime today = DateTime.now();
  TimeOfDay arrivalTime = TimeOfDay.now();
  TimeOfDay leavingTime = TimeOfDay.now();
  String vehicle = 'prius';
  String numberPlate = 'BBAGAAFAF';
  String driver = "No name set";
  String paymentMethod = 'MPESA';
  int amount = 0;
  bool showPayUp = false;
  bool isLoading;
  final List<String> paymentMethodList = <String>['MPESA'];
  final List<String> vehicleList = <String>['Camri', 'Prius'];
  final List<String> numberPlateList = <String>[
    'KCZ 123T',
    'KDB 234T',
    'KDA 345Y'
  ];
  final List<String> driverList = <String>['Linus', 'Ryan'];
  TransactionModel transactionDetails;
  BookingProvider bookingDetailsProvider;
  UserWithTokenModel userDetails;

  @override
  void initState() {
    super.initState();
    isLoading = false;

    if (mounted) {
      bookingDetailsProvider =
          Provider.of<BookingProvider>(context, listen: false);
      userDetails = Provider.of<UserWithTokenModel>(context, listen: false);

      if (widget.entryDate != null &&
          widget.exitDate != null &&
          bookingDetailsProvider != null) {
        // Populate the arrival and leaving date and time when updating.
        if (bookingDetailsProvider.update) {
          arrivalTime = TimeOfDay.fromDateTime(widget.entryDate);
          leavingTime = TimeOfDay.fromDateTime(widget.exitDate);
          arrivalDate = widget.entryDate;
          leavingDate = widget.exitDate;
        }
      }
    }
  }

  void showHideLoader(value) {
    setState(() {
      isLoading = value;
    });
  }

  /// shows date picker for arrival date
  void _selectArrivalDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: arrivalDate,
      firstDate: today,
      lastDate: lastDate,
    );

    if (picked != null && picked != arrivalDate) {
      setState(() {
        arrivalDate = picked;
      });
    }
  }

  /// Shows date picker for leaving date.
  ///
  /// Leaving date has to be set after arrival date.
  _selectLeavingDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: leavingDate,
      firstDate: today,
      lastDate: lastDate,
    );

    if (picked != null && picked != leavingDate) {
      setState(() {
        leavingDate = picked;
      });
    }
  }

  /// custom theme for the timePicker
  Theme _timeTheme(Widget child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: globals.textColor,
        accentColor: globals.textColor,
        colorScheme: ColorScheme.light(primary: globals.textColor),
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: child,
    );
  }

  /// shows date picker for arrival time
  _selectArrivalTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: arrivalTime,
      builder: (BuildContext context, Widget child) {
        return _timeTheme(child);
      },
    );

    if (picked != null && picked != arrivalTime) {
      setState(() {
        arrivalTime = picked;
      });
    }
  }

  ///shows date picker for leaving time
  _selectLeavingTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: leavingTime,
      builder: (BuildContext context, Widget child) {
        return _timeTheme(child);
      },
    );

    if (picked != null && picked != leavingTime) {
      setState(() {
        leavingTime = picked;
      });
    }
  }

  /// Calculates the parking duration and cost
  String _parkingTime() {
    Duration parkingDays;
    double totalTime = 0;
    // If the user is updating the time, he/she should only be charged for the difference.
    // between the initial leaving time and the leaving time he/she has set.
    if (bookingDetailsProvider != null) {
      if (bookingDetailsProvider.update) {
        parkingDays = leavingDate.difference(widget.exitDate);
        totalTime = (leavingTime.hour + (leavingTime.minute / 60)) -
            (widget.exitDate.hour + (widget.exitDate.minute / 60)) +
            parkingDays.inHours;
      } else {
        parkingDays = leavingDate.difference(arrivalDate);
        totalTime = (leavingTime.hour + (leavingTime.minute / 60)) -
            (arrivalTime.hour + (arrivalTime.minute / 60)) +
            parkingDays.inHours;
      }
    } else {
      parkingDays = leavingDate.difference(arrivalDate);
      totalTime = (leavingTime.hour + (leavingTime.minute / 60)) -
          (arrivalTime.hour + (arrivalTime.minute / 60)) +
          parkingDays.inHours;
    }

    int hours;
    int minutes;
    if (totalTime >= 0) {
      hours = totalTime.floor();
      minutes = ((totalTime - totalTime.floorToDouble()) * 60).round();
    } else {
      hours = totalTime.ceil();
      minutes = ((totalTime - totalTime.ceilToDouble()) * 60).round();
    }
    int parkingHours = totalTime.ceil();
    amount = (parkingHours < 0) ? 0 : parkingHours * widget.price;
    return (hours == 0)
        ? '${minutes}m'
        : (minutes == 0)
            ? '${hours}h'
            : (hours < 0 && minutes < 0)
                ? '${hours}h ${minutes.abs()}m'
                : '${hours}h ${minutes}m';
  }

  /// Toggles the display of [PayUp widget]
  void _togglePayUp() {
    setState(() {
      showPayUp = !showPayUp;
    });
  }

  /// Generates receipt
  void _generateReceipt(
      {@required BookingProvider bookingDetails, @required String bookingId}) {
    if (bookingDetails != null && bookingDetailsProvider != null) {
      bookingDetailsProvider.setUpdate(value: true);
      bookingDetails.setBooking(
        price: amount,
        destination: widget.destination,
        arrival: arrivalTime,
        leaving: leavingTime,
        arrivalDate: arrivalDate,
        leavingDate: leavingDate,
      );
    }

    Navigator.pushNamed(context, PaymentSuccessful.routeName,
        arguments: ReceiptArguments(
          bookingId: bookingId,
          parkingSpace: widget.parkingLotNumber,
          price: amount,
          destination: widget.destination,
          address: widget.address,
          arrivalTime: arrivalTime,
          leavingTime: leavingTime,
        ));
  }

  Widget _dropDown(
    String value,
    List<String> valueList,
    Color textColor,
    FontWeight fontWeight,
  ) {
    return DropdownButton(
      value: valueList[0],
      items: valueList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Align(
            child: Text(value),
            alignment: Alignment.centerLeft,
          ),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          value = newValue;
        });
      },
      underline: Container(height: 0),
      style: TextStyle(color: textColor, fontWeight: fontWeight, fontSize: 16),
    );
  }

  Widget _destination() {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
                bottom: 10, left: width / 20, right: width / 20),
            child: PrimaryText(
              content: 'Destination',
            ),
          ),
          flex: 1,
          fit: FlexFit.loose,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: width / 20, right: width / 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: widget.imagePath.contains('https')
                      ? Image.network(widget.imagePath)
                      : Image(
                          image: AssetImage(
                              'assets/images/parking_photos/parking_1.jpg'),
                        ),
                  flex: 2,
                  fit: FlexFit.loose,
                ),
                Spacer(),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: PrimaryText(
                          content: widget.destination,
                        ),
                        flex: 1,
                        fit: FlexFit.loose,
                      ),
                      Flexible(
                        child: Text(
                          '${widget.destination}-${widget.parkingLotNumber.substring(0, 3)}',
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        flex: 1,
                        fit: FlexFit.loose,
                      ),
                    ],
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
          flex: 2,
          fit: FlexFit.loose,
        ),
      ],
    );
  }

  /// Creates a row with title and value
  Widget _vehicleRow(String title, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SecondaryText(
          content: title,
        ),
        child,
      ],
    );
  }

  Widget _vehicle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Align(
            alignment: Alignment.centerLeft,
            child: PrimaryText(
              content: 'Vehicle',
            ),
          ),
          flex: 2,
          fit: FlexFit.loose,
        ),
        Flexible(
          child: _vehicleRow(
            'Type',
            _dropDown(vehicle, vehicleList, Colors.blue[400], FontWeight.bold),
          ),
          flex: 1,
          fit: FlexFit.loose,
        ),
        Flexible(
          child: _vehicleRow(
            'Plate Number',
            _dropDown(numberPlate, numberPlateList, globals.textColor,
                FontWeight.normal),
          ),
          flex: 1,
          fit: FlexFit.loose,
        ),
      ],
    );
  }

  Widget _driverInfo() {
    String name = 'No Name';
    if (userDetails != null) {
      name = userDetails.user.user.name;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PrimaryText(content: 'Driver Info'),
        SecondaryText(content: name),
      ],
    );
  }

  Widget _paymentMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PrimaryText(content: 'Payment Method'),
        _dropDown(paymentMethod, paymentMethodList, Colors.blue[400],
            FontWeight.bold),
      ],
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PrimaryText(content: 'Price'),
        PrimaryText(content: 'Kes ${amount.toString()}'),
      ],
    );
  }

  Widget _paymentButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: GoButton(onTap: () => _togglePayUp(), title: 'Pay now'),
    );
  }

  Widget _timeDatePicker() {
    return TimeDatePicker(
        // If the user is updating time, they're not allowed to update the arrival time.
        pickArrivalDate: bookingDetailsProvider != null
            ? bookingDetailsProvider.update
                ? () => _selectArrivalDate(context)
                : () {}
            : () {},
        pickArrivalTime: bookingDetailsProvider != null
            ? bookingDetailsProvider.update
                ? () => _selectArrivalTime(context)
                : () {}
            : () {},
        pickLeavingDate: () => _selectLeavingDate(context),
        pickLeavingTime: () => _selectLeavingTime(context),
        arrivalDate: arrivalDate.day == DateTime.now().day
            ? 'Today, '
            : '${arrivalDate.day.toString()}/${arrivalDate.month.toString()},',
        arrivalTime: arrivalTime.minute > 9
            ? ' ' +
                '${arrivalTime.hour.toString()}:${arrivalTime.minute.toString()}'
            : ' ' +
                '${arrivalTime.hour.toString()}:0${arrivalTime.minute.toString()}',
        leavingDate: leavingDate.day == DateTime.now().day
            ? 'Today, '
            : '${leavingDate.day.toString()}/${leavingDate.month.toString()},',
        leavingTime: leavingTime.minute > 9
            ? ' ' +
                '${leavingTime.hour.toString()}:${leavingTime.minute.toString()}'
            : ' ' +
                '${leavingTime.hour.toString()}:0${leavingTime.minute.toString()}',
        parkingTime: _parkingTime());
  }

  void updateParkingTime() {
    buildNotification('Parking time updated successfully', 'success');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyParkingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double finalHeight =
        height - padding.top - padding.bottom - kToolbarHeight;
    transactionDetails = Provider.of<TransactionModel>(context);
    if (transactionDetails != null) {
      isLoading = transactionDetails.loader;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            title: Column(
              children: <Widget>[
                PrimaryText(
                  content: 'Booking',
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            leading: BackArrow()),
        body: DismissKeyboard(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: SizedBox(
                  width: width,
                  height: finalHeight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _destination(),
                          flex: 2,
                        ),
                        Expanded(
                          child: _timeDatePicker(),
                          flex: 1,
                        ),
                        Expanded(
                          child: BorderContainer(content: _driverInfo()),
                          flex: 1,
                        ),
                        Expanded(
                          child: BorderContainer(content: _paymentMethod()),
                          flex: 1,
                        ),
                        Expanded(
                          child: BorderContainer(content: _price()),
                          flex: 1,
                        ),
                        Expanded(
                          child: _paymentButton(),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              showPayUp
                  ? PayUp(
                      total: amount,
                      timeDatePicker: _timeDatePicker(),
                      toggleDisplay: () => _togglePayUp(),
                      receiptGenerator: (bookingDetails, bookingId) =>
                          _generateReceipt(
                              bookingDetails: bookingDetails,
                              bookingId: bookingId),
                      updateParkingTime: () => updateParkingTime(),
                      arrivalTime: arrivalTime.toString(),
                      leavingTime: leavingTime.toString(),
                    )
                  : Container(),
              isLoading ? Loader() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
