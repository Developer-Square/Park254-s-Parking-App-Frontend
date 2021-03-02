import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import '../config/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _activeTab = 'home';
  List<Marker> allMarkers = [];
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    parkingPlaces.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.parkingPlaceName),
          draggable: false,
          infoWindow: InfoWindow(
              title: element.parkingPlaceName, snippet: element.toString()),
          position: element.locationCoords));
    });

    // Pass Initial values
    searchBarController.text = _searchText;

    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
  }

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
                ? globals.fontColor
                : Colors.grey.withOpacity(0.8),
          ),
          Text(
            text,
            style: globals.buildTextStyle(
                12.0,
                true,
                _activeTab == icon
                    ? globals.fontColor
                    : Colors.grey.withOpacity(0.8)),
          )
        ],
      ),
    );
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
              initialCameraPosition: CameraPosition(
                  target: LatLng(-1.286389, 36.817223), zoom: 14.0),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
          NearByParking(),
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
            height: 220.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: globals.backgroundColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(500, 240))),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Container(
                        width: 190.0,
                        child: Text('Where do you want to park?',
                            style: TextStyle(
                              color: globals.fontColor,
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
                    )
                  ]),
            ),
          )
        ],
      ),
    ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
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
}
