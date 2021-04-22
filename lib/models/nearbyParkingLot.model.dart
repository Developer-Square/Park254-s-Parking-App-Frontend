import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/nearbyLocation.model.dart';

class NearbyParkingLot {
  final String id;
  final String owner;
  final String name;
  final int spaces;
  final List<dynamic> images;
  final NearbyLocation location;
  final int ratingValue;
  final int ratingCount;
  final num rating;
  final num distance;

  NearbyParkingLot({
    @required this.id,
    @required this.owner,
    @required this.name,
    @required this.spaces,
    @required this.images,
    @required this.location,
    @required this.ratingCount,
    @required this.ratingValue,
    @required this.rating,
    @required this.distance,
  });

  factory NearbyParkingLot.fromJson(Map<String, dynamic> json) {
    return NearbyParkingLot(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      spaces: json['spaces'],
      images: (json['images'] as List).toList(),
      location: NearbyLocation.fromJson(json['location']),
      ratingCount: json['ratingCount'],
      ratingValue: json['ratingValue'],
      rating: (json['ratingCount'] == 0)
          ? 0
          : json['ratingValue'] / json['ratingCount'],
      distance: json['address']['distance'],
    );
  }
}
