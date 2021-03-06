import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/load_location.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import '../config/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// Creates a home page with google maps and parking location markers.
///
/// Includes the following widgets from other components:
/// [NearByParking], [parkingPlaces] which contains all the parking places available.
/// [SearchBar].
/// When a user clicks on one of the search bar he/she is directed to the search page.
/// Has navigation at the bottom.
class _HomePageState extends State<HomePage> {
  var _activeTab = 'home';
  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;
  bool showNearByParking;

  @override
  void initState() {
    super.initState();

    // Pass Initial values
    searchBarController.text = _searchText;
    showNearByParking = true;

    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
  }

  /// A function that receives the GoogleMapController when the map is rendered on the page.
  /// and adds google markers dynamically.
  void mapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      parkingPlaces.forEach((element) {
        allMarkers.add(Marker(
            markerId: MarkerId(element.parkingPlaceName),
            draggable: false,
            infoWindow: InfoWindow(
                title: element.parkingPlaceName, snippet: element.toString()),
            position: element.locationCoords));
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchBarController.dispose();
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

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          Container(
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
            ),
          ),
          // Show the NearByParking section or show an empty container.
          showNearByParking
              ? NearByParking(showNearByParkingFn: closeNearByParking)
              : Container(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildNavigatorIcons('home', 'Home'),
                      _buildNavigatorIcons('parking', 'My Parking'),
                      _buildNavigatorIcons('profile', 'Profile')
                    ],
                  ))),
          Container(
            height: 210.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: globals.backgroundColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(500, 240))),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Container(
                        width: 190.0,
                        child: Text('Where do you want to park?',
                            style: TextStyle(
                              color: globals.textColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            )),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    SearchBar(
                      offsetY: 4.0,
                      blurRadius: 6.0,
                      opacity: 0.9,
                      controller: searchBarController,
                      searchBarTapped: false,
                    )
                  ]),
            ),
          ),
          Positioned(
            bottom: showNearByParking ? 350.0 : 100.0,
            right: 0,
            child: Column(
              children: <Widget>[
                FloatingActionButton.extended(
                  onPressed: () {
                    loadLocation(
                        _controller, currentPosition, closeNearByParking);
                  },
                  icon: Icon(Icons.location_searching),
                  label: Text(showNearByParking ? '' : 'Current location'),
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
                        label: Text(
                            showNearByParking ? '' : 'Show nearyby parking'),
                      )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  /// Creates the navigation buttons at the bottom of the page.
  Widget _buildNavigatorIcons(String icon, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          _activeTab = icon;
        });
      },
      child: Column(
        children: [
          Icon(
            icon == 'home'
                ? Icons.home_filled
                : icon == 'parking'
                    ? Icons.local_parking
                    : Icons.person_outline,
            color: _activeTab == icon
                ? globals.textColor
                : Colors.grey.withOpacity(0.8),
          ),
          Text(
            text,
            style: globals.buildTextStyle(
                12.0,
                true,
                _activeTab == icon
                    ? globals.textColor
                    : Colors.grey.withOpacity(0.8)),
          )
        ],
      ),
    );
  }
}
