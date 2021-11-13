import 'package:flutter/material.dart';

class ReceiptArguments {
  final String bookingId;
  final String parkingSpace;
  final int price;
  final String destination;
  final String address;
  final TimeOfDay arrivalTime;
  final DateTime arrivalDate;
  final TimeOfDay leavingTime;
  final DateTime leavingDate;

  ReceiptArguments({
    @required this.bookingId,
    @required this.parkingSpace,
    @required this.price,
    @required this.destination,
    @required this.address,
    @required this.arrivalTime,
    @required this.arrivalDate,
    @required this.leavingTime,
    @required this.leavingDate,
  });
}
