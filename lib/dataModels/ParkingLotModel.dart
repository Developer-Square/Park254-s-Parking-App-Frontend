import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLotById.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';

/// Parking lot model object with getters and setters
class ParkingLotModel with ChangeNotifier {
  ParkingLot _parkingLot = new ParkingLot(
    id: null,
    owner: null,
    name: null,
    spaces: null,
    images: null,
    location: null,
    ratingCount: null,
    ratingValue: null,
    rating: null,
    address: null,
    city: null,
    price: null,
    availableSpaces: null,
  );
  bool loading = false;

  ParkingLot get parkingLot => _parkingLot;

  void fetch({
    @required String token,
    @required String parkingLotId,
  }) async {
    loading = true;
    _parkingLot =
        await getParkingLotById(token: token, parkingLotId: parkingLotId);
    loading = false;

    notifyListeners();
  }

  set parkingLot(ParkingLot value) {
    _parkingLot = value;

    notifyListeners();
  }

  void clear() {
    _parkingLot = new ParkingLot(
      id: null,
      owner: null,
      name: null,
      spaces: null,
      images: null,
      location: null,
      ratingCount: null,
      ratingValue: null,
      rating: null,
      address: null,
      city: null,
      price: null,
      availableSpaces: null,
    );
  }
}
