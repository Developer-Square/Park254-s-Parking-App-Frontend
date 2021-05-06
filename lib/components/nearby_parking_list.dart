import 'dart:async';

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
import './load_location.dart';

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
  final double parkingPrice;
  final String parkingPlaceName;
  final num rating;
  final double distance;
  final int parkingSlots;
  bool activeCard;
  final NearbyParkingLot parkingData;
  final Completer<GoogleMapController> mapController;
  final Function showNearbyParking;
  final CustomInfoWindowController customInfoWindowController;
  final Function hideAllDetails;
  final bool large;
  final String selectedCard;
  final String title;
  final Function selectCard;
  final TextEditingController searchBarController;
  final Function hideMapButtons;

  NearByParkingList({
    @required this.imgPath,
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
  });
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
    // final latitude = widget.parkingData.locationCoords.latitude;
    // final longitude = widget.parkingData.locationCoords.longitude;
    // cameraAnimate(widget.mapController, latitude, longitude);
    // widget.showNearbyParking();
    // widget.customInfoWindowController.addInfoWindow(
    //     InfoWindowWidget(value: widget.parkingData),
    //     widget.parkingData.locationCoords);
    // widget.searchBarController.text = widget.parkingPlaceName;
    // widget.hideMapButtons('nearByParkingList');
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
                    child: Image(
                      height: 90.0,
                      width: 85.0,
                      fit: BoxFit.cover,
                      image: AssetImage(widget.imgPath),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: Colors.blue,
                      padding: EdgeInsets.all(4.0),
                      child: Text('Ksh ${widget.parkingPrice} / hr',
                          style: globals.buildTextStyle(12.0, true, 'white')),
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
                  widget.parkingPlaceName.length > 15.0
                      ? widget.parkingPlaceName.substring(0, 15)
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
                    SizedBox(width: 6.0),
                    Text('${widget.parkingSlots} spaces',
                        style: globals.buildTextStyle(
                            14.0, true, globals.textColor)),
                    SizedBox(width: 13.0),
                    Icon(
                      Icons.near_me,
                      size: 17.0,
                    ),
                    SizedBox(width: 6.0),
                    Text('${widget.distance.toInt()} m',
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
