import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Gives the user a smooth animation when moving to a new location.
///
/// Requires [mapController], the Google Controller from the parent component.
/// and [parkingData].
/// animates the Camera twice:
/// First to a place near the marker, then to the marker.
/// This is done to ensure that onCameraMove is always called
void cameraAnimate(mapController, parkingData) async {
  await mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(parkingData.locationCoords.latitude - 0.0001,
              parkingData.locationCoords.latitude),
          zoom: 14.0)));

  await mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(parkingData.locationCoords.latitude,
              parkingData.locationCoords.longitude),
          zoom: 14.0)));
}

/// Takes a user to their current location.
///
/// Requires [_controller], the Google Controller from the parent component.
/// [currentPosition] and [load].
void loadLocation(_controller, currentPosition, closeNearByParking) async {
  closeNearByParking();
  final c = await _controller;
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
