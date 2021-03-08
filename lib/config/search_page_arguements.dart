import 'package:flutter/material.dart';

class SearchPageArguements {
  final String specificLocation;
  final String town;
  final Function setShowRecentSearches;

  SearchPageArguements({
    @required this.specificLocation,
    @required this.town,
    @required this.setShowRecentSearches,
  });
}
