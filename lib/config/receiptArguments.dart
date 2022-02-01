import 'package:flutter/material.dart';

class ReceiptArguments {
  final String bookingId;
  final int price;
  final String destination;
  final TimeOfDay arrivalTime;
  final DateTime arrivalDate;
  final TimeOfDay leavingTime;
  final DateTime leavingDate;

  ReceiptArguments({
    @required this.bookingId,
    @required this.price,
    @required this.destination,
    @required this.arrivalTime,
    @required this.arrivalDate,
    @required this.leavingTime,
    @required this.leavingDate,
  });
}
