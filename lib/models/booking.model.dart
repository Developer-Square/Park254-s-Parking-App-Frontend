import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/features.model.dart';
import 'package:park254_s_parking_app/models/location.model.dart';

/// Creates a parking lot object from Json
class Booking {
  final String id;
  final String parkingLotId;
  final String clientId;
  final int spaces;
  final DateTime entryTime;
  final DateTime exitTime;
  final bool isCancelled;

  Booking(
      {@required this.id,
      @required this.parkingLotId,
      @required this.clientId,
      @required this.spaces,
      @required this.entryTime,
      @required this.exitTime,
      @required this.isCancelled});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      parkingLotId: json['parkingLotId'],
      clientId: json['clientId'],
      spaces: json['spaces'],
      entryTime: json['entryTime'],
      exitTime: json['exitTime'],
      isCancelled: json['isCancelled'],
    );
  }
}
