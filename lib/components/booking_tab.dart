import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';
import 'Booking.dart';
import 'nearby_parking_list.dart';

/// Creates a booking tab position at the bottom of the screen.
/// when a user clicks on one of the recent searches.
///
/// E.g
/// ```dart
/// BookingTab(searchBarControllerText: searchBarController.text);
/// ```

class BookingTab extends StatefulWidget {
  TextEditingController searchBarController;
  bool homeScreen;
  final Function showNearbyParking;
  final Function hideMapButtons;
  final int index;
  NearbyParkingLot selectedParkingLot;

  BookingTab(
      {@required this.searchBarController,
      this.homeScreen,
      this.showNearbyParking,
      this.hideMapButtons,
      this.index,
      this.selectedParkingLot});
  @override
  _BookingTabState createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  getRandomNumber() {
    Random rng = new Random();
    List<String> randomList =
        new List<String>.generate(4, (_) => rng.nextInt(100).toString());
    return randomList.join();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: widget.homeScreen ? 195.0 : 170.0,
          width: MediaQuery.of(context).size.width / 1.13,
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
          padding: widget.homeScreen
              ? EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 15.0, right: 15.0)
              : EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              // Display the close icon on in homescreen.
              widget.homeScreen
                  ? Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 1.4),
                      child: InkWell(
                          onTap: widget.homeScreen
                              ? () {
                                  widget.showNearbyParking();
                                  widget.hideMapButtons('bookingTab', null);
                                  widget.searchBarController.text = '';
                                }
                              : () {},
                          child: Icon(Icons.close)))
                  : Container(),
              NearByParkingList(
                  activeCard: false,
                  imgPath: widget.selectedParkingLot.images[0],
                  parkingPrice: widget.selectedParkingLot.price,
                  parkingPlaceName: widget.selectedParkingLot.name.length > 20
                      ? widget.selectedParkingLot.name.substring(0, 20) + '...'
                      : widget.selectedParkingLot.name,
                  rating: widget.selectedParkingLot.rating,
                  distance: widget.selectedParkingLot.distance,
                  parkingSlots: widget.selectedParkingLot.spaces),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButtons('Book Now', globals.backgroundColor),
                  _buildButtons('More Info', Colors.white),
                ],
              )
            ],
          )),
    );
  }

  /// A widget that builds the buttons in the bottom widget that appears
  ///
  /// when a user clicks on recent searches or selects a their ideal parking place.
  /// from the suggestions.
  Widget _buildButtons(String text, Color _color) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Booking(
                  address: widget.selectedParkingLot.location.toString(),
                  bookingNumber: getRandomNumber(),
                  destination: widget.selectedParkingLot.name,
                  parkingLotNumber: getRandomNumber(),
                  price: 1,
                  imagePath: widget.selectedParkingLot.images[0])));
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
