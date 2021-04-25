import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Creates a List of all the available parking place.
///
/// It includes all the details E.g.
/// ```
/// parkingPlace, rating, number of parking slots available,
/// location of the parking places e.t.c
/// ```
class Parking {
  String parkingPlaceName;
  String type;
  double rating;
  int parkingSlots;
  double distance;
  String thumbNail;
  LatLng locationCoords;
  bool searched;
  double price;

  Parking(
      {this.parkingPlaceName,
      this.type,
      this.rating,
      this.parkingSlots,
      this.distance,
      this.thumbNail,
      this.locationCoords,
      this.searched,
      this.price});
}

final List<Parking> parkingPlaces = [
  Parking(
      searched: true,
      price: 10,
      parkingPlaceName: 'Parking on Wabera St',
      type: 'PARKING MALL',
      rating: 4.4,
      parkingSlots: 5,
      distance: 345,
      locationCoords: LatLng(-1.285128, 36.821934),
      thumbNail: 'assets/images/parking_photos/parking_1.jpg'),
  Parking(
      searched: true,
      price: 10,
      parkingPlaceName: 'Parking on Wabera St',
      type: 'PARKING MALL',
      rating: 4.4,
      parkingSlots: 5,
      distance: 345,
      locationCoords: LatLng(-1.285128, 36.821934),
      thumbNail: 'assets/images/parking_photos/parking_1.jpg'),
  Parking(
      searched: false,
      price: 14,
      parkingPlaceName: 'First Church of Christ',
      type: 'PARKING MALL',
      rating: 4.1,
      parkingSlots: 3,
      distance: 450,
      locationCoords: LatLng(-1.28362, 36.8142),
      thumbNail: 'assets/images/parking_photos/parking_2.jpg'),
  Parking(
      searched: false,
      price: 19,
      parkingPlaceName: 'Parklands Ave, Nairobi',
      type: 'PARKING MALL',
      rating: 2.1,
      parkingSlots: 3,
      distance: 450,
      locationCoords: LatLng(-1.308173, 36.823869),
      thumbNail: 'assets/images/parking_photos/parking_3.jpg')
];
