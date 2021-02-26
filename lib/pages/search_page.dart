import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
                  target: LatLng(-1.286389, 36.817223), zoom: 12.0),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: movetoBoston,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green),
                child: Icon(Icons.forward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(42.3601, -71.0589),
          zoom: 14.0,
          bearing: 45.0,
          tilt: 45.0),
    ));
  }
}
