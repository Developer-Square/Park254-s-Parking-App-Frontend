import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park254_s_parking_app/components/Booking.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/rating_tab.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../config/globals.dart' as globals;

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';
  @override
  _SearchPageState createState() => _SearchPageState();
}

/// Creates a search page with recent searches of the user.
///
/// Includes the following widgets from other components:
/// [NearByParkingList()], [parkingPlaces] which contains all the parking places available.
/// [SearchBar] and [RecentSearches].
/// When a user clicks on one of the recent searches or selects their ideal parking location.
/// the recent searches disappear and a bottom widget appears and the search bar is updated.
/// with the chosen parking place name.
class _SearchPageState extends State<SearchPage> {
  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];
  Completer<GoogleMapController> _controller = Completer();
  bool showRecentSearches;
  bool showBookNowTab;
  bool showRatingTab;
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();
  Position currentPosition;
  int ratingCount;
  var clickedStars;
  var uuid = new Uuid();
  String _sessionToken = new Uuid().toString();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();

    ratingCount = 0;
    clickedStars = [];
    showRecentSearches = true;
    showBookNowTab = false;
    showRatingTab = false;
    // Pass Initial values.
    searchBarController.text = _searchText;

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

// Hides the recent searches when one of them is clicked and.
// sets the searchbar text to the clicked recent search.
  void _setShowRecentSearches(searchText) {
    setState(() {
      searchBarController.text = searchText;
      showRecentSearches = false;
      showBookNowTab = true;
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
      // First create the session token since it's required when sending the Api.
      if (_sessionToken == null) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }
      // Gets the suggestion by making an api call to the Places Api.
      getSuggestion(searchBarController.text);
    });
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = 'AIzaSyCRv0qsKcr8DwaWi8rEA8vVnIYO1hkokx0';
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(request);
    if (response.statusCode == 200) {
      setState(() {
        // If successfull store all the suggestions in a list to display below the search bar.
        _placeList = json.decode(response.body)['predictions'];
        // Hide the recent searches when the user starts typing on the search bar input.
        // ignore: unnecessary_statements
        _placeList.length > 0 ? showRecentSearches = false : null;
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  // Shows the rating tab and hides all other widgets.
  void showRatingTabFn() {
    setState(() {
      showRecentSearches = false;
      showBookNowTab = false;
      showRatingTab = true;
    });
  }

  // Hide the rating tab and go back to the homepage.
  void hideRatingTabFn() {
    setState(() {
      showRatingTab = false;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //Hide the appbar when showing the rating tab
          appBar: !showRatingTab
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_outlined),
                      color: globals.textColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  title: Text('Search',
                      style: globals.buildTextStyle(
                          18.0, true, globals.textColor)),
                  centerTitle: true,
                )
              : null,
          body: Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(-1.286389, 36.817223), zoom: 14.0),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height - 370),
              ),
            ),
            // The rating pop up shown at the end of the parking session.
            showRatingTab
                ? RatingTab(
                    hideRatingTabFn: hideRatingTabFn,
                    parkingPlaceName: searchBarController.text)
                : Container(),
            // Hide the search bar when showing the ratings tab
            !showRatingTab
                ? Container(
                    // Hides all the recent searches if one of them are clicked.
                    height: showRecentSearches
                        ? MediaQuery.of(context).size.height - 310.0
                        : _placeList.length > 0
                            ? 400.0
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
                            controller: searchBarController,
                            searchBarTapped: true,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 35.0, top: 25.0),
                            child: showRecentSearches
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          specificLocation:
                                              'Parking on Wabera St',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                      SizedBox(height: 20.0),
                                      RecentSearches(
                                          specificLocation:
                                              'First Church of Christ',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                      SizedBox(height: 20.0),
                                      RecentSearches(
                                          specificLocation:
                                              'Parklands Ave, Nairobi',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                      SizedBox(height: 20.0),
                                      RecentSearches(
                                          specificLocation:
                                              'Parklands Ave, Nairobi',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                    ],
                                  )
                                // Display suggestions available.
                                : _placeList.length > 0
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _placeList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              title: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/images/pin_icons/location-pin.svg',
                                                  width: 20.0,
                                                  color: Colors.grey
                                                      .withOpacity(0.8)),
                                              SizedBox(width: 10.0),
                                              // If the location has more than 25 letters, slice the word and add '...'
                                              _buildSinglePlace(index),
                                            ],
                                          ));
                                        })
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                      ),
                          )
                        ]),
                  )
                : Container(),
            showBookNowTab
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 180.0,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 6.0), //(x,y)
                              blurRadius: 8.0,
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            NearByParkingList(
                                activeCard: false,
                                imgPath:
                                    'assets/images/parking_photos/parking_9.jpg',
                                parkingPrice: 400,
                                parkingPlaceName: searchBarController.text,
                                rating: 4.2,
                                distance: 350,
                                parkingSlots: 6),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildButtons(
                                    'Book Now', globals.backgroundColor),
                                _buildButtons('More Info', Colors.white),
                              ],
                            )
                          ],
                        )),
                  )
                : Container(),
          ])),
    );
  }

  /// A widget that builds the buttons in the bottom widget that appears
  ///
  /// when a user clicks on recent searches or selects a their ideal parking place.
  /// from the suggestions.
  Widget _buildButtons(String text, Color _color) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Booking(
                  address:
                      '100 West 33rd Street, Nairobi Industrial Area, 00100, Kenya',
                  bookingNumber: 'haaga5441',
                  destination: 'Nairobi',
                  parkingLotNumber: 'pajh5114',
                  price: 11,
                  imagePath: 'assets/images/Park254_logo.png')));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: _color),
          height: 40.0,
          width: 140.0,
          child: Center(
              child: Text(text,
                  style:
                      globals.buildTextStyle(15.0, true, globals.textColor))),
        ));
  }

  /// A widget that builds and displays the suggestions from google.
  ///
  /// When a user clicks on one of the places they're directed to that specific area.
  /// on the map.
  Widget _buildSinglePlace(index) {
    var placeDescription = _placeList[index]['description'].toString();
    // Split the location string e.g. from Nairobi, Kenya to Nairobi as the specific location.
    // and Kenya as the general location.
    var split = placeDescription.split(',');
    Map<int, String> values = {};
    for (int i = 0; i < split.length; i++) {
      values[i] = split[i];
    }

    /// Re-using Recent searches widget to display user's suggestions
    // return RecentSearches(
    //     specificLocation: values[index],
    //     town: values[index + 1],
    //     setShowRecentSearches: () {});
    return Text(
      placeDescription.length > 25
          ? placeDescription.substring(0, 25) + '...'
          : placeDescription,
      style: globals.buildTextStyle(17.5, true, globals.textColor),
    );
  }
}
