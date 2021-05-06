import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';

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

  GoogleMapWidget(
      {@required this.mapCreated,
      @required this.customInfoWindowController,
      this.searchBarController,
      this.showBookNowTab});
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  BitmapDescriptor bitmapDescriptor;
  Position currentPosition;
  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];

  initState() {
    super.initState();
    getCurrentLocation();
    loadDescriptors(context);
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  // Load the svg icon.
  loadDescriptors(context) async {
    bitmapDescriptor = await bitmapDescriptorFromSvgAsset(
        context, 'assets/images/pin_icons/car-parking-icon-2.svg');
  }

  Widget build(BuildContext context) {
    // Display all the available markers on the map.
    parkingPlaces.forEach((value) {
      allMarkers.add(
        Marker(
            markerId: MarkerId(value.parkingPlaceName),
            position: value.locationCoords,
            icon: bitmapDescriptor,
            onTap: () {
              widget.showBookNowTab('googleMapMarker');
              widget.searchBarController.text = value.parkingPlaceName;
              widget.customInfoWindowController.addInfoWindow(
                  InfoWindowWidget(value: value), value.locationCoords);
            }),
      );
    });
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
            // Because getting a user's position is an async operation we've to give.
            // the map some results before the user's position is found.
            target: currentPosition != null
                ? LatLng(currentPosition.latitude, currentPosition.longitude)
                : LatLng(-1.2834, 36.8235),
            zoom: 14.0),
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
