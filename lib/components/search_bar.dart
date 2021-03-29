import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/pages/search_page.dart';
import '../config/globals.dart' as globals;

/// Creates a search bar which appears on both the homepage and search page.
///
/// When its clicked on the homepage it takes a user to the search page
/// Requires [offsetY], [blurRadius], [opacity] and [controller].
/// ```
/// SearchBar(
/// offsetY: 4.0,
/// blurRadius: 6.0,
/// opacity: 0.9,
/// controller: searchBarController,
/// searchBarTapped: false,
/// )
///```

class SearchBar extends StatefulWidget {
  final double offsetY;
  final double blurRadius;
  final double opacity;
  final TextEditingController controller;
  final bool searchBarTapped;

  SearchBar(
      {@required this.offsetY,
      @required this.blurRadius,
      @required this.opacity,
      @required this.controller,
      @required this.searchBarTapped});
  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width - 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(widget.opacity),
              offset: Offset(0.0, widget.offsetY), //(x,y)
              blurRadius: widget.blurRadius,
            )
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.search_outlined),
          SizedBox(width: 10.0),
          Container(
            width: MediaQuery.of(context).size.width - 150,
            // If the user is on the search page then the search bar should auto focus.
            child: TextField(
              autofocus: widget.searchBarTapped ? true : false,
              controller: widget.controller,
              // If the user is on the home page, navigate to the search page.
              onTap: () {
                widget.searchBarTapped == false
                    ? Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()))
                    // ignore: unnecessary_statements
                    : () {};
              },
              cursorColor: globals.backgroundColor,
              decoration: InputDecoration.collapsed(
                  hintText: 'Add destination, event, etc',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                      fontWeight: FontWeight.bold)),
            ),
          )
        ]),
      ),
    );
  }
}
