import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/load_location.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import '../config/globals.dart' as globals;
import 'info_widget_route.dart';

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

  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();
  GoogleMapController mapController;
  Position currentPosition;
  bool showNearByParking;
  bool showTopPageStyling;
  bool showMap;
  BitmapDescriptor customIcon;
  StreamSubscription _mapIdleSubscription;
  InfoWidgetRoute infoWidgetRoute;

  @override
  void initState() {
    super.initState();

    // Pass Initial values
    searchBarController.text = _searchText;
    showNearByParking = true;
    showMap = true;
    showTopPageStyling = true;

    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
  }

  /// A function that receives the GoogleMapController when the map is rendered on the page.
  /// and adds google markers dynamically.
  void mapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchBarController.dispose();
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
    });
  }

  void showNearByParkingFn() {
    setState(() {
      showNearByParking = !showNearByParking;
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

  // Fetching the custom icon and adding it to state.
  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration,
              'assets/images/pin_icons/destination_map_marker.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  // First it creates the Info Widget Route and then
  // animates the Camera twice:
  // First to a place near the marker, then to the marker.
  // This is done to ensure that onCameraMove is always called
  // ToDo: How to remove the custom info window on map move.
  _onTap(Parking parkingData, _context) async {
    final RenderBox renderBox = _context.findRenderObject();
    Rect _itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    infoWidgetRoute = InfoWidgetRoute(
        child: Text(
          parkingData.parkingPlaceName.substring(0, 1),
          style: globals.buildTextStyle(17.0, true, globals.textColor),
        ),
        searched: parkingData.searched,
        rating: parkingData.rating,
        price: parkingData.price,
        buildContext: _context,
        textStyle: const TextStyle(fontSize: 14.0, color: Colors.black),
        mapsWidgetSize: _itemRect);

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

  @override
  Widget build(BuildContext context) {
    // createMarker(context);
    // Display all the available markers from the
    parkingPlaces.forEach((value) {
      allMarkers.add(
        Marker(
            markerId: MarkerId(value.parkingPlaceName),
            position: value.locationCoords,
            onTap: () {
              _onTap(value, context);
            }),
      );
    });
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: showMap ? Colors.transparent : Color(0xFF16346c),
            body: Stack(children: [
              showMap
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(-1.286389, 36.817223), zoom: 14.0),
                        markers: Set.from(allMarkers),
                        onMapCreated: mapCreated,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height - 520.0),
                        // This fakes the onMapIdle, as the googleMaps on Map Idle does not always work
                        // (see: https://github.com/flutter/flutter/issues/37682)
                        // When the Map Idles and a _infoWidgetRoute exists, it gets displayed.
                        onCameraMove: (newPosition) {
                          _mapIdleSubscription?.cancel();
                          _mapIdleSubscription =
                              Future.delayed(Duration(milliseconds: 100))
                                  .asStream()
                                  .listen((_) {
                            if (infoWidgetRoute != null) {
                              Navigator.of(context, rootNavigator: true)
                                  .push(infoWidgetRoute)
                                  .then<void>(
                                      (newValue) => {infoWidgetRoute = null});
                            }
                          });
                        },
                      ),
                    )
                  : Container(),
              // Show the NearByParking section or show an empty container.
              showNearByParking
                  ? NearByParking(
                      showNearByParkingFn: closeNearByParking,
                      hideDetails: showFullParkingWidget,
                    )
                  : Container(),
              showTopPageStyling
                  ? TopPageStyling(
                      searchBarController: searchBarController,
                      currentPage: 'home',
                    )
                  : Container(),
              showMap
                  ? Positioned(
                      bottom: showNearByParking ? 350.0 : 100.0,
                      right: 0,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () {
                              loadLocation(mapController, currentPosition,
                                  closeNearByParking);
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
            ])));
  }

  Widget buildCustomInfoWindow() {
    return Container(
      width: 100.0,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: globals.backgroundColor),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: Colors.white),
          child: Center(
              child: Text('P',
                  style: globals.buildTextStyle(
                      17.0, true, globals.backgroundColor))),
        ),
        SizedBox(width: 15.0),
        Text(
          '\$10 / hr',
          style: globals.buildTextStyle(17.0, false, Colors.white),
        )
      ]),
    );
  }
}
