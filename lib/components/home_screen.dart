import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/load_location.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';
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

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(children: [
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
              TopPageStyling(
                searchBarController: searchBarController,
                currentPage: 'home',
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
                            label: Text(showNearByParking
                                ? ''
                                : 'Show nearyby parking'),
                          )
                  ],
                ),
              ),
            ])));
  }
}
