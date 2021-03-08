import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/MoreInfo.dart';

class MoreInfoTest extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MoreInfo(
      destination: 'Manhattan Mall',
      city: 'New York',
      distance: 200,
      price: 10,
      rating: 4.6,
      availableSpaces: 240,
      availableLots: [
        {
          "lotNumber": "P1",
          "emptySpaces": 23,
          "capacity": 40
        },
        {
          "lotNumber": "P2",
          "emptySpaces": 25,
          "capacity": 40
        },
        {
          "lotNumber": "P3",
          "emptySpaces": 15,
          "capacity": 40
        },
        {
          "lotNumber": "P4",
          "emptySpaces": 28,
          "capacity": 40
        },
        {
          "lotNumber": "P5",
          "emptySpaces": 22,
          "capacity": 40
        },
      ],
      address: '100 West 33rd Street, New York, NY',
    );
  }
}