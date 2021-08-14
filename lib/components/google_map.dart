import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/functions/utils/request_interceptor.dart';

import 'info_window.dart';
import 'load_location.dart';

/// Creates the google map and map markers on the page.
///
/// Requires [allMarkers], [mapController] and [customInfoWindowController].
class GoogleMapWidget extends StatefulWidget {
  final Function mapCreated;
  final Function showBookNowTab;
  final CustomInfoWindowController customInfoWindowController;
  final TextEditingController searchBarController;
  final FlutterSecureStorage tokens;
  final Function storeLoginDetails;
  final Function clearStorage;
  final Function showToolTipFn;
  final Function hideToolTip;
  GoogleMapController mapController;

  GoogleMapWidget(
      {@required this.mapCreated,
      @required this.customInfoWindowController,
      @required this.tokens,
      this.mapController,
      this.searchBarController,
      this.showBookNowTab,
      this.storeLoginDetails,
      this.clearStorage,
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
  bool setMarkers;

  @override
  initState() {
    super.initState();
    maxRetries = 0;
    setMarkers = false;

    if (mounted) {
      getCurrentLocation();
      loadDescriptors();
      getAllParkingLocations();
    }
  }

  // Make an api request to get all the parking locations and add markers.
  // to each of them.
  getAllParkingLocations() async {
    var accessToken = await widget.tokens.read(key: 'accessToken');
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
              position: LatLng(
                  value.location.coordinates[1], value.location.coordinates[0]),
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
      if (err.code == 401) {
        buildNotification(err.message, 'error');
      }
    });
  }

  // Get a user's current location to redirect the map to that location.
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the funtion will return an error.
  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // if (position != null) {
    //   cameraAnimate(
    //       widget.mapController, position.latitude, position.longitude);
    // }
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
        zoomControlsEnabled: true,
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
