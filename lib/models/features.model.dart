import 'package:flutter/material.dart';

/// Converts a parking lot features object to and from Json
class Features {
  final bool accessibleParking;
  final bool cctv;
  final bool carWash;
  final bool evCharging;
  final bool valetParking;
  final String id;

  Features({
    @required this.accessibleParking,
    @required this.cctv,
    @required this.carWash,
    @required this.evCharging,
    @required this.valetParking,
    this.id,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      accessibleParking: json['accessibleParking'],
      cctv: json['cctv'],
      carWash: json['carWash'],
      evCharging: json['evCharging'],
      valetParking: json['valetParking'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'accessibleParking': accessibleParking,
        'cctv': cctv,
        'carWash': carWash,
        'evCharging': evCharging,
        'valetParking': valetParking
      };
}
