import 'package:flutter/material.dart';

class HomePageArguements {
  final String imgPath;
  final int parkingPrice;
  final String parkingPlaceName;
  final double rating;
  final double distance;
  final int parkingSlots;

  HomePageArguements(
      {@required this.imgPath,
      @required this.parkingPrice,
      @required this.parkingPlaceName,
      @required this.rating,
      @required this.distance,
      @required this.parkingSlots});
}
