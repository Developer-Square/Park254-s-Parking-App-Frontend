import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/Booking.dart';

class BookingTest extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Booking(
        bookingNumber: 'haaga5441',
        destination: 'Nairobi',
        parkingLotNumber: 'pajh5114',
        price: 10,
        imagePath: 'assets/images/Park254_logo.png'
    );
  }
}