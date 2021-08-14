import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:overlay_support/overlay_support.dart';
import '../config/globals.dart' as globals;

/// Builds a notification widget that appears at the top of the page.
///
/// It can be used to show success or error messages.
buildNotification(textMsg, msgType) {
  return showSimpleNotification(Text(textMsg),
      background: msgType == 'error' ? Colors.red : globals.backgroundColor,
      autoDismiss: false, trailing: Builder(builder: (context) {
    return FlatButton(
        onPressed: () {
          OverlaySupportEntry.of(context).dismiss();
        },
        child: Text('Dismiss'));
  }));
}

BitmapDescriptor bitmapDescriptor;

// Gets the svg image, converts it to a png image then returns it.
// as BitmapDescriptor to be displayed as an icon on the map.
Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName) async {
  // Read SVG file as String
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width = 48 * devicePixelRatio; // where 32 is your SVG's original width
  double height = 48 * devicePixelRatio; // same thing

  // Convert to ui.Picture
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  ui.Image image = await picture.toImage(width.toInt(), height.toInt());
  ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}

/// Gives the user a smooth animation when moving to a new location.
///
/// Requires [mapController], the Google Controller from the parent component.
/// and [parkingData].
/// animates the Camera twice:
/// First to a place near the marker, then to the marker.
void cameraAnimate(_controller, latitude, longitude) async {
  final GoogleMapController mapController = await _controller.future;
  await mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(latitude - 0.0001, latitude), zoom: 14.0)));

  await mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      // The subtraction is done to ensure the booking tab does not block the marker.
      target: LatLng(latitude - 0.0015, longitude),
      zoom: 14.0)));
}

/// Takes a user to their current location.
///
/// Requires [_controller], the Google Controller from the parent component.
/// [currentPosition] and [load].
void loadLocation(_controller, closeNearByParking) async {
  closeNearByParking();
  final c = await _controller.future;
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
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
  try {
    // Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
    List<dynamic> locations = await locationFromAddress(address);

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    cameraAnimate(_controller, locations[0].latitude, locations[0].longitude);
    _clearPlaceList(address);
    print('here');
  } catch (e) {
    print(e);
  }
}
