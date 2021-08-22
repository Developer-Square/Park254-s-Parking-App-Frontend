import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';

Widget showRecentSearchesWidget({
  @required List recentSearchesList,
  @required GoogleMapController mapController,
  @required UserWithTokenModel storeDetails,
  @required Function addSearchToList,
  @required CustomInfoWindowController customInfoWindowController,
  @required Function setShowRecentSearches,
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
                          customInfoWindowController:
                              customInfoWindowController,
                          // Reverve the list to get the most recent search first.
                          parkingData: recentSearchesList[
                              recentSearchesList.length - (index + 1)][0],
                          specificLocation: recentSearchesList[
                              recentSearchesList.length - (index + 1)][0],
                          town: recentSearchesList[
                              recentSearchesList.length - (index + 1)][1],
                          setShowRecentSearches: setShowRecentSearches),
                      SizedBox(height: 20.0),
                    ],
                  );
                }))
      ],
    ),
  );
}

Widget showSuggestions(
    {@required List placeList, @required Function buildSinglePlace}) {
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
                        buildSinglePlace(index),
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
