import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
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
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:provider/provider.dart';

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
  GoogleMapController mapController;
  bool showNearByParking;
  bool showTopPageStyling;
  bool showMap;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool showBackground;
  bool showBookingTab;
  bool showToolTip;
  String text;
  int index;
  bool isLoading = true;
  // Parking details from the store.
  NearbyParkingListModel nearbyParkingDetails;
  // Navigation details from the store.
  NavigationProvider navigationDetails;

  @override
  void initState() {
    super.initState();

    // Pass Initial values
    searchBarController.text = _searchText;
    showNearByParking = true;
    showMap = true;
    showBackground = false;
    showTopPageStyling = true;
    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
    showToolTip = false;
    index = 1;
    if (mounted) {
      navigationDetails =
          Provider.of<NavigationProvider>(context, listen: false);
      nearbyParkingDetails =
          Provider.of<NearbyParkingListModel>(context, listen: false);
    }

    if (nearbyParkingDetails != null) {
      nearbyParkingDetails.setCurrentPage('home');
    }
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

  @override
  Widget build(BuildContext context) {
    nearbyParkingDetails = Provider.of<NearbyParkingListModel>(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              GoogleMapWidget(
                currentPage: 'home',
                mapCreated: mapCreated,
                customInfoWindowController: _customInfoWindowController,
                searchBarController: searchBarController,
                mapController: mapController,
              ),
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
                    )
                  : Container(),
              // Show the booking tab when a user clicks on one of the parking locations.
              // on the parking widget.
              nearbyParkingDetails?.showBookNowTab &&
                      nearbyParkingDetails?.currentPage == 'home'
                  ? Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 20.0),
                      child: BookingTab(
                        homeScreen: true,
                        showNearbyParking: showNearByParkingFn,
                        searchBarController: searchBarController,
                      ),
                    )
                  : Container(),
              showTopPageStyling
                  ? TopPageStyling(
                      searchBarController: searchBarController,
                      currentPage: 'home',
                    )
                  : Container(),
              showMap && !nearbyParkingDetails?.showBookNowTab
                  ? Positioned(
                      bottom: showNearByParking ? 350.0 : 100.0,
                      right: 0,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () {
                              loadLocation(
                                  controller: mapController,
                                  closeNearByParking: closeNearByParking,
                                  navigationDetails: navigationDetails);
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
