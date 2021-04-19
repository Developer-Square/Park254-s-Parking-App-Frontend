import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';

import 'info_window.dart';
import 'load_location.dart';

/// Creates the google map and map markers on the page.
///
/// Requires [allMarkers], [mapController] and [customInfoWindowController].
class GoogleMapWidget extends StatefulWidget {
  final Function mapCreated;
  final CustomInfoWindowController customInfoWindowController;

  GoogleMapWidget(
      {@required this.mapCreated, @required this.customInfoWindowController});
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  BitmapDescriptor bitmapDescriptor;
  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];

  // Load the svg icon.
  loadDescriptors(context) async {
    bitmapDescriptor = await bitmapDescriptorFromSvgAsset(
        context, 'assets/images/pin_icons/car-parking-icon-2.svg');
  }

  Widget build(BuildContext context) {
    loadDescriptors(context);
    // Display all the available markers on the map.
    parkingPlaces.forEach((value) {
      allMarkers.add(
        Marker(
            markerId: MarkerId(value.parkingPlaceName),
            position: value.locationCoords,
            icon: bitmapDescriptor,
            onTap: () {
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
        initialCameraPosition:
            CameraPosition(target: LatLng(-1.286389, 36.817223), zoom: 14.0),
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
