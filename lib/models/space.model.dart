import 'package:flutter/material.dart';

class Space {
  final String id;
  final num occupiedSpaces;
  final num availableSpaces;
  final bool available;

  Space({
    @required this.id,
    @required this.occupiedSpaces,
    @required this.availableSpaces,
    @required this.available,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'],
      occupiedSpaces: json['occupiedSpaces'],
      availableSpaces: json['availableSpaces'],
      available: json['available'],
    );
  }
}
