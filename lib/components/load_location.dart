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
