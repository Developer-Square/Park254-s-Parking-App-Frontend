import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/GoButton.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/parking%20lots/myparking_screen.dart';
import 'package:park254_s_parking_app/components/transactions/PaymentSuccessful.dart';
import 'package:park254_s_parking_app/components/transactions/widgets/retry_modal.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/dataModels/BookingProvider.dart';
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/dataModels/VehicleModel.dart';
import 'package:park254_s_parking_app/functions/bookings/book.dart';
import 'package:park254_s_parking_app/functions/bookings/cancelBooking.dart';
import 'package:park254_s_parking_app/functions/bookings/updateBooking.dart';
import 'package:park254_s_parking_app/functions/transactions/pay.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../helper_functions.dart';

/// Creates a Pay Up pop up that prompts user to pay
///
/// ```dart
/// PayUp(
///   total: amount,
///   arrivalTime: arrivalTime
///   leavingTime: leavingTime
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
  final Function updateParkingTime;
  final String arrivalTime;
  final String leavingTime;

  PayUp({
    @required this.total,
    @required this.timeDatePicker,
    @required this.toggleDisplay,
    @required this.receiptGenerator,
    @required this.updateParkingTime,
    @required this.arrivalTime,
    @required this.leavingTime,
  });
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
  // Details from the store
  NearbyParkingListModel nearbyParkingListDetails;
  BookingProvider bookingDetails;
  // Using arrivalTime.hour is proving problematic and gives incorrect results.
  // i.e. if a user selects 3pm as their arrivalTime, the arrivalTime.hour will give.
  // us 3 hours instead of 15 hours.
  String bookingId;
  int arrivalHour;
  int arrivalMinute;
  int leavingHour;
  int leavingMinute;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      nearbyParkingListDetails =
          Provider.of<NearbyParkingListModel>(context, listen: false);
      bookingDetails = Provider.of<BookingProvider>(context, listen: false);
    }

    arrivalHour = int.parse(widget.arrivalTime.substring(10, 12));
    arrivalMinute = int.parse(widget.arrivalTime.substring(13, 15));
    leavingHour = int.parse(widget.leavingTime.substring(10, 12));
    leavingMinute = int.parse(widget.leavingTime.substring(13, 15));
  }

  void updateParkingLotBooking(TransactionModel transactionDetails) {
    if (bookingDetails != null && storeDetails != null) {
      transactionDetails.setLoading(true);
      final now = new DateTime.now();
      final DateTime entryTime = new DateTime(
          now.year, now.month, now.day, arrivalHour, arrivalMinute);
      final DateTime exitTime = new DateTime(
          now.year, now.month, now.day, leavingHour, leavingMinute);
      updateBooking(
        token: storeDetails.user.accessToken.token.toString(),
        bookingId: bookingDetails.bookingDetails[0].id,
        parkingLotId: bookingDetails.parkingLotDetails[0]['id'],
        entryTime: entryTime,
        exitTime: exitTime,
      ).then((value) {
        // Set the bookingId to be used incase the transaction fails.
        bookingId = value.id;
        // Call the mpesa STK push.
        callPaymentMethod(
          transactionDetails: transactionDetails,
          bookingId: value.id,
          type: 'update',
        );
      }).catchError((err) {
        transactionDetails.setLoading(false);
        log("In PayUp.dart, updateParkingLotBooking function");
        log(err.toString());
        buildNotification(err.message.toString(), 'error');
      });
    }
  }

  void createBooking(TransactionModel transactionDetails) {
    if (storeDetails != null &&
        nearbyParkingListDetails != null &&
        bookingDetails != null) {
      transactionDetails.setLoading(true);

      final now = new DateTime.now();
      final DateTime entryTime = new DateTime(
          now.year, now.month, now.day, arrivalHour, arrivalMinute);
      final DateTime exitTime = new DateTime(
          now.year, now.month, now.day, leavingHour, leavingMinute);

      book(
        token: storeDetails.user.accessToken.token.toString(),
        parkingLotId: nearbyParkingListDetails.nearbyParkingLot.id,
        clientId: storeDetails.user.user.id,
        spaces: 1,
        entryTime: entryTime,
        exitTime: exitTime,
      ).then((value) {
        // Set the bookingId to be used incase the transaction fails.
        bookingId = value.id;
        // Call the mpesa STK push.
        callPaymentMethod(
          transactionDetails: transactionDetails,
          bookingId: value.id,
          type: 'create',
        );
      }).catchError((err) {
        transactionDetails.setLoading(false);
        log("In PayUp.dart, createBooking function");
        log(err.toString());
        buildNotification(err.message.toString(), 'error');
      });
    }
  }

  /// Cancel the transaction when the user cancels the retryModal.
  void cancelParkingLotBooking({String access, String bookingId}) {
    if (access != null && bookingId != null) {
      cancelBooking(token: access, bookingId: bookingId).then((value) {
        if (value.isCancelled) {
          buildNotification(
              'Booking was cancelled due to a failed transaction', 'success');
        }
      }).catchError((err) {
        log("In PayUp.dart, cancelParkingLotBooking function");
        log(err.toString());
        buildNotification(err.message.toString(), 'error');
      });
    }
  }

  void callPaymentMethod({
    @required TransactionModel transactionDetails,
    @required String bookingId,
    String type,
  }) async {
    String access = storeDetails.user.accessToken.token;
    String phonenumber = '254' + storeDetails.user.user.phone.toString();
    num internationalPhoneNumber = int.parse(phonenumber);

    if (access != null) {
      pay(
        phoneNumber: internationalPhoneNumber,
        amount: widget.total,
        token: access,
        setCreatedAt: transactionDetails.setCreatedAt,
        setTransaction: transactionDetails.setTransaction,
        setLoading: transactionDetails.setLoading,
      ).then((value) {
        // If resultCode is equal to 0 then the transcation other than that.
        // then it failed.
        if (value.resultCode == 0) {
          transactionDetails.setLoading(false);
          buildNotification('Payment Successful', 'success');
          if (type == 'update') {
            buildNotification('Parking lot updated successfully', 'success');
          } else {
            buildNotification('Parking lot booked successfully', 'success');
          }

          // When a user is updating, redirect them to the myParkingScreen after.
          // payment is complete.
          if (bookingDetails != null) {
            if (bookingDetails.update) {
              widget.updateParkingTime();
            } else {
              // Move the payment successful page.
              widget.receiptGenerator(bookingDetails, bookingId);
            }
          } else {
            // Move the payment successful page.
            widget.receiptGenerator(bookingDetails, bookingId);
          }
        }
        // If the transaction failed and the user has not retried it then show retry modal.
        else if (value.resultCode == 503) {
          buildNotification(resultDesc ?? 'Transaction failed', 'error');

          retryModal(
            parentContext: context,
            transactionDetails: transactionDetails,
            total: widget.total,
            token: access,
            receiptGenerator: () =>
                widget.receiptGenerator(bookingDetails, bookingId),
            cancelBooking: () =>
                cancelParkingLotBooking(access: access, bookingId: bookingId),
          );
        }
      }).catchError((err) {
        cancelParkingLotBooking(access: access, bookingId: bookingId);
        transactionDetails.setLoading(false);
        log("In PayUp.dart, callPaymentMethod function");
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
                      onTap: bookingDetails != null
                          ? bookingDetails.update
                              ? () =>
                                  updateParkingLotBooking(transactionDetails)
                              : () => createBooking(transactionDetails)
                          : () => createBooking(transactionDetails),
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
