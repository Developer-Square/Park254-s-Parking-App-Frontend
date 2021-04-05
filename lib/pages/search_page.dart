import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/booking_tab.dart';
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
  int ratingCount;
  var clickedStars;
  var uuid = new Uuid();
  String _sessionToken = new Uuid().toString();
  List<dynamic> _placeList = [];
  bool showSuggestion;

  @override
  void initState() {
    super.initState();

    ratingCount = 0;
    clickedStars = [];
    showRecentSearches = true;
    showBookNowTab = false;
    showRatingTab = false;
    showSuggestion = true;
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

      // If a user has clicked on one of the suggestions.
      // No more suggestions should be shown.
      showSuggestion
          ?
          // Gets the suggestions by making an api call to the Places Api.
          getSuggestion(searchBarController.text)
          // ignore: unnecessary_statements
          : () {};
    });
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = 'AIzaSyCRv0qsKcr8DwaWi8rEA8vVnIYO1hkokx0';
    String country = 'country:ke';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&components=$country&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(request);
    if (response.statusCode == 200) {
      setState(() {
        // If successfull store all the suggestions in a list to display below the search bar.
        _placeList = json.decode(response.body)['predictions'];
        // Hide the recent searches when the user starts typing on the search bar input.
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

  void showSuggestionFn() {
    setState(() {
      showSuggestion = true;
    });
  }

  // Clears the suggestions when a user clicks on one of them.
  void clearPlaceList(address) {
    setState(() {
      showSuggestion = false;
      _placeList.clear();
      searchBarController.text = address;
    });
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
                            showSuggestion: showSuggestion,
                            showSuggestionFn: showSuggestionFn,
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
                ? BookingTab(
                    searchBarControllerText: searchBarController.text,
                  )
                : Container(),
          ])),
    );
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

    // First check if the value is there before cutting it.
    if (values[0] != null) {
      // Cut the words in the suggestion so that they don't overflow.
      // on the page.
      if (values[0].length > 19) {
        values[0] = values[0].substring(0, 19) + '...';
      }
    }

    if (values[1] != null) {
      if (values[1].length > 19) {
        values[1] = values[1].substring(0, 19) + '...';
      }
    }

    // Re-using Recent searches widget to display user's suggestions
    return RecentSearches(
        specificLocation: values[0],
        town: values[1] == null ? 'None' : values[1],
        setShowRecentSearches: () {},
        controller: _controller,
        newSearch: true,
        clearPlaceListFn: clearPlaceList,
        context: context);
  }
}
