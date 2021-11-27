import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import '../../config/globals.dart' as globals;

Widget buildAppBar({BuildContext context}) {
  return AppBar(
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
        style: globals.buildTextStyle(18.0, true, globals.textColor)),
    centerTitle: true,
  );
}

/// Builds out the scroll helper that lets users know that they can scroll.
/// down to see more results.
Widget buildScrollHelper({
  @required bool showRecentSearches,
  @required BuildContext context,
}) {
  return Positioned(
    top: showRecentSearches
        ? MediaQuery.of(context).size.height / 9
        : MediaQuery.of(context).size.height / 9,
    right: MediaQuery.of(context).size.width / 4,
    child: Column(
      children: [
        Text(
          'Scroll down for more suggestions',
          style: globals.buildTextStyle(12.0, false, Colors.grey),
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
  );
}

/// A widget that builds and displays the suggestions from google.
///
/// When a user clicks on one of the places they're directed to that specific area.
/// on the map.
Widget buildSinglePlace({
  int index,
  List placeList,
  UserWithTokenModel storeDetails,
  Function addSearchToList,
  GoogleMapController mapController,
  Function clearPlaceList,
  BuildContext context,
  Function hideSuggestions,
  Function addedSearchFn,
  List recentSearchesList,
}) {
  var placeDescription = placeList[index]['description'].toString();
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
    storeDetails: storeDetails,
    recentSearchesListFn: addSearchToList,
    specificLocation: values[0],
    town: values[1] == null ? 'None' : values[1],
    setShowRecentSearches: () {},
    controller: mapController,
    newSearch: true,
    clearPlaceListFn: clearPlaceList,
    context: context,
    recentSearchesList: recentSearchesList,
    addedSearchFn: addedSearchFn,
    hideSuggestions: hideSuggestions,
  );
}

Widget showRecentSearchesWidget({
  @required List recentSearchesList,
  @required GoogleMapController mapController,
  @required UserWithTokenModel storeDetails,
  @required Function addSearchToList,
  @required CustomInfoWindowController customInfoWindowController,
  @required Function setShowRecentSearches,
  Function hideSuggestions,
  Function addedSearchFn,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.0),
        Text(
          'RECENT SEARCH',
          style: TextStyle(
              color: Colors.grey.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 15.0),
        ),
        SizedBox(height: 15.0),
        SizedBox(
            height: 170.0,
            child: ListView.builder(
                itemCount: recentSearchesList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      RecentSearches(
                        controller: mapController,
                        storeDetails: storeDetails,
                        recentSearchesListFn: addSearchToList,
                        customInfoWindowController: customInfoWindowController,
                        recentSearchesList: recentSearchesList,
                        addedSearchFn: addedSearchFn,
                        hideSuggestions: hideSuggestions,
                        // Reverve the list to get the most recent search first.
                        parkingData: recentSearchesList[
                            recentSearchesList.length - (index + 1)][0],
                        specificLocation: recentSearchesList[
                            recentSearchesList.length - (index + 1)][0],
                        town: recentSearchesList[
                            recentSearchesList.length - (index + 1)][1],
                        setShowRecentSearches: setShowRecentSearches,
                      ),
                      SizedBox(height: 20.0),
                    ],
                  );
                }))
      ],
    ),
  );
}

Widget showSuggestions({
  @required List placeList,
  BuildContext context,
  UserWithTokenModel storeDetails,
  Function addSearchToList,
  GoogleMapController mapController,
  Function clearPlaceList,
  Function hideSuggestions,
  Function addedSearchFn,
  List recentSearchesList,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 40.0),
        SizedBox(
          height: 230.0,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: placeList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                        title: Row(
                      children: [
                        // If the location has more than 25 letters, slice the word and add '...'
                        buildSinglePlace(
                          context: context,
                          index: index,
                          placeList: placeList,
                          storeDetails: storeDetails,
                          addSearchToList: addSearchToList,
                          mapController: mapController,
                          clearPlaceList: clearPlaceList,
                          recentSearchesList: recentSearchesList,
                          addedSearchFn: addedSearchFn,
                          hideSuggestions: hideSuggestions,
                        ),
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
  );
}
