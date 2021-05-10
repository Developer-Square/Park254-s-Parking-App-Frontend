import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchPageArguments {
  final String specificLocation;
  final String town;
  final Function setShowRecentSearches;
  final FlutterSecureStorage loginDetails;

  SearchPageArguments(
      {@required this.specificLocation,
      @required this.town,
      @required this.setShowRecentSearches,
      @required this.loginDetails});
}

class RatingTabArguements {
  final hideRatingTabFn;
  final parkingPlaceName;

  RatingTabArguements(
      {@required this.hideRatingTabFn, @required this.parkingPlaceName});
}

class SearchBarArguements {
  final double offsetY;
  final double blurRadius;
  final double opacity;
  final TextEditingController controller;
  final bool searchBarTapped;
  final bool showSuggestion;
  final Function showSuggestionFn;

  SearchBarArguements(
      {@required this.offsetY,
      @required this.blurRadius,
      @required this.opacity,
      @required this.controller,
      @required this.searchBarTapped,
      this.showSuggestion,
      this.showSuggestionFn});
}

class RecentSearchesArguements {
  final newSearch;
  final String specificLocation;
  final String town;
  final Function setShowRecentSearches;
  final controller;
  final Function clearPlaceListFn;
  final context;

  RecentSearchesArguements(
      {@required this.specificLocation,
      @required this.town,
      @required this.setShowRecentSearches,
      this.newSearch,
      this.controller,
      this.clearPlaceListFn,
      this.context});
}

class BookingTabArguements {
  final searchBarControllerText;

  BookingTabArguements({@required this.searchBarControllerText});
}
