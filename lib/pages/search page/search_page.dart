import 'dart:async';
import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/booking_tab.dart';
import 'package:park254_s_parking_app/components/google_map.dart';
import 'package:park254_s_parking_app/components/info_window.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/rating_tab.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:park254_s_parking_app/functions/directions/getDirections.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/pages/search%20page/widgets/helper_functions.dart';
import 'package:park254_s_parking_app/pages/search%20page/widgets/navigation_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../config/globals.dart' as globals;
import 'package:park254_s_parking_app/components/loader.dart';
import 'dart:developer';
import 'helper_widgets.dart';

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

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GoogleMapController mapController;
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
  String sharedPreferenceKey = 'recentSearchesList';
  bool showSuggestion;
  BitmapDescriptor customIcon;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool addedSearch;
  bool isLoading = true;
  // User's details from the store.
  UserWithTokenModel storeDetails;
  // Navigation details from the store.
  NavigationProvider navigationDetails;
  // Parking details from the store.
  NearbyParkingListModel nearbyParkingDetails;
  double latitude;
  double longitude;
  Timer _timer;

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
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      navigationDetails =
          Provider.of<NavigationProvider>(context, listen: false);
      nearbyParkingDetails =
          Provider.of<NearbyParkingListModel>(context, listen: false);
      if (navigationDetails != null) {
        if (navigationDetails.isNavigating &&
            navigationDetails.currentPosition != null) {
          setState(() {
            latitude = navigationDetails.currentPosition.latitude;
            longitude = navigationDetails.currentPosition.longitude;
          });
        }

        if (nearbyParkingDetails != null) {
          nearbyParkingDetails.setCurrentPage('search');
        }
      }

      getSavedRecentSearches(
        recentSearchesKey: sharedPreferenceKey,
        recentSearchesList: setRecentSearches,
        clearRecentSearchList: clearRecentSearchList,
      );
    }
  }

  // Set the stored searches to be displayed.
  void setRecentSearches({List storedSearches}) {
    setState(() {
      _recentSearchesList = storedSearches;
    });
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
    setState(() {
      isLoading = false;
    });
    mapController = controller;
    // Navigate user to their current location after parking payment was successful.
    cameraAnimate(
        controller: mapController,
        latitude: latitude,
        longitude: longitude,
        zoom: 14.0);
    addRouteToMap(
      nearbyParkingDetails: nearbyParkingDetails,
      navigationDetails: navigationDetails,
    );
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
        getSuggestion(
            input: searchBarController.text,
            sessionToken: _sessionToken,
            setSearchResults: setSearchResults,
          )
        // ignore: unnecessary_statements
        : () {};
  }

  void setSearchResults(response) {
    setState(() {
      // If successfull store all the suggestions in a list to display below the search bar.
      _placeList = json.decode(response.body)['predictions'];
      // Hide the recent searches when the user starts typing on the search bar input.
      _placeList.length > 0 ? showRecentSearches = false : null;
    });
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
      _searchText = searchBarController.text;
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

  // Hide suggestions when the user has selected one.
  void hideSuggestions({String value, String town}) {
    setState(() {
      showSuggestion = false;
      showRecentSearches = false;
      searchBarController.text = '$value, $town';
    });
  }

  void addSearchFn() {
    setState(() {
      addedSearch = true;
    });
  }

  void clearRecentSearchList() {
    setState(() {
      _recentSearchesList = [];
    });
  }

  // _timer = new Timer(const Duration(milliseconds: 400), () {
  //     setState(() {
  //      var _logoStyle = FlutterLogoStyle.horizontal;
  //     });
  //   });

  Widget build(BuildContext context) {
    nearbyParkingDetails = Provider.of<NearbyParkingListModel>(context);
    return SafeArea(
      child: Scaffold(
          //Hide the appbar when showing the rating tab
          appBar: !showRatingTab ? buildAppBar(context: context) : null,
          body: Stack(children: <Widget>[
            GoogleMapWidget(
              currentPage: 'search',
              searchBarController: searchBarController,
              mapCreated: mapCreated,
              customInfoWindowController: _customInfoWindowController,
            ),
            // A pop-up that show the distance and time when a user is navigating.
            nearbyParkingDetails != null
                ? nearbyParkingDetails.directionsInfo != null
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: NavigationInfo(
                              totalDistance: nearbyParkingDetails
                                  .directionsInfo.totalDistance,
                              totalDuration: nearbyParkingDetails
                                  .directionsInfo.totalDuration),
                        ),
                      )
                    : Container()
                : Container(),
            // The rating pop up shown at the end of the parking session.
            // Show Loader to prevent the black/error screen that appears before.
            // the map is displayed.
            isLoading ? Loader() : Container(),
            showRatingTab
                ? RatingTab(
                    hideRatingTabFn: hideRatingTabFn,
                    parkingPlaceName: searchBarController.text)
                : Container(),
            // Hide the search bar when showing the ratings tab.
            !showRatingTab && !navigationDetails?.isNavigating
                ? SingleChildScrollView(
                    child: Container(
                      // Hides all the recent searches if one of them are clicked.
                      height: _placeList.length > 0
                          ? MediaQuery.of(context).size.height / 1.85
                          : _recentSearchesList.length > 0 && showRecentSearches
                              ? MediaQuery.of(context).size.height / 2
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
                              child: _placeList.length > 0
                                  ? showSuggestions(
                                      placeList: _placeList,
                                      storeDetails: storeDetails,
                                      context: context,
                                      clearPlaceList: clearPlaceList,
                                      addSearchToList: addSearchToList,
                                      mapController: mapController,
                                      recentSearchesList: _recentSearchesList,
                                      hideSuggestions: hideSuggestions,
                                      addedSearchFn: addSearchFn,
                                    )
                                  // Display suggestions available.
                                  : _recentSearchesList.length > 0 &&
                                          showSuggestion
                                      ? showRecentSearchesWidget(
                                          addSearchToList: addSearchToList,
                                          recentSearchesList:
                                              _recentSearchesList,
                                          setShowRecentSearches:
                                              _setShowRecentSearches,
                                          mapController: mapController,
                                          customInfoWindowController:
                                              _customInfoWindowController,
                                          storeDetails: storeDetails,
                                          hideSuggestions: hideSuggestions,
                                          addedSearchFn: addSearchFn,
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
            _placeList.length > 0
                // Hide the suggestions helper when the user is navigating
                ? !navigationDetails.isNavigating
                    ? buildScrollHelper(
                        showRecentSearches: showRecentSearches,
                        context: context)
                    : Container()
                : Container(),
            nearbyParkingDetails?.showBookNowTab &&
                    nearbyParkingDetails?.currentPage == 'search'
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
              offset: 32,
            ),
          ])),
    );
  }
}
