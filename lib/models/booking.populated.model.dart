import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';

class BookingDetailsPopulated {
  final String id;
  final ParkingLot parkingLotId;
  final String clientId;
  final num spaces;
  final DateTime entryTime;
  final DateTime exitTime;
  final bool isCancelled;

  BookingDetailsPopulated({
    @required this.id,
    @required this.parkingLotId,
    @required this.clientId,
    @required this.spaces,
    @required this.entryTime,
    @required this.exitTime,
    @required this.isCancelled,
  });

  factory BookingDetailsPopulated.fromJson(Map<String, dynamic> json) {
    return BookingDetailsPopulated(
      id: json['id'],
      parkingLotId: ParkingLot.fromJson(json['parkingLotId']),
      clientId: json['clientId'],
      spaces: json['spaces'],
      entryTime: DateTime.parse(json['entryTime']),
      exitTime: DateTime.parse(json['exitTime']),
      isCancelled: json['isCancelled'],
    );
  }
}
