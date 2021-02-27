import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import '../config/globals.dart' as globals;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _activeTab = 'home';
  List<Marker> allMarkers = [];

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
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.9,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 3.0), //(x,y)
                      blurRadius: 7.0,
                    )
                  ],
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(bottom: 70.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nearest Parking',
                              style: globals.buildTextStyle(
                                  16.0, true, globals.fontColor)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 19.0,
                          )
                        ],
                      ),
                      SizedBox(height: 15.0),
                      SizedBox(
                          height: 205.0,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              NearByParking(
                                  imgPath:
                                      'assets/images/parking_photos/parking_4.jpg',
                                  parkingPrice: 200,
                                  parkingPlaceName: 'Parking on Wabera St',
                                  rating: 3.5,
                                  distance: 125,
                                  parkingSlots: 5),
                              SizedBox(height: 30.0),
                              NearByParking(
                                  imgPath:
                                      'assets/images/parking_photos/parking_7.jpg',
                                  parkingPrice: 130,
                                  parkingPlaceName: 'First Church of Christ',
                                  rating: 4.1,
                                  distance: 234,
                                  parkingSlots: 2),
                              SizedBox(height: 30.0),
                              NearByParking(
                                  imgPath:
                                      'assets/images/parking_photos/parking_1.jpg',
                                  parkingPrice: 450,
                                  parkingPlaceName: 'Parklands Ave, Nairobi',
                                  rating: 3.9,
                                  distance: 234,
                                  parkingSlots: 7),
                              SizedBox(height: 30.0),
                              NearByParking(
                                  imgPath:
                                      'assets/images/parking_photos/parking_9.jpg',
                                  parkingPrice: 400,
                                  parkingPlaceName: 'Parklands Ave, Nairobi',
                                  rating: 3.9,
                                  distance: 234,
                                  parkingSlots: 7),
                              SizedBox(height: 30.0),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
        ],
      ),
    ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
