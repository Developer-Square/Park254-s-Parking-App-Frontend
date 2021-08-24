import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/directions.model.dart';
import '../../../config/globals.dart' as globals;

/// Creates the pop-up widget.
///
/// Requires [totalDistance], [totalDuration].
/// E.g.
/// ```dart
/// NavigationInfo(
/// totalDistance: nearbyParkingDetails.directionsInfo.totalDistance,
/// totalDuration: nearbyParkingDetails.directionsInfo.totalDuration,
/// )
///```
class NavigationInfo extends StatelessWidget {
  final String totalDistance;
  final String totalDuration;

  NavigationInfo({
    @required this.totalDistance,
    @required this.totalDuration,
  });

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Positioned(
        top: 20.0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 12.0,
          ),
          decoration: BoxDecoration(
            color: globals.primaryColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: Text(
            '$totalDistance, $totalDuration',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
