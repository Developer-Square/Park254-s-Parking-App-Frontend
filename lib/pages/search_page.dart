import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park254_s_parking_app/components/Booking.dart';
import 'package:park254_s_parking_app/components/home_screen.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import '../config/globals.dart' as globals;

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';
  @override
  _SearchPageState createState() => _SearchPageState();
}

/// Creates a search page with recent searches of the user.
///
/// Includes the following widgets from other components:
/// [NearByParkingList()], [parkingPlaces] which contains all the parking places available.
/// [SearchBar] and [RecentSearches].
/// When a user clicks on one of the recent searches or selects their ideal parking location.
/// the recent searches disappear and a bottom widget appears and the search bar is updated.
/// with the chosen parking place name.
class _SearchPageState extends State<SearchPage> {
  // A list that stores all the google markers to be displayed.
  List<Marker> allMarkers = [];
  Completer<GoogleMapController> _controller = Completer();
  bool showRecentSearches;
  bool showBookNowTab;
  bool showRatingTab;
  String _searchText;
  TextEditingController searchBarController = new TextEditingController();
  Position currentPosition;
  int ratingCount;
  var clickedStars;

  @override
  void initState() {
    super.initState();

    ratingCount = 0;
    clickedStars = [];
    showRecentSearches = true;
    showBookNowTab = false;
    showRatingTab = false;
    // Pass Initial values.
    searchBarController.text = _searchText;

    // Start listening to changes.
    searchBarController.addListener(changeSearchText);
  }

  /// A function that receives the GoogleMapController when the map is rendered on the page.
  /// and adds google markers dynamically.
  void mapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      parkingPlaces.forEach((element) {
        allMarkers.add(Marker(
            markerId: MarkerId(element.parkingPlaceName),
            draggable: false,
            infoWindow: InfoWindow(
                title: element.parkingPlaceName, snippet: element.toString()),
            position: element.locationCoords));
      });
    });
  }

