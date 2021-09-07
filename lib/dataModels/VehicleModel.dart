import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/vehicles/getVehicles.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import 'package:park254_s_parking_app/models/vehicleList.model.dart';

class VehicleModel with ChangeNotifier {
  VehicleList vehicleData = new VehicleList(
    vehicles: null,
    page: null,
    limit: null,
    totalPages: null,
    totalResults: null,
  );
  bool loading = false;

  VehicleList get vehicle => vehicleData;

  void fetch({
    @required String token,
    @required String owner,
    String plate = '',
    String sortBy = '',
    int limit = 10,
    int page = 1,
  }) async {
    loading = true;
    vehicleData = await getVehicles(
      token: token,
      plate: plate,
      owner: owner,
      sortBy: sortBy,
      limit: limit,
      page: page,
    );
    loading = false;
    notifyListeners();
  }

  void add({@required Vehicle vehicle}) {
    vehicleData.vehicles.add(vehicle);
    notifyListeners();
  }

  void remove({@required Vehicle vehicle}) {
    vehicleData.vehicles.removeWhere((v) => v.id == vehicle.id);
    notifyListeners();
  }

  void clear() {
    vehicleData.vehicles.clear();
    notifyListeners();
  }

  Vehicle findById({@required String id}) {
    return vehicleData.vehicles.firstWhere((v) => v.id == id);
  }

  void updateVehicle(Vehicle vehicle) {
    num index = vehicleData.vehicles.indexWhere((v) => v.id == vehicle.id);
    vehicleData.vehicles[index] = vehicle;
    notifyListeners();
  }
}
