import 'dart:async';

import 'package:flutter/material.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageArguements {
  final FlutterSecureStorage loginDetails;

  HomePageArguements({
    @required this.loginDetails,
  });
}

class NearByParkingListArguments {
  final String imgPath;
  final double parkingPrice;
  final String parkingPlaceName;
  final double rating;
  final double distance;
  final int parkingSlots;

  NearByParkingListArguments(
      {@required this.imgPath,
      @required this.parkingPrice,
      @required this.parkingPlaceName,
      @required this.rating,
      @required this.distance,
      @required this.parkingSlots});
}

class NearByParkingArguements {
  static const routeName = '/search_page';
  final Function showNearByParkingFn;
  final Function hideDetails;
  final Completer<GoogleMapController> mapController;
  final CustomInfoWindowController customInfoWindowController;
  final Function showFullBackground;

  NearByParkingArguements(
      {@required this.showNearByParkingFn,
      @required this.hideDetails,
      @required this.mapController,
      @required this.customInfoWindowController,
      @required this.showFullBackground});
}

class TopPageStylingArguements {
  final searchBarController;
  final currentPage;
  final widget;

  TopPageStylingArguements(
      {this.searchBarController, @required this.currentPage, this.widget});
}

class GoogleMapWidgetArguements {
  final Function mapCreated;
  final CustomInfoWindowController customInfoWindowController;

  GoogleMapWidgetArguements(
      {@required this.mapCreated, @required this.customInfoWindowController});
}
