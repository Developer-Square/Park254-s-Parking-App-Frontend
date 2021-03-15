import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;
import 'package:park254_s_parking_app/components/search_bar.dart';

/// Creates the top UI widget in [home_screen.dart], [profile_screen.dart] and [myparking.dart].
///
/// Requires [searchBarController], [currentPage] and [widget].
/// dart```
/// TopPageStyling(
/// searchBarController: controller,
/// currentPage: 'home'
/// )
class TopPageStyling extends StatelessWidget {
  final searchBarController;
  final currentPage;
  final widget;

  TopPageStyling(
      {this.searchBarController, @required this.currentPage, this.widget});
  Widget build(BuildContext context) {
    return Container(
      height: currentPage == 'myparking' ? 260.0 : 210.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: globals.backgroundColor,
          borderRadius: BorderRadius.only(
              bottomRight: currentPage == 'myparking'
                  ? Radius.elliptical(400, 270)
                  : Radius.elliptical(500, 240))),
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Container(
                  width: 190.0,
                  child: Text(
                      currentPage == 'home'
                          ? 'Where do you want to park?'
                          : currentPage == 'profile'
                              ? 'Profile'
                              : 'My Parking',
                      style: TextStyle(
                        color: globals.textColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      )),
                ),
              ),
              SizedBox(
                  height: currentPage == 'profile' || currentPage == 'myparking'
                      ? 37.0
                      : 24.0),
              currentPage == 'home'
                  ? SearchBar(
                      offsetY: 4.0,
                      blurRadius: 6.0,
                      opacity: 0.9,
                      controller: searchBarController,
                      searchBarTapped: false,
                    )
                  : widget
            ]),
      ),
    );
  }
}
