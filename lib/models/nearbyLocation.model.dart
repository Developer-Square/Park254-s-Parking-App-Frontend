import 'package:flutter/material.dart';

class NearbyLocation {
  final String type;
  final List<dynamic> coordinates;
  final String id;

  NearbyLocation({
    @required this.type,
    @required this.coordinates,
    this.id,
  });

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    return NearbyLocation(
      type: json['type'],
      coordinates: json['coordinates'],
      id: json['_id'],
    );
  }
}
