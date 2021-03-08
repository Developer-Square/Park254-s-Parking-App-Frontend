import 'package:flutter/material.dart';

class BookingArguments {
  final String bookingNumber;
  final String destination;
  final String parkingLotNumber;
  final int price;
  final String imagePath;

  BookingArguments({
    @required this.bookingNumber,
    @required this.destination,
    @required this.parkingLotNumber,
    @required this.price,
    @required this.imagePath,
  });
}
