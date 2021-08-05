import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/features.model.dart';
import 'package:park254_s_parking_app/models/location.model.dart';

/// Creates a parking lot object from Json
class ParkingLot {
  final String id;
  final String owner;
  final String name;
  final int spaces;
  final List<dynamic> images;
  final Location location;
  final int ratingValue;
  final int ratingCount;
  final num rating;
  final int price;
  final String address;
  final String city;
  final Features features;

  ParkingLot({
    @required this.id,
    @required this.owner,
    @required this.name,
    @required this.spaces,
    @required this.images,
    @required this.location,
    @required this.ratingCount,
    @required this.ratingValue,
    @required this.rating,
    @required this.address,
    @required this.city,
    @required this.price,
    @required this.features,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      spaces: json['spaces'],
      images: (json['images'] as List).toList(),
      location: Location.fromJson(json['location']),
      ratingCount: json['ratingCount'],
      ratingValue: json['ratingValue'],
      rating: (json['ratingCount'] == 0)
          ? 0
          : json['ratingValue'] / json['ratingCount'],
      price: json['price'],
      address: json['address'],
      city: json['city'],
      features: Features.fromJson(json['features']),
    );
  }
}
