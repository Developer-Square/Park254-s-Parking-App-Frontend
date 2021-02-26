import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Parking {
  String parkingPlaceName;
  String type;
  double rating;
  int parkingSlots;
  double distance;
  String thumbNail;
  LatLng locationCoords;

  Parking(
      {this.parkingPlaceName,
      this.type,
      this.rating,
      this.parkingSlots,
      this.distance,
      this.thumbNail,
      this.locationCoords});
}

final List<Parking> parkingPlaces = [
  Parking(
      parkingPlaceName: 'Parking on Wabera St',
      type: 'PARKING MALL',
      rating: 4.4,
      parkingSlots: 5,
      distance: 345,
      locationCoords: LatLng(-1.285128, 36.821934),
      thumbNail: 'assets/images/parking_photos/parking_1.jpg'),
  Parking(
      parkingPlaceName: 'First Church of Christ',
      type: 'PARKING MALL',
      rating: 4.1,
      parkingSlots: 3,
      distance: 450,
      locationCoords: LatLng(-1.28362, 36.8142),
      thumbNail: 'assets/images/parking_photos/parking_2.jpg'),
  Parking(
      parkingPlaceName: 'First Church of Christ',
      type: 'PARKING MALL',
      rating: 4.1,
      parkingSlots: 3,
      distance: 450,
      locationCoords: LatLng(-1.308173, 36.823869),
      thumbNail: 'assets/images/parking_photos/parking_3.jpg')
];
