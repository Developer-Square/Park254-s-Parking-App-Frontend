import 'package:flutter/material.dart';

class SearchPageArguments {
  final String specificLocation;
  final String town;
  final Function setShowRecentSearches;

  SearchPageArguments({
    @required this.specificLocation,
    @required this.town,
    @required this.setShowRecentSearches,
  });
}
