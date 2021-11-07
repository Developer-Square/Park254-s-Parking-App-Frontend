import 'package:flutter/material.dart';

class ReceiptArguments {
  final String bookingId;
  final String parkingSpace;
  final int price;
  final String destination;
  final String address;
  final TimeOfDay arrivalTime;
  final TimeOfDay leavingTime;

  ReceiptArguments({
    @required this.bookingId,
    @required this.parkingSpace,
    @required this.price,
    @required this.destination,
    @required this.address,
    @required this.arrivalTime,
    @required this.leavingTime,
  });
}
