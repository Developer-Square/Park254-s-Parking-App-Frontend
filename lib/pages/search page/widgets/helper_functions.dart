import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/functions/directions/getDirections.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../.env.dart';

// Draws a route from the user's current location to the destination.
void addRouteToMap({
  @required NearbyParkingListModel nearbyParkingDetails,
  @required NavigationProvider navigationDetails,
}) async {
  if (navigationDetails != null && nearbyParkingDetails != null) {
    if (navigationDetails.isNavigating &&
        navigationDetails.currentPosition != null) {
      LatLng origin = LatLng(navigationDetails.currentPosition.latitude,
          navigationDetails.currentPosition.longitude);
      // Coordinates for the destination, details from the store.
      LatLng destination = LatLng(
          nearbyParkingDetails.nearbyParkingLot.location.coordinates[1],
          nearbyParkingDetails.nearbyParkingLot.location.coordinates[0]);
      try {
        // Get Directions.
        final directions = await DirectionsRepository()
            .getDirections(origin: origin, destination: destination);
        // Set the details in the store.
        nearbyParkingDetails.setDirections(value: directions);
      } catch (e) {
        buildNotification(e.toString(), 'error');
      }
    }
  }
}

// Gets the user's location suggestions as they type.
void getSuggestion({
  String input,
  String sessionToken,
  Function setSearchResults,
}) async {
  String country = 'country:ke';
  String baseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  String request =
      '$baseURL?input=$input&components=$country&key=$kGOOGLE_API_KEY&sessiontoken=$sessionToken';

  var response = await http.get(request);
  if (response.statusCode == 200) {
    setSearchResults(response);
  } else {
    throw Exception('Failed to load predictions');
  }
}

void addSearchToList({
  String value,
  String town,
  Function hideSuggestions,
  List recentSearchesList,
  Function addedSearchFn,
}) {
  // Add the destination that the user was searching for, to the search bar.
  var location = [];
  location.add(value);
  location.add(town);
  hideSuggestions(value: value, town: town);
  // If the location is already in the list then don't add it.
  // ToDo: Add a better way of testing this.
  if (!recentSearchesList.contains(value)) {
    // If the list has five items remove the first one since it's.
    // the oldest and add the latest one.
    if (recentSearchesList.length == 5) {
      // Adding a setState here so as the changes on the recent searches.
      // can be seen.
      addedSearchFn();

      recentSearchesList.removeAt(0);
      recentSearchesList.add(location);
    } else {
      recentSearchesList.add(location);
    }
  }
  saveRecentSearches();
}

// Save five of the user's recent searches in a list.
void saveRecentSearches({
  String recentSearchesKey,
  List recentSearchesList,
}) async {
  SharedPreferences.getInstance().then((prefs) {
    prefs.setString(recentSearchesKey, json.encode(recentSearchesList));
  }).catchError((err) {
    log(err.toString());
  });
}

// Retrieve the saved recent searches to display them.
void getSavedRecentSearches({
  List recentSearchesList,
  String recentSearchesKey,
  Function clearRecentSearchList,
}) async {
  await SharedPreferences.getInstance().then((prefs) {
    recentSearchesList = json.decode(prefs.getString(recentSearchesKey));

    if (recentSearchesList == null) {
      clearRecentSearchList();
    }
  });
}
