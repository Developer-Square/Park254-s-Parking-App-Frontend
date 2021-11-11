import 'package:geolocator/geolocator.dart';

/// are denied the function will request for permission.
Future checkPermissions() async {
  bool serviceEnabled;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return Future.value('true');
  }

  return Future.value('true');
}
