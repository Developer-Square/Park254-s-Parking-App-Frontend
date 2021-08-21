import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getNearbyParkingLots.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLots.model.dart';

class NearbyParkingListModel with ChangeNotifier {
  NearbyParkingLots _nearbyParking = new NearbyParkingLots(lots: null);
  bool loading = false;
  Position _currentPosition;

  NearbyParkingLots get nearbyParking => _nearbyParking;
  Position get currentPosition => _currentPosition;

  void setCurrentPositon(Position value) {
    _currentPosition = value;
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
