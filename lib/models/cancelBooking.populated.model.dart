import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import './cancelBookingUser.model.dart';

class CancelBookingDetailsPopulated {
  final String id;
  final ParkingLot parkingLotId;
  final CancelBookingUser clientId;
  final num spaces;
  final DateTime entryTime;
  final DateTime exitTime;
  final bool isCancelled;

  CancelBookingDetailsPopulated({
    @required this.id,
    @required this.parkingLotId,
    @required this.clientId,
    @required this.spaces,
    @required this.entryTime,
    @required this.exitTime,
    @required this.isCancelled,
  });

  factory CancelBookingDetailsPopulated.fromJson(Map<String, dynamic> json) {
    return CancelBookingDetailsPopulated(
      id: json['id'],
      parkingLotId: ParkingLot.fromJson(json['parkingLotId']),
      clientId: CancelBookingUser.fromJson(json['clientId']),
      spaces: json['spaces'],
      entryTime: DateTime.parse(json['entryTime']),
      exitTime: DateTime.parse(json['exitTime']),
      isCancelled: json['isCancelled'],
    );
  }
}
