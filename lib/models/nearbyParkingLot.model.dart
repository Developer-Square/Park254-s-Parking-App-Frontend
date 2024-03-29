import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/features.model.dart';
import 'package:park254_s_parking_app/models/nearbyLocation.model.dart';

/// Creates a nearby parking lot object from Json
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
  final int price;
  final dynamic address;
  final dynamic city;
  final Features features;
  final int availableSpaces;

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
    @required this.price,
    @required this.address,
    @required this.city,
    @required this.features,
    @required this.availableSpaces,
  });

  factory NearbyParkingLot.fromJson(Map<String, dynamic> json) {
    return NearbyParkingLot(
      id: json['_id'],
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
      price: json['price'],
      address: json['address'],
      city: json['city'],
      features: Features.fromJson(json['features']),
      availableSpaces: json['availableSpaces'],
    );
  }
}
