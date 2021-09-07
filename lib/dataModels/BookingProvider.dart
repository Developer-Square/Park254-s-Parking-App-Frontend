import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';

class BookingProvider with ChangeNotifier {
  int _price;
  String _destination;
  TimeOfDay _arrivalTime;
  TimeOfDay _leavingTime;
  List<BookingDetails> _bookingDetails;
  List _parkingLotDetails = [];

  int get price => _price;
  String get destination => _destination;
  TimeOfDay get arrivalTime => _arrivalTime;
  TimeOfDay get leavingTime => _leavingTime;
  List<BookingDetails> get bookingDetails => _bookingDetails;
  List get parkingLotDetails => _parkingLotDetails;

  void setBookingDetails({@required List<BookingDetails> value}) {
    _bookingDetails = value;
    notifyListeners();
  }

  void setParkingLotDetails({@required List value}) {
    _parkingLotDetails = value;
    notifyListeners();
  }

  void setBooking({
    @required price,
    @required destination,
    @required arrival,
    @required leaving,
  }) {
    _price = price;
    _destination = destination;
    _arrivalTime = arrival;
    _leavingTime = leaving;
    notifyListeners();
  }

  void clear() {
    _price = null;
    _destination = null;
    _arrivalTime = null;
    _leavingTime = null;
    notifyListeners();
  }
}
