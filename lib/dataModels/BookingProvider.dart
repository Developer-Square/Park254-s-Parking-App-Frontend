import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'package:park254_s_parking_app/models/booking.populated.model.dart';

class BookingProvider with ChangeNotifier {
  int _price;
  String _destination;
  DateTime _arrivalDate;
  DateTime _leavingDate;
  TimeOfDay _arrivalTime;
  TimeOfDay _leavingTime;
  List<dynamic> _bookingDetails;
  List _parkingLotDetails = [];
  List _activeBookings = [];
  bool _update = false;
  // The ID for the pakringLot that needs updating.
  String _parkingLotId;
  String _bookingId;

  int get price => _price;
  String get destination => _destination;
  DateTime get arrivalDate => _arrivalDate;
  DateTime get leavingDate => _leavingDate;
  TimeOfDay get arrivalTime => _arrivalTime;
  TimeOfDay get leavingTime => _leavingTime;
  List<dynamic> get bookingDetails => _bookingDetails;
  List get parkingLotDetails => _parkingLotDetails;
  List get activeBookings => _activeBookings;
  bool get update => _update;
  String get parkingLotId => _parkingLotId;
  String get bookingId => _bookingId;

  void setUpdate({@required bool value}) {
    _update = value;
    notifyListeners();
  }

  void setBookingDetails({@required List<dynamic> value, List bookings}) {
    _bookingDetails = value;
    _activeBookings = bookings;
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
    @required arrivalDate,
    @required leavingDate,
  }) {
    _price = price;
    _destination = destination;
    _arrivalTime = arrival;
    _leavingTime = leaving;
    _arrivalDate = arrivalDate;
    _leavingDate = leavingDate;
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
