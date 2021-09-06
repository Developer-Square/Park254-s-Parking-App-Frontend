import 'package:flutter/material.dart';

class BookingDetails {
  final String id;
  final String parkingLotId;
  final String clientId;
  final num spaces;
  final DateTime entryTime;
  final DateTime exitTime;
  final bool isCancelled;

  BookingDetails({
    this.id,
    @required this.parkingLotId,
    @required this.clientId,
    @required this.spaces,
    @required this.entryTime,
    @required this.exitTime,
    this.isCancelled,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      id: json['id'],
      parkingLotId: json['parkingLotId'],
      clientId: json['clientId'],
      spaces: json['spaces'],
      entryTime: DateTime.parse(json['entryTime']),
      exitTime: DateTime.parse(json['exitTime']),
      isCancelled: json['isCancelled'],
    );
  }

  Map<String, dynamic> toJson() => {
        'parkingLotId': parkingLotId,
        'clientId': clientId,
        'spaces': spaces.toString(),
        'entryTime': entryTime.toUtc().toIso8601String(),
        'exitTime': exitTime.toUtc().toIso8601String(),
      };
}
