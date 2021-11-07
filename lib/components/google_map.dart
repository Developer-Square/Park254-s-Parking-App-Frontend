import 'dart:async';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/functions/utils/request_interceptor.dart';
import 'package:provider/provider.dart';

import 'info_window.dart';
import 'helper_functions.dart';

/// Creates the google map and map markers on the page.
///
/// Requires [allMarkers], [mapController] and [customInfoWindowController].
class GoogleMapWidget extends StatefulWidget {
  final String currentPage;
  final Function mapCreated;
  final CustomInfoWindowController customInfoWindowController;
  final TextEditingController searchBarController;
  GoogleMapController mapController;

  GoogleMapWidget({
    @required this.currentPage,
    @required this.mapCreated,
    @required this.customInfoWindowController,
    this.mapController,
    this.searchBarController,
  });
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  BitmapDescriptor bitmapDescriptor;
  Position currentPosition;
  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];
  var locations = [];
  int maxRetries;
  // User's details from the store.
  UserWithTokenModel storeDetails;
  bool setMarkers;
  // Navigation details from the store.
  NavigationProvider navigationDetails;
  NearbyParkingListModel nearbyParkingListDetails;

  @override
  initState() {
    super.initState();
    maxRetries = 0;
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      navigationDetails =
          Provider.of<NavigationProvider>(context, listen: false);
      nearbyParkingListDetails =
          Provider.of<NearbyParkingListModel>(context, listen: false);

      addCurrentLocationToMap();
      getCurrentLocation();
      loadDescriptors();
      getAllParkingLocations();
    }
    setMarkers = false;
  }

  // Add the map marker to show the user their current location.
  // then draw the route.
  void addCurrentLocationToMap() {
    if (navigationDetails != null) {
      if (navigationDetails.isNavigating &&
          navigationDetails.currentPosition != null) {
        LatLng origin = LatLng(navigationDetails.currentPosition.latitude,
            navigationDetails.currentPosition.longitude);

        // Add current location details to the map markers
        setState(() {
          allMarkers.add(Marker(
            markerId: MarkerId('Current Location'),
            position: LatLng(origin.latitude, origin.longitude),
            infoWindow: InfoWindow(title: 'Current Location'),
          ));
        });
      }
    }
  }

  void getSelectedParkingLot(id) {
    if (nearbyParkingListDetails.nearbyParking.lots != null) {
      // Map through the existing parking lots then set the user selected parking lot
      // to the store.
      nearbyParkingListDetails.nearbyParking.lots.forEach((lot) {
        if (lot.id == id) {
          nearbyParkingListDetails.setNearbyParkingLot(value: lot);
        }
      });
    }
  }

  // Make an api request to get all the parking locations and add markers.
  // to each of them.
  getAllParkingLocations() async {
    if (storeDetails != null) {
      var accessToken = storeDetails.user.accessToken.token;
      getParkingLots(token: accessToken).then((value) {
        // Add the parking lots to a local list so that we can use.
        // the forEach method.
        // Tip: forEach does not work directly on the results from the api.
        // and the map method gives some errors.
        locations = value.parkingLots;
        // Add the marker coordinates to be displayed on the map.
        locations.forEach((value) {
          // Updating the state so that the page can reload and the new set markers.
          // can be displayed.
          setState(() {
            setMarkers = true;
          });
          allMarkers.add(
            Marker(
                markerId: MarkerId(value.id.toString()),
                position: LatLng(value.location.coordinates[1],
                    value.location.coordinates[0]),
                icon: bitmapDescriptor,
                onTap: () {
                  if (nearbyParkingListDetails != null) {
                    String parkingLotId = value.id;
                    // Show the book now tab according to which page the user is currently on.
                    // Tip: Since we're using one google map for both the home page and search page,
                    // you wouldn't want to show the book now tab in both pages simultaneously.
                    nearbyParkingListDetails.setBookNowTab('googleMapMarker');
                    nearbyParkingListDetails.setCurrentPage(widget.currentPage);
                    getSelectedParkingLot(parkingLotId);
                  }
                  widget.searchBarController.text = value.name;
                  widget.customInfoWindowController.addInfoWindow(
                      InfoWindowWidget(value: value),
                      LatLng(value.location.coordinates[1],
                          value.location.coordinates[0]));
                }),
          );
        });
      }).catchError((err) {
        log('In google_map.dart');
        log(err.toString());
      });
    }
  }

  // Get a user's current location to redirect the map to that location.
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the funtion will return an error.
  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null && widget.mapController != null) {
      cameraAnimate(
          controller: widget.mapController,
          latitude: position.latitude,
          longitude: position.longitude);
    }
  }

  // Load the svg icon.
  loadDescriptors() async {
    bitmapDescriptor = await bitmapDescriptorFromSvgAsset(
        context, 'assets/images/pin_icons/parking-icon-3.svg');
  }

  Widget build(BuildContext context) {
    nearbyParkingListDetails = Provider.of<NearbyParkingListModel>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition:
            CameraPosition(target: LatLng(-1.2834, 36.8235), zoom: 14.0),
        markers: Set.from(allMarkers),
        onMapCreated: widget.mapCreated,
        polylines: {
          nearbyParkingListDetails.directionsInfo != null
              // This is so that the polylines meant to show directions don't show up.
              // on the homepage.
              ? widget.currentPage != 'home'
                  ? Polyline(
                      polylineId: PolylineId('overview_polyline'),
                      color: Colors.blue,
                      width: 5,
                      points: nearbyParkingListDetails
                          .directionsInfo.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    )
                  : Polyline(polylineId: PolylineId('none'))
              : Polyline(polylineId: PolylineId('none'))
        },
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height - 520.0),
        onTap: (position) {
          widget.customInfoWindowController.hideInfoWindow();
        },
        onCameraMove: (position) {
          widget.customInfoWindowController.onCameraMove();
        },
      ),
    );
  }
}
