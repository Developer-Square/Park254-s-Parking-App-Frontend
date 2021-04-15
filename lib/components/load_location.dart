import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Takes a user to their current location.
///
/// Requires [_controller], the Google Controller from the parent component.
/// [currentPosition] and [load].
void loadLocation(_controller, currentPosition, closeNearByParking) async {
  closeNearByParking();
  final c = await _controller.future;
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  currentPosition = position;
  LatLng latLngPosition = LatLng(position.latitude, position.longitude);
  CameraPosition cameraPosition =
      new CameraPosition(target: latLngPosition, zoom: 14.0);
  c.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
}

/// Gets the coordinates of the suggestion a user has selected from the suggestion.
/// list that appears below the search bar.
///
/// Requires [address], Map [controller] and [placeList]
void getLocation(address, _controller, _clearPlaceList, _context) async {
  final c = await _controller.future;

  try {
    // Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
    List<dynamic> locations = await locationFromAddress(address);

    _clearPlaceList(address);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    LatLng latLngPosition =
        LatLng(locations[0].latitude, locations[0].longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14.0);
    c.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  } catch (e) {
    print(e);
  }
}
