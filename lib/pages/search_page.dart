import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import '../config/globals.dart' as globals;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Marker> allMarkers = [];
  GoogleMapController _controller;
  bool showRecentSearches;
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    waitForMarkers(id) async {
      await Future.delayed(Duration(seconds: 1));
      print('here');
      _controller.showMarkerInfoWindow(MarkerId(id));
    }

    parkingPlaces.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.parkingPlaceName),
          draggable: false,
          infoWindow: InfoWindow(
              title: element.parkingPlaceName, snippet: element.toString()),
          position: element.locationCoords));
      waitForMarkers(element.parkingPlaceName);
    });

    showRecentSearches = true;
    // Pass Initial values
    searchBarController.text = _searchText;

    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                color: globals.fontColor,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text('Search',
                style: globals.buildTextStyle(18.0, true, globals.fontColor)),
            centerTitle: true,
          ),
          body: Stack(children: <Widget>[
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
            Container(
              height: showRecentSearches
                  ? MediaQuery.of(context).size.height - 310.0
                  : 110.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    SearchBar(
                        offsetY: 4.0,
                        blurRadius: 6.0,
                        opacity: 0.5,
                        controller: searchBarController),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, top: 25.0),
                      child: showRecentSearches
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RECENT SEARCH',
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                SizedBox(height: 30.0),
                                RecentSearches(
                                    specificLocation: 'Parking on Wabera St',
                                    town: 'Nairobi',
                                    setShowRecentSearches:
                                        _setShowRecentSearches),
                                SizedBox(height: 20.0),
                                RecentSearches(
                                    specificLocation: 'First Church of Christ',
                                    town: 'Nairobi',
                                    setShowRecentSearches:
                                        _setShowRecentSearches),
                                SizedBox(height: 20.0),
                                RecentSearches(
                                    specificLocation: 'Parklands Ave, Nairobi',
                                    town: 'Nairobi',
                                    setShowRecentSearches:
                                        _setShowRecentSearches),
                                SizedBox(height: 20.0),
                                RecentSearches(
                                    specificLocation: 'Parklands Ave, Nairobi',
                                    town: 'Nairobi',
                                    setShowRecentSearches:
                                        _setShowRecentSearches),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                            ),
                    )
                  ]),
            )
          ])),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  void _setShowRecentSearches(searchText) {
    setState(() {
      searchBarController.text = _searchText;
      showRecentSearches = false;
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
