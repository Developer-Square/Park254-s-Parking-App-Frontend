import 'package:flutter/material.dart';
import 'dart:core';

import 'package:park254_s_parking_app/models/space.model.dart';

class SpaceList {
  final List<Space> spaceList;

  SpaceList({
    @required this.spaceList,
  });

  factory SpaceList.fromJson(Map<String, dynamic> json) {
    return SpaceList(
      spaceList: (json['results'] as List)
          .map((space) => Space.fromJson(space))
          .toList(),
    );
  }
}
