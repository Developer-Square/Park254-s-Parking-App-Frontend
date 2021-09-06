import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BookingProvider with ChangeNotifier {
  int _price;
  String _destination;
  TimeOfDay _arrivalTime;
  TimeOfDay _leavingTime;

  int get price => _price;
  String get destination => _destination;
  TimeOfDay get arrivalTime => _arrivalTime;
  TimeOfDay get leavingTime => _leavingTime;

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
