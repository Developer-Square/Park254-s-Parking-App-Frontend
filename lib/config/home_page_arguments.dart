import 'package:flutter/material.dart';

class HomePageArguments {
  final String imgPath;
  final double parkingPrice;
  final String parkingPlaceName;
  final double rating;
  final double distance;
  final int parkingSlots;

  HomePageArguments(
      {@required this.imgPath,
      @required this.parkingPrice,
      @required this.parkingPlaceName,
      @required this.rating,
      @required this.distance,
      @required this.parkingSlots});
}
