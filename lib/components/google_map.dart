import 'dart:async';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
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
  final Function mapCreated;
  final Function showBookNowTab;
  final CustomInfoWindowController customInfoWindowController;
  final TextEditingController searchBarController;
  final Function showToolTipFn;
  final Function hideToolTip;
  GoogleMapController mapController;

  GoogleMapWidget(
      {@required this.mapCreated,
      @required this.customInfoWindowController,
      this.mapController,
      this.searchBarController,
      this.showBookNowTab,
      this.showToolTipFn,
      this.hideToolTip});
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

  @override
  initState() {
    super.initState();
    maxRetries = 0;
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      navigationDetails =
          Provider.of<NavigationProvider>(context, listen: false);
      addRouteToMap();
      getCurrentLocation();
      loadDescriptors();
      getAllParkingLocations();
    }
    setMarkers = false;
  }

  // Add the map marker to show the user their current location.
  // then draw the route.
  void addRouteToMap() {
    if (navigationDetails != null) {
      if (navigationDetails.isNavigating &&
          navigationDetails.currentPosition != null) {
        // Add the get distance and time function.
        double latitude = navigationDetails.currentPosition.latitude;
        double longitude = navigationDetails.currentPosition.longitude;
        // Add current location details to the map markers
        setState(() {
          allMarkers.add(Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: 'Current Location')));
        });
      }
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
                markerId: MarkerId(value.name),
                position: LatLng(value.location.coordinates[1],
                    value.location.coordinates[0]),
                icon: bitmapDescriptor,
                onTap: () {
                  widget.showBookNowTab('googleMapMarker', null);
                  widget.searchBarController.text = value.name;
                  widget.customInfoWindowController.addInfoWindow(
                      InfoWindowWidget(value: value),
                      LatLng(value.location.coordinates[1],
                          value.location.coordinates[0]));
                }),
          );
        });
      }).catchError((err) {
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
