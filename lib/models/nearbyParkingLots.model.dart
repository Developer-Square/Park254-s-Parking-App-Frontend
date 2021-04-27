import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';

class NearbyParkingLots {
  final List<NearbyParkingLot> lots;

  NearbyParkingLots({
    @required this.lots,
  });

  factory NearbyParkingLots.fromJson(Map<String, dynamic> json) {
    return NearbyParkingLots(
      lots: (json['results'] as List)
          .map(
              (nearbyParkingLot) => NearbyParkingLot.fromJson(nearbyParkingLot))
          .toList(),
    );
  }
}
