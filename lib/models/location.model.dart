import 'package:flutter/material.dart';

/// Converts a location object to and from Json
class Location {
  final String type;
  final List<dynamic> coordinates;
  final String id;

  Location({
    @required this.type,
    @required this.coordinates,
    @required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}
