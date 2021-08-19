import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/booking_tab.dart';
import 'package:park254_s_parking_app/components/google_map.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';
  final Function showBottomNavigation;

  HomeScreen({@required this.showBottomNavigation});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Creates a home page with google maps and parking location markers.
///
/// Includes the following widgets from other components:
/// [NearByParking], [parkingPlaces] which contains all the parking places available.
/// [SearchBar].
/// When a user clicks on one of the search bar he/she is directed to the search page.
/// Has navigation at the bottom.
class _HomeScreenState extends State<HomeScreen> {
  var _activeTab = 'home';
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();
  // Completer<GoogleMapController> mapController = Completer();
  GoogleMapController mapController;
  Position currentPosition;
  bool showNearByParking;
  bool showTopPageStyling;
  bool showMap;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool showBackground;
  bool hideMapButtons;
  bool showBookingTab;
  bool showToolTip;
  String text;
  int index;
  bool isLoading = true;
  NearbyParkingLot selectedParkingLot;
  GoogleMapController homeScreenController;

  @override
  void initState() {
    super.initState();

    // Pass Initial values
    searchBarController.text = _searchText;
    showNearByParking = true;
    showMap = true;
    showBackground = false;
    showTopPageStyling = true;
    hideMapButtons = false;
    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
    getCurrentLocation();
    showToolTip = false;
    index = 1;
  }

  /// A function that receives the GoogleMapController when the map is rendered on the page.
  /// and adds google markers dynamically.
  void mapCreated(GoogleMapController controller) {
    setState(() {
      isLoading = false;
    });
    mapController = controller;
    _customInfoWindowController.googleMapController = controller;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchBarController.dispose();
    mapController.dispose();
    _customInfoWindowController.dispose();
    mapController.complete();
    super.dispose();
  }

  void changeSearchText() {
    setState(() {
      _searchText = searchBarController.text;
    });
  }

  void closeNearByParking() {
    setState(() {
      showNearByParking = false;
      showBackground = false;
    });
  }

// Hides the info window when a user want to see the nearby parking locations.
// This is so that the info window does not overlap the nearby parking widget.
  void showNearByParkingFn([picIndex]) {
    setState(() {
      if (picIndex != null) {
        index = picIndex;
      }
      showNearByParking = !showNearByParking;
      _customInfoWindowController.hideInfoWindow();
    });
  }

  /// When a user clicks on the nearest parking widget.
  /// everything else should hide and the widget should expand and vice versa.
  void showFullParkingWidget() {
    setState(() {
      showTopPageStyling = !showTopPageStyling;
      showMap = !showMap;
      widget.showBottomNavigation();
    });
  }

  /// When a user clicks on the nearest parking widget.
  /// everything else should hide and a blue background.
  /// will cover the whole screen.
  showFullBackground() {
    showBackground = !showBackground;
  }

  // Hide the 'current location' and 'show nearby parking' buttons.
  // when the booking tab is shown.
  // This widget is also used to determine when to show the booking tab.
  // i.e. The booking tab will only show if the map buttons aren't being.
  // displayed.
  void hideMapButtonsFn(currentWidget, parkingData) {
    // If the function is being called by the booking tab close icon.
    // then add hide/show functionality else hide map buttons remains true
    if (currentWidget == 'bookingTab') {
      hideMapButtons = !hideMapButtons;
    } else {
      setState(() {
        // Set the selected parkingLot.
        selectedParkingLot = parkingData;
      });
      hideMapButtons = true;
    }
  }

  // Get a user's current location.
  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  hideToolTip() {
    setState(() {
      showToolTip = false;
    });
  }

  showToolTipFn(message) {
    setState(() {
      showToolTip = true;
      text = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              GoogleMapWidget(
                  showBookNowTab: hideMapButtonsFn,
                  mapCreated: mapCreated,
                  customInfoWindowController: _customInfoWindowController,
                  searchBarController: searchBarController,
                  mapController: mapController),
              // Show Loader to prevent the black/error screen that appears before.
              // the map is displayed.
              isLoading ? Loader() : Container(),
              // The blue background that appears when the nearby parking widget.
              // is enlarged.
              showBackground
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Color(0xFF16346c),
                    )
                  : Container(),
              // Show the NearByParking section or show an empty container.
              showNearByParking
                  ? NearByParking(
                      mapController: mapController,
                      customInfoWindowController: _customInfoWindowController,
                      showNearByParkingFn: closeNearByParking,
                      hideDetails: showFullParkingWidget,
                      showFullBackground: showFullBackground,
                      searchBarController: searchBarController,
                      hideMapButtons: hideMapButtonsFn,
                      currentPosition: currentPosition,
                      showToolTipFn: showToolTipFn,
                      selectedParkingLot: selectedParkingLot)
                  : Container(),
              // Show the booking tab when a user clicks on one of the parking locations.
              // on the parking widget.
              hideMapButtons
                  ? Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 20.0),
                      child: BookingTab(
                          index: index,
                          homeScreen: true,
                          showNearbyParking: showNearByParkingFn,
                          hideMapButtons: hideMapButtonsFn,
                          searchBarController: searchBarController,
                          selectedParkingLot: selectedParkingLot),
                    )
                  : Container(),
              showTopPageStyling
                  ? TopPageStyling(
                      searchBarController: searchBarController,
                      currentPage: 'home',
                    )
                  : Container(),
              showMap && !hideMapButtons
                  ? Positioned(
                      bottom: showNearByParking ? 350.0 : 100.0,
                      right: 0,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () {
                              loadLocation(mapController, closeNearByParking);
                            },
                            icon: Icon(Icons.location_searching),
                            label: Text(
                                showNearByParking ? '' : 'Current location'),
                          ),
                          SizedBox(height: 15.0),
                          showNearByParking
                              ? Container()
                              : FloatingActionButton.extended(
                                  heroTag: null,
                                  onPressed: () {
                                    showNearByParkingFn();
                                  },
                                  icon: Icon(Icons.car_rental),
                                  label: Text(showNearByParking
                                      ? ''
                                      : 'Show nearyby parking'),
                                )
                        ],
                      ),
                    )
                  : Container(),
              // Add CustomInfoWindow as next child to float this on top GoogleMap.
              CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 50,
                  width: 150,
                  offset: 32),
            ])));
  }
}
