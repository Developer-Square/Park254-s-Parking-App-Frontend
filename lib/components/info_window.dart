import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './marker_info.dart';

class InfoWindowModel extends ChangeNotifier {
  bool _showInfowindow = false;
  bool _tempHidden = false;
  User _user;
  double _leftMargin;
  double _topMargin;

  void rebuildInfowindow() {
    notifyListeners();
  }

  void updateUser(User user) {
    _user = user;
  }

  void updateVisibility(bool visibility) {
    _showInfowindow = visibility;
  }

  void updateInfowindow(BuildContext context, GoogleMapController controller,
      LatLng location, double infoWindowWidth, double markerOffset) async {
    ScreenCoordinate screenCoordinate =
        await controller.getScreenCoordinate(location);
    double devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (infoWindowWidth / 2);
    double top =
        (screenCoordinate.x.toDouble() / devicePixelRatio) - markerOffset;

    if (left < 0 || top < 0) {
      _tempHidden = true;
    } else {
      _tempHidden = false;
      _leftMargin = left;
      _topMargin = top;
    }
  }

  bool get showInfoWindow =>
      (_showInfowindow == true && _tempHidden == false) ? true : false;

  double get leftMargin => _leftMargin;

  double get topMargin => _topMargin;

  User get user => user;
}
