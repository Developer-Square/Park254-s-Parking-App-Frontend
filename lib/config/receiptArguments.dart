import 'package:flutter/material.dart';

class ReceiptArguments {
  final String bookingNumber;
  final String parkingSpace;
  final int price;
  final String destination;
  final String address;

  ReceiptArguments({
    @required this.bookingNumber,
    @required this.parkingSpace,
    @required this.price,
    @required this.destination,
    @required this.address,
  });
}