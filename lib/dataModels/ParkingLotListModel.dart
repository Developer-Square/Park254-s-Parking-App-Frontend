import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import 'package:park254_s_parking_app/models/queryParkingLots.models.dart';

class ParkingLotListModel with ChangeNotifier {
  QueryParkingLots _parkingLotList = new QueryParkingLots(
    parkingLots: null,
    page: null,
    limit: null,
    totalPages: null,
    totalResults: null,
  );
  bool loading = false;

  QueryParkingLots get parkingLotList => _parkingLotList;

  void fetch({
    @required String token,
    String name = '',
    String owner = '',
    String sortBy = '',
    int limit = 10,
    int page = 1,
  }) async {
    loading = true;
    _parkingLotList = await getParkingLots(
      token: token,
      name: name,
      owner: owner,
      sortBy: sortBy,
      limit: limit,
      page: page,
    );
    loading = false;
    notifyListeners();
  }

  void add({@required ParkingLot parkingLot}) {
    _parkingLotList.parkingLots.add(parkingLot);
    notifyListeners();
  }

  void remove({@required ParkingLot parkingLot}) {
    _parkingLotList.parkingLots.removeWhere((p) => p.id == parkingLot.id);
    notifyListeners();
  }

  void clear() {
    _parkingLotList.parkingLots.clear();
    notifyListeners();
  }

  ParkingLot findById({@required String id}) {
    return _parkingLotList.parkingLots.firstWhere((p) => p.id == id);
  }

  void updateParkingLot(ParkingLot parkingLot) {
    num index =
        _parkingLotList.parkingLots.indexWhere((p) => p.id == parkingLot.id);
    _parkingLotList.parkingLots[index] = parkingLot;
    notifyListeners();
  }
}
