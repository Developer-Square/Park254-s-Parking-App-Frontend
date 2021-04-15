import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:park254_s_parking_app/components/load_location.dart';
import '../config/globals.dart' as globals;

/// Creates a List of a user's recent searches.
///
/// Requires [specificLocation], [town] and [setShowRecentSearches].
/// E.g.
///```
/// RecentSearches(
/// specificLocation: 'Parking on Wabera St',
/// town: 'Nairobi',
/// setShowRecentSearches:
/// () {})
///```

class RecentSearches extends StatelessWidget {
  final newSearch;
  final String specificLocation;
  final String town;
  final Function setShowRecentSearches;
  final controller;
  final Function clearPlaceListFn;
  final context;

  RecentSearches(
      {@required this.specificLocation,
      @required this.town,
      @required this.setShowRecentSearches,
      this.newSearch,
      this.controller,
      this.clearPlaceListFn,
      this.context});
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        newSearch == true
            ? getLocation(specificLocation + ',' + town, controller,
                clearPlaceListFn, context)
            : setShowRecentSearches(specificLocation);
      },
      child: Row(children: <Widget>[
        // If the user is typing in a new location.
        // Don't display the watch_later
        newSearch == true
            ? SvgPicture.asset('assets/images/pin_icons/location-pin.svg',
                width: 26.0, color: Colors.grey.withOpacity(0.8))
            : Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    color: Colors.grey.withOpacity(0.2)),
                child: Icon(
                  Icons.watch_later_outlined,
                  color: Colors.grey,
                )),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              specificLocation,
              style: globals.buildTextStyle(18.0, true, globals.textColor),
            ),
            SizedBox(height: 7.0),
            Text(
              town,
              style: TextStyle(
                  color: Colors.grey.withOpacity(0.8), fontSize: 17.0),
            )
          ],
        )
      ]),
    );
  }
}
