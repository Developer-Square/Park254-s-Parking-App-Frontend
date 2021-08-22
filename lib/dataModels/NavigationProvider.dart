import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NavigationProvider with ChangeNotifier {
  bool _isNavigating = false;
  Position _currentPosition;

  bool get isNavigating => _isNavigating;
  Position get currentPosition => _currentPosition;

  void setNavigation() {
    _isNavigating = true;
    notifyListeners();
  }

  void setCurrentLocation(Position value) {
    _currentPosition = value;
  }

  void clear() {
    _isNavigating = false;
    notifyListeners();
  }
}
