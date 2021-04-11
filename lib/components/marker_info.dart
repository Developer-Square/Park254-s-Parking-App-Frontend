import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  final String parkingPlaceFirstLetter;
  final String price;
  final String color;
  final LatLng location;
  final int rating;

  User(this.parkingPlaceFirstLetter, this.price, this.color, this.location,
      this.rating);
}
