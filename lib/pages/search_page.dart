import 'dart:async';
import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/booking_tab.dart';
import 'package:park254_s_parking_app/components/google_map.dart';
import 'package:park254_s_parking_app/components/info_window.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/rating_tab.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../config/globals.dart' as globals;

/// Creates a search page with recent searches of the user.
///
/// Includes the following widgets from other components:
/// [NearByParkingList()], [parkingPlaces] which contains all the parking places available.
/// [SearchBar] and [RecentSearches].
/// When a user clicks on one of the recent searches or selects their ideal parking location.
/// the recent searches disappear and a bottom widget appears and the search bar is updated.
/// with the chosen parking place name.
class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  final FlutterSecureStorage loginDetails;
  SearchPage({this.loginDetails});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Completer<GoogleMapController> mapController = Completer();

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
  List<dynamic> _recentSearchesList = [];
  String recentSearchesKey = 'recentSearchesKey';
  bool showSuggestion;
  BitmapDescriptor customIcon;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool addedSearch;

  @override
  void initState() {
    super.initState();

    // Pass Initial values.
    ratingCount = 0;
    clickedStars = [];
    showRecentSearches = true;
    showBookNowTab = false;
    showRatingTab = false;
    showSuggestion = true;
    searchBarController.text = _searchText;
    addedSearch = false;

    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
  }

// Hides the recent searches when one of them is clicked and.
// sets the searchbar text to the clicked recent search.
// Displays booknow tab and dismisses the keyboard.
// It also redirects the user to the chosen location.
  void _setShowRecentSearches(searchText, town, controller, clearPlaceListFn,
      context, customInfoWindowController, parkingData) {
    setState(() {
      showRecentSearches = false;
      showBookNowTab = true;
      showSuggestion = false;
      // First remove the suggestions then set the searchBarController to avoid.
      // the suggestions from showing up.
      searchBarController.text = searchText;
    });
    getLocation(searchText + ',' + town, controller, clearPlaceList, context);
    customInfoWindowController.addInfoWindow(
        InfoWindowWidget(value: parkingData), parkingData.locationCoords);
    FocusScope.of(context).unfocus();
  }

  /// A function that receives the GoogleMapController when the map is rendered on the page.
  /// and adds google markers dynamically.
  void mapCreated(GoogleMapController controller) {
    mapController.complete(controller);
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
      // First create the session token since it's required when sending the Api.
      if (_sessionToken == null) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }
    });
    // If a user has clicked on one of the suggestions.
    // No more suggestions should be shown.
    showSuggestion
        ?
        // Gets the suggestions by making an api call to the Places Api.
        getSuggestion(searchBarController.text)
        // ignore: unnecessary_statements
        : () {};
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

// When user clicks on a recent search and the booking tab shows up.
//  then he/she wants to change to another location, hide the booking tab.
  void showSuggestionFn() {
    setState(() {
      showSuggestion = true;
      showBookNowTab = false;
      _customInfoWindowController.hideInfoWindow();
    });
  }

  // Clears the suggestions when a user clicks on one of them.
  void clearPlaceList(address) {
    setState(() {
      showSuggestion = false;
    });
    _placeList.clear();
  }

  // Show the book now tab when a user clicks on a google map marker.
  showBookNowTabFn(widget) {
    if (widget != 'bookingTab') {
      showBookNowTab = true;
    }
  }

  addSearchToList(value, town) {
    // Add the destination that the user was searching for to the search bar.
    var location = [];
    location.add(value);
    location.add(town);
    setState(() {
      showSuggestion = false;
      showRecentSearches = false;
      searchBarController.text = '$value, $town';
    });

    // If the location is already in the list then don't add it.
    // ToDo: Add a better way of testing this.
    if (!_recentSearchesList.contains(value)) {
      // If the list has five items remove the first one since it's.
      // the oldest and add the latest one.
      if (_recentSearchesList.length == 5) {
        // Adding a setState here so as the changes on the recent searches.
        // can be seen.
        setState(() {
          addedSearch = true;
        });

        _recentSearchesList.removeAt(0);
        _recentSearchesList.add(location);
      } else {
        _recentSearchesList.add(location);
      }
    }
    saveRecentSearches();
  }

  // Save five of the user's recent searches in a list.
  saveRecentSearches() async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(recentSearchesKey, json.encode(_recentSearchesList));
    }).catchError((err) {
      print(err);
    });
  }

