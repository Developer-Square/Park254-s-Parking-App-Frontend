import 'package:flutter/material.dart';

class ReceiptArguments {
  final String parkingSpace;
  final int price;
  final String destination;
  final String address;
  final String mpesaReceiptNo;
  final TimeOfDay arrivalTime;
  final TimeOfDay leavingTime;
  final String transactionDate;

  ReceiptArguments(
      {@required this.parkingSpace,
      @required this.price,
      @required this.destination,
      @required this.address,
      @required this.mpesaReceiptNo,
      @required this.arrivalTime,
      @required this.leavingTime,
      @required this.transactionDate});
}
