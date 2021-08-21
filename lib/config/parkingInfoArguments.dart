import 'package:flutter/material.dart';

class ParkingInfoArguments {
  final List<dynamic> images;
  final String name;
  final bool accessibleParking;
  final bool cctv;
  final bool carWash;
  final bool evCharging;
  final bool valetParking;
  final num rating;

  ParkingInfoArguments({
    @required this.images,
    @required this.name,
    @required this.accessibleParking,
    @required this.cctv,
    @required this.carWash,
    @required this.evCharging,
    @required this.valetParking,
    @required this.rating,
  });
}