// Retrieve the saved recent searches to display them.
  getSavedRecentSearches() async {
    await SharedPreferences.getInstance().then((prefs) {
      _recentSearchesList = json.decode(prefs.getString(recentSearchesKey));
    });
  }

  Widget build(BuildContext context) {
    getSavedRecentSearches();
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
                        FocusScope.of(context).unfocus();
                      }),
                  title: Text('Search',
                      style: globals.buildTextStyle(
                          18.0, true, globals.textColor)),
                  centerTitle: true,
                )
              : null,
          body: Stack(children: <Widget>[
            GoogleMapWidget(
                showBookNowTab: showBookNowTabFn,
                searchBarController: searchBarController,
                mapCreated: mapCreated,
                customInfoWindowController: _customInfoWindowController),
            // The rating pop up shown at the end of the parking session.
            showRatingTab
                ? RatingTab(
                    hideRatingTabFn: hideRatingTabFn,
                    parkingPlaceName: searchBarController.text)
                : Container(),
            // Hide the search bar when showing the ratings tab
            !showRatingTab
                ? SingleChildScrollView(
                    child: Container(
                      // Hides all the recent searches if one of them are clicked.
                      height: showRecentSearches
                          ? MediaQuery.of(context).size.height / 2
                          : _placeList.length > 0
                              ? MediaQuery.of(context).size.height / 1.85
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
                                  ? SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 40.0),
                                          Text(
                                            'RECENT SEARCH',
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(height: 15.0),
                                          SizedBox(
                                              height: 170.0,
                                              child: ListView.builder(
                                                  itemCount: _recentSearchesList
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        RecentSearches(
                                                            controller:
                                                                mapController,
                                                            loginDetails: widget
                                                                .loginDetails,
                                                            recentSearchesListFn:
                                                                addSearchToList,
                                                            customInfoWindowController:
                                                                _customInfoWindowController,
                                                            // Reverve the list to get the most recent search first.
                                                            parkingData: _recentSearchesList[
                                                                _recentSearchesList
                                                                        .length -
                                                                    (index +
                                                                        1)][0],
                                                            specificLocation:
                                                                _recentSearchesList[_recentSearchesList.length - (index + 1)]
                                                                    [0],
                                                            town: _recentSearchesList[
                                                                _recentSearchesList
                                                                        .length -
                                                                    (index +
                                                                        1)][1],
                                                            setShowRecentSearches:
                                                                _setShowRecentSearches),
                                                        SizedBox(height: 20.0),
                                                      ],
                                                    );
                                                  }))
                                        ],
                                      ),
                                    )
                                  // Display suggestions available.
                                  : _placeList.length > 0
                                      ? SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0),
                                              SizedBox(
                                                height: 230.0,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _placeList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          ListTile(
                                                              title: Row(
                                                            children: [
                                                              // If the location has more than 25 letters, slice the word and add '...'
                                                              _buildSinglePlace(
                                                                  index),
                                                            ],
                                                          )),
                                                          SizedBox(
                                                            height: 7.0,
                                                          )
                                                        ],
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 20.0),
                                        ),
                            )
                          ]),
                    ),
                  )
                : Container(),
            // Helper: To inform the user that they can scroll down to see more.
            // suggestions.
            showRecentSearches || _placeList.length > 0
                ? Positioned(
                    top: showRecentSearches
                        ? MediaQuery.of(context).size.height / 9
                        : MediaQuery.of(context).size.height / 9,
                    right: MediaQuery.of(context).size.width / 4,
                    child: Column(
                      children: [
                        Text(
                          'Scroll down for more suggestions',
                          style:
                              globals.buildTextStyle(12.0, false, Colors.grey),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: globals.textColor),
                          height: 30,
                          width: 30,
                          child: Icon(
                            Icons.arrow_circle_down_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            showBookNowTab
                ? BookingTab(
                    homeScreen: false,
                    searchBarController: searchBarController,
                  )
                : Container(),
            // Add CustomInfoWindow as next child to float this on top GoogleMap.
            CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 50,
                width: 150,
                offset: 32),
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
        loginDetails: widget.loginDetails,
        recentSearchesListFn: addSearchToList,
        specificLocation: values[0],
        town: values[1] == null ? 'None' : values[1],
        setShowRecentSearches: () {},
        controller: mapController,
        newSearch: true,
        clearPlaceListFn: clearPlaceList,
        context: context);
  }
}
