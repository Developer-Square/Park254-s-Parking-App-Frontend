import 'package:flutter/material.dart';

class Rating {
  final String id;
  final String userId;
  final String parkingLotId;
  final int value;

  Rating({
    @required this.id,
    @required this.userId,
    @required this.parkingLotId,
    @required this.value,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      userId: json['userId'],
      parkingLotId: json['parkingLotId'],
      value: json['value'],
    );
  }
}
