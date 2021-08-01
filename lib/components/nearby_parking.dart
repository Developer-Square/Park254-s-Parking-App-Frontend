import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getNearbyParkingLots.dart';
import 'package:park254_s_parking_app/functions/utils/request_interceptor.dart';
import '../config/globals.dart' as globals;

/// Creates a widget on the homepage that shows all the nearyby parking places.
///
/// The nearby parking places are displayed with the nearest being the first one.
/// Takes [NearByParkingList] as a widget.
class NearByParking extends StatefulWidget {
  static const routeName = '/search_page';
  final Function showNearByParkingFn;
  final Function hideDetails;
  final Completer<GoogleMapController> mapController;
  final CustomInfoWindowController customInfoWindowController;
  final Function showFullBackground;
  final TextEditingController searchBarController;
  final Function hideMapButtons;
  final Position currentPosition;
  final FlutterSecureStorage loginDetails;
  final Function storeLoginDetails;
  final Function clearStorage;
  final Function showToolTipFn;
  final Function hideToolTip;

  NearByParking(
      {@required this.showNearByParkingFn,
      @required this.hideDetails,
      @required this.mapController,
      @required this.customInfoWindowController,
      @required this.showFullBackground,
      this.searchBarController,
      this.hideMapButtons,
      this.currentPosition,
      this.loginDetails,
      this.storeLoginDetails,
      this.clearStorage,
      this.showToolTipFn,
      this.hideToolTip});

  @override
  _NearByParkingState createState() => _NearByParkingState();
}

class _NearByParkingState extends State<NearByParking>
    with TickerProviderStateMixin {
  double _size;
  bool _large;
  String selectedCard = 'Nearby Parking';
  var parkingLots;
  int maxRetries;

  @override
  void initState() {
    super.initState();
    _size = 278.52;
    _large = false;
    maxRetries = 0;
  }

  // Make the api call to get the nearest parking lots
  getNearestParkingPlaces(coords) async {
    var accessToken = await widget.loginDetails.read(key: 'accessToken');
    if (coords != null) {
      getNearbyParkingLots(
              token: accessToken,
              longitude: coords.longitude,
              latitude: coords.latitude,
              maxDistance: 500)
          .then((value) {
        // Add all the nearby parking lots in the area so that.
        // we can map over them later.
        setState(() {
          parkingLots = value;
        });
      }).catchError((err) {
        // Retry the request after getting status code of 401.
        if (err.code == 401) {
          // Keep track and add to the number of retries made.
          // Make only 3 retries
          if (maxRetries < 3) {
            maxRetries += 1;
            retryFuture(getNearestParkingPlaces, widget.loginDetails,
                widget.storeLoginDetails, widget.clearStorage, coords);
          } else {
            widget.showToolTipFn(err.message);
          }
        }
      });
    }
  }

  /// Increases the size of the nearby and recommended widget.
  void _updateSize() {
    setState(() {
      widget.hideDetails();
      _large = true;
      _size = _large ? 502.0 : _size;
      widget.showFullBackground();
    });
  }

  /// Closes the full sized nearyby parking widget and returns everything back to normal.
  void _closeFullSizeWidget() {
    setState(() {
      _large = false;
      _size = 278.52;
      widget.hideDetails();
      widget.showFullBackground();
    });
  }

  /// Closes the full sized nearyby parking widget and redirects user to the chosen location.
  _closeFullSizeWidgetRedirection() {
    setState(() {
      _large = false;
      widget.hideDetails();
    });
  }

  /// Adds opacity to make the selected widget more visible.
  void selectCard(cardTitle) {
    if (!_large) {
      _updateSize();
    }
    setState(() {
      selectedCard = cardTitle;
    });
  }

  Widget build(BuildContext context) {
    if (maxRetries < 3) {
      getNearestParkingPlaces(widget.currentPosition);
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
          color: Colors.transparent,
          child: AnimatedSize(
              curve: Curves.easeInOut,
              vsync: this,
              duration: Duration(seconds: 2),
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                SizedBox(width: 12.0),
                buildNearbyContainer('Nearby Parking'),
                SizedBox(width: 15.0),
                buildNearbyContainer('Recommeded Parking'),
                SizedBox(width: 12.0),
              ]))),
    );
  }

  /// Builds out the title at the top when the nearyby parking expands.
  Widget buildTitle(String title) {
    return Column(children: <Widget>[
      SizedBox(height: 50.0),
      Text(title,
          style: globals.buildTextStyle(
              18.0, true, Colors.white.withOpacity(0.9))),
      SizedBox(height: 30.0),
    ]);
  }

  /// Builds out the close button that appears when the widget is expanded.
  ///
  /// It closes the expanded widget and returns everything back to normal.
  Widget buildCloseButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () => _closeFullSizeWidget(),
        child: Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
          ),
          child: Icon(Icons.close),
        ),
      ),
    );
  }

  /// Builds out the different parking locations using data provided.
  /// by parking model.
  Widget buildParkingPlacesList(title) {
    return ListView.builder(
        itemCount: parkingLots.lots.length,
        itemBuilder: (context, index) {
          int picIndex = index + 1;
          return Column(
            children: [
              NearByParkingList(
                activeCard: title == selectedCard ? true : false,
                imgPath: 'assets/images/parking_photos/parking_$picIndex.jpg',
                parkingPrice: parkingLots.lots[index].price,
                parkingPlaceName: parkingLots.lots[index].name,
                rating: parkingLots.lots[index].rating,
                distance: parkingLots.lots[index].distance,
                parkingSlots: parkingLots.lots[index].spaces,
                mapController: widget.mapController,
                customInfoWindowController: widget.customInfoWindowController,
                parkingData: parkingLots.lots[index],
                showNearbyParking: widget.showNearByParkingFn,
                hideAllDetails: _closeFullSizeWidgetRedirection,
                large: _large,
                title: title,
                selectedCard: selectedCard,
                selectCard: selectCard,
                searchBarController: widget.searchBarController,
                hideMapButtons: widget.hideMapButtons,
              ),
              SizedBox(height: 20.0)
            ],
          );
        });
  }

  /// Builds out the nearby parking widget and the recommended parking widget.
  ///
  /// Disables the cards depending on which one is selected.
  Widget buildNearbyContainer(String title) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      _large ? buildTitle(title) : Container(),
      InkWell(
        onTap: () => selectCard(title),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
          height: _size,
          width: MediaQuery.of(context).size.width - 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: title == selectedCard ? Colors.grey : Colors.transparent,
                offset: Offset(1.0, 3.0), //(x,y)
                blurRadius: 7.0,
              )
            ],
            color: title == selectedCard
                ? Colors.white
                : Colors.white.withOpacity(0.8),
          ),
          margin: EdgeInsets.only(bottom: _large ? 15.0 : 30.0),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(title,
                              style: globals.buildTextStyle(
                                  16.0,
                                  true,
                                  title == selectedCard
                                      ? globals.textColor
                                      : globals.textColor.withOpacity(0.7))),
                          SizedBox(width: 15.0),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 19.0,
                            ),
                          ),
                        ]),
                    // To remove the close icon on the widget while the
                    // widget is in large mode.
                    !_large
                        ? InkWell(
                            onTap: widget.showNearByParkingFn,
                            child: Icon(Icons.close),
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 19.0),
                SizedBox(
                    height: _large ? 420.0 : 205.0,
                    child: parkingLots != null
                        ? buildParkingPlacesList(title)
                        : Loader()),
              ],
            ),
          ),
        ),
      ),
      _large ? buildCloseButton() : Container(),
      SizedBox(height: 35.0)
    ]);
  }
}
