import 'package:flutter/material.dart';

class MoreInfoArguments {
  final String destination;
  final String city;
  final int distance;
  final int price;
  final double rating;
  final int availableSpaces;
  final List availableLots;
  final String address;
  final String imageOne;
  final String imageTwo;

  MoreInfoArguments({
    @required this.destination,
    @required this.city,
    @required this.distance,
    @required this.price,
    @required this.rating,
    @required this.availableSpaces,
    @required this.availableLots,
    @required this.address,
    @required this.imageOne,
    @required this.imageTwo
  });
}