// Hides the recent searches when one of them is clicked and.
// sets the searchbar text to the clicked recent search.
  void _setShowRecentSearches(searchText) {
    setState(() {
      searchBarController.text = searchText;
      showRecentSearches = false;
      showBookNowTab = true;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchBarController.dispose();
    super.dispose();
  }

  void changeSearchText() {
    setState(() {
      _searchText = searchBarController.text;
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

  // Changes the rating in the rating tab.
  // also helps to identify which stars were clicked.
  void setStar(title) {
    setState(() {
      if (title == 'star1') {
        addToClickedStars(title);
      } else if (title == 'star2') {
        addToClickedStars(title);
      } else if (title == 'star3') {
        addToClickedStars(title);
      } else if (title == 'star4') {
        addToClickedStars(title);
      } else {
        addToClickedStars(title);
      }
    });
  }

// Adds the title passed on as a param to a list.
// so that we can know which stars were clicked.
// If the title is already there it's removed.
  void addToClickedStars(title) {
    if (clickedStars.contains(title)) {
      clickedStars.remove(title);
    } else {
      clickedStars.add(title);
    }
    clickedStars.map((star) => star == true ? ratingCount += 1 : null);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //Hide the appbar when showing the rating tab
          appBar: !showRatingTab
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back_outlined),
                      color: globals.textColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  title: Text('Search',
                      style: globals.buildTextStyle(
                          18.0, true, globals.textColor)),
                  centerTitle: true,
                )
              : null,
          body: Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(-1.286389, 36.817223), zoom: 14.0),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height - 370),
              ),
            ),
            // The rating pop up shown at the end of the parking session.
            showRatingTab
                ? Center(
                    child: Container(
                    width: MediaQuery.of(context).size.width - 40.0,
                    height: 290.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, bottom: 10.0, left: 30.0, right: 25.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'How would you rate ${searchBarController.text} parking?',
                                  textAlign: TextAlign.center,
                                  style: globals.buildTextStyle(
                                      16.0, true, globals.textColor),
                                ),
                                SizedBox(height: 17.0),
                                Row(
                                  children: <Widget>[
                                    _buildStars('star1'),
                                    _buildStars('star2'),
                                    _buildStars('star3'),
                                    _buildStars('star4'),
                                    _buildStars('star5')
                                  ],
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  'Tap the number of stars you would give ${searchBarController.text} on a scale of 1-5!',
                                  textAlign: TextAlign.center,
                                  style: globals.buildTextStyle(
                                      16.0, true, Colors.grey.withOpacity(0.8)),
                                ),
                                SizedBox(height: 10.0),
                              ]),
                        ),
                        Container(
                            height: 1.0, color: Colors.grey.withOpacity(0.4)),
                        InkWell(
                          onTap: () => hideRatingTabFn(),
                          child: Column(
                            children: [
                              SizedBox(height: 20.0),
                              Text('NOT NOW',
                                  style: globals.buildTextStyle(
                                      18.0, true, Colors.grey.withOpacity(0.7)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                : Container(),
            // Hide the search bar when showing the ratings tab
            !showRatingTab
                ? Container(
                    // Hides all the recent searches if one of them are clicked.
                    height: showRecentSearches
                        ? MediaQuery.of(context).size.height - 310.0
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
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 35.0, top: 25.0),
                            child: showRecentSearches
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'RECENT SEARCH',
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      SizedBox(height: 30.0),
                                      RecentSearches(
                                          specificLocation:
                                              'Parking on Wabera St',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                      SizedBox(height: 20.0),
                                      RecentSearches(
                                          specificLocation:
                                              'First Church of Christ',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                      SizedBox(height: 20.0),
                                      RecentSearches(
                                          specificLocation:
                                              'Parklands Ave, Nairobi',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                      SizedBox(height: 20.0),
                                      RecentSearches(
                                          specificLocation:
                                              'Parklands Ave, Nairobi',
                                          town: 'Nairobi',
                                          setShowRecentSearches:
                                              _setShowRecentSearches),
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                  ),
                          )
                        ]),
                  )
                : Container(),
            showBookNowTab
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 180.0,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 6.0), //(x,y)
                              blurRadius: 8.0,
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            NearByParkingList(
                                activeCard: false,
                                imgPath:
                                    'assets/images/parking_photos/parking_9.jpg',
                                parkingPrice: 400,
                                parkingPlaceName: searchBarController.text,
                                rating: 4.2,
                                distance: 350,
                                parkingSlots: 6),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildButtons(
                                    'Book Now', globals.backgroundColor),
                                _buildButtons('More Info', Colors.white),
                              ],
                            )
                          ],
                        )),
                  )
                : Container(),
          ])),
    );
  }

  /// Builds out the star icons.
  ///
  /// The icons change when clicked.
  Widget _buildStars(title) {
    return InkWell(
      onTap: () => setStar(title),
      child: clickedStars.contains(title)
          ? Icon(
              Icons.star,
              color: Colors.yellow,
              size: 53.0,
            )
          : Icon(
              Icons.star_border,
              color: Colors.grey.withOpacity(0.7),
              size: 53.0,
            ),
    );
  }

  /// A widget that builds the buttons in the bottom widget that appears
  /// when a user clicks on recent searches or selects a their ideal parking place.
  /// from the suggestions.
  Widget _buildButtons(String text, Color _color) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Booking(
                  showRatingTabFn: showRatingTabFn,
                  bookingNumber: 'haaga5441',
                  destination: 'Nairobi',
                  parkingLotNumber: 'pajh5114',
                  price: 11,
                  imagePath: 'assets/images/Park254_logo.png')));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: _color),
          height: 40.0,
          width: 140.0,
          child: Center(
              child: Text(text,
                  style:
                      globals.buildTextStyle(15.0, true, globals.textColor))),
        ));
  }
}
