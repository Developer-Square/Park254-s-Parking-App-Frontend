import 'dart:async';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/info_window.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getNearbyParkingLots.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';
import '../config/globals.dart' as globals;
import 'helper_functions.dart';

/// Creates the single components present in nearby parking.
///
/// Requires [imgPath], [parkingPrice], [parkingPlaceName], [rating].
/// [distance] and [parkingSlots].
/// E.g.
/// ```dart
/// NearByParkingList(
/// imgPath: 'assets/images/parking_photos/parking_4.jpg',
/// parkingPrice: 200,
/// parkingPlaceName: 'Parking on Wabera St',
/// rating: 3.5,
/// distance: 125,
/// parkingSlots: 5,
/// coordinates: LatLng())
///```

class NearByParkingList extends StatefulWidget {
  final String imgPath;
  final num parkingPrice;
  final String parkingPlaceName;
  final num rating;
  final num distance;
  final int parkingSlots;
  bool activeCard;
  final NearbyParkingLot parkingData;
  final GoogleMapController mapController;
  final Function showNearbyParking;
  final CustomInfoWindowController customInfoWindowController;
  final Function hideAllDetails;
  final bool large;
  final String selectedCard;
  final String title;
  final Function selectCard;
  final TextEditingController searchBarController;
  final Function hideMapButtons;
  NearbyParkingLot selectedParkingLot;

  NearByParkingList(
      {@required this.imgPath,
      @required this.parkingPrice,
      @required this.parkingPlaceName,
      @required this.rating,
      @required this.distance,
      @required this.parkingSlots,
      @required this.activeCard,
      this.parkingData,
      this.mapController,
      this.showNearbyParking,
      this.customInfoWindowController,
      this.hideAllDetails,
      this.large,
      this.title,
      this.selectedCard,
      this.selectCard,
      this.searchBarController,
      this.hideMapButtons,
      this.selectedParkingLot});
  @override
  _NearByParkingList createState() => _NearByParkingList();
}

class _NearByParkingList extends State<NearByParkingList> {
  // Redirects the user to the specific parking location.
  // that he/she clicked on the Nearby parking widget or Recommended parking.
  // Opens up the infoWindow.
  void redirectToLocation() {
    // If the nearby parking widget is enlarged.
    // Then hide the background and parking widget.
    // when redirecting the user to the clicked location
    if (widget.large) {
      widget.hideAllDetails();
    }
    final latitude = widget.parkingData.location.coordinates[1];
    final longitude = widget.parkingData.location.coordinates[0];
    cameraAnimate(widget.mapController, latitude, longitude);
    widget.showNearbyParking();
    widget.customInfoWindowController.addInfoWindow(
        InfoWindowWidget(value: widget.parkingData),
        LatLng(widget.parkingData.location.coordinates[1],
            widget.parkingData.location.coordinates[0]));
    widget.searchBarController.text = widget.parkingPlaceName;
    widget.hideMapButtons('nearByParkingList', widget.parkingData);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // If its the selected card then redirect the user.
      // Else select the card.
      onTap: widget.title == widget.selectedCard
          ? () => redirectToLocation()
          : () => widget.selectCard(widget.title),
      child: Container(
          height: 80.0,
          child: Row(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 6.0), //(x,y)
                    blurRadius: 15.0,
                  )
                ],
              ),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: widget.imgPath.contains('https')
                        ? Image.network(
                            widget.imgPath,
                            height: 75.0,
                            width: 75.0,
                            fit: BoxFit.cover,
                          )
                        : Image(
                            height: 75.0,
                            width: 75.0,
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/parking_photos/parking_1.jpg'),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: Colors.blue,
                      padding: EdgeInsets.all(2.0),
                      child: Text('Ksh ${widget.parkingPrice} / hr',
                          style: globals.buildTextStyle(11.5, true, 'white')),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.parkingPlaceName.length > 20.0
                      ? widget.parkingPlaceName.substring(0, 20) + '...'
                      : widget.parkingPlaceName,
                  style: globals.buildTextStyle(
                      15.0,
                      true,
                      widget.activeCard
                          ? globals.textColor
                          : globals.textColor.withOpacity(0.7)),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text('${widget.rating}',
                        style: globals.buildTextStyle(
                            15.0,
                            true,
                            widget.rating > 3.0
                                ? globals.backgroundColor
                                : widget.rating == 0
                                    ? globals.textColor
                                    : Colors.red)),
                    SizedBox(width: 8.0),
                    Text('PARKING MALL',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey))
                  ],
                ),
                SizedBox(height: 14.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.car_rental),
                    SizedBox(width: 2.0),
                    Text('${widget.parkingSlots} spaces',
                        style: globals.buildTextStyle(
                            14.0, true, globals.textColor)),
                    SizedBox(width: 9.0),
                    Icon(
                      Icons.near_me,
                      size: 17.0,
                    ),
                    SizedBox(width: 3.0),
                    Text(
                        '${double.parse((widget.distance).toStringAsFixed(2))} m',
                        style: globals.buildTextStyle(
                            14.0, true, globals.textColor)),
                  ],
                )
              ],
            )
          ])),
    );
  }
}
