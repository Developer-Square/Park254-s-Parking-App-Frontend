import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getNearbyParkingLots.dart';
import 'package:park254_s_parking_app/models/directions.model.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLots.model.dart';

class NearbyParkingListModel with ChangeNotifier {
  NearbyParkingLots _nearbyParking = new NearbyParkingLots(lots: null);
  NearbyParkingLot _nearbyParkingLot = new NearbyParkingLot(
    id: null,
    city: null,
    owner: null,
    images: null,
    price: null,
    rating: null,
    ratingCount: null,
    ratingValue: null,
    location: null,
    spaces: null,
    features: null,
    name: null,
    address: null,
    distance: null,
  );
  bool loading = false;
  bool _showNearByParkingLots = false;
  Position _currentPosition;
  Directions _directionsInfo;

  NearbyParkingLots get nearbyParking => _nearbyParking;
  NearbyParkingLot get nearbyParkingLot => _nearbyParkingLot;
  Position get currentPosition => _currentPosition;
  Directions get directionsInfo => _directionsInfo;
  bool get showNearByParkingLots => _showNearByParkingLots;

  void setCurrentPositon(Position value) {
    _currentPosition = value;
    notifyListeners();
  }

  void setNearByParkingLots(String value) {
    // If the function is being called by the booking tab close icon.
    // then add hide/show functionality else hide map buttons remains true
    if (value == 'bookingTab') {
      _showNearByParkingLots = !_showNearByParkingLots;
    } else {
      _showNearByParkingLots = true;
    }
    notifyListeners();
  }

  void fetch({
    @required String token,
    @required num longitude,
    @required num latitude,
    num maxDistance = 500,
  }) async {
    loading = true;
    _nearbyParking = await getNearbyParkingLots(
      token: token,
      longitude: longitude,
      latitude: latitude,
      maxDistance: maxDistance,
    );
    loading = false;
    notifyListeners();
  }

  void add({@required NearbyParkingLot parkingLot}) {
    _nearbyParking.lots.add(parkingLot);
    notifyListeners();
  }

  // Add the parking lot selected by the user in the nearbyparking widget.
  void setNearbyParkingLot({@required NearbyParkingLot value}) {
    _nearbyParkingLot = value;
    notifyListeners();
  }

  // Set the destination details to be used to make the polylines when,
  // directing a user.
  void setDirections({@required Directions value}) {
    _directionsInfo = value;
    notifyListeners();
  }

  void remove({@required NearbyParkingLot parkingLot}) {
    _nearbyParking.lots.removeWhere((p) => p.id == parkingLot.id);
    notifyListeners();
  }

  void clear() {
    _nearbyParking.lots.clear();
    notifyListeners();
  }

  NearbyParkingLot findById({@required String id}) {
    return _nearbyParking.lots.firstWhere((p) => p.id == id);
  }

  set updateParkingLot(NearbyParkingLot parkingLot) {
    num index = _nearbyParking.lots.indexWhere((p) => p.id == parkingLot.id);
    _nearbyParking.lots[index] = parkingLot;
    notifyListeners();
  }
}
