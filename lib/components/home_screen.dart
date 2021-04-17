import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/load_location.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/components/info_window.dart';
import 'bitmap_descriptor.dart';

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
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool showBackground;

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
  }

  /// A function that receives the GoogleMapController when the map is rendered on the page.
  /// and adds google markers dynamically.
  void mapCreated(GoogleMapController controller) {
    mapController = controller;
    _customInfoWindowController.googleMapController = controller;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchBarController.dispose();
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
  void showNearByParkingFn() {
    setState(() {
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

  loadDescriptors(context) async {
    bitmapDescriptor = await bitmapDescriptorFromSvgAsset(
        context, 'assets/images/pin_icons/car-parking-icon-1.svg');
  }

  @override
  Widget build(BuildContext context) {
    loadDescriptors(context);
    createMarker(context);
    // Display all the available markers from the
    parkingPlaces.forEach((value) {
      allMarkers.add(
        Marker(
            markerId: MarkerId(value.parkingPlaceName),
            position: value.locationCoords,
            icon: bitmapDescriptor,
            onTap: () {
              _customInfoWindowController.addInfoWindow(
                  InfoWindowWidget(value: value), value.locationCoords);
            }),
      );
    });
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.transparent,
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
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove();
                  },
                ),
              ),
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
                      showFullBackground: showFullBackground)
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
              // Add CustomInfoWindow as next child to float this on top GoogleMap.
              CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 50,
                  width: 150,
                  offset: 32),
            ])));
  }
}
