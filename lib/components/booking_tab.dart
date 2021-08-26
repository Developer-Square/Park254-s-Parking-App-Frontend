import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/MoreInfo.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/dataModels/ParkingLotModel.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLot.model.dart';
import 'package:provider/provider.dart';
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

  BookingTab({
    @required this.searchBarController,
    this.homeScreen,
    this.showNearbyParking,
  });
  @override
  _BookingTabState createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  NearbyParkingListModel nearbyParkingListDetails;

  @override
  initState() {
    super.initState();
    if (mounted) {
      nearbyParkingListDetails =
          Provider.of<NearbyParkingListModel>(context, listen: false);
    }
  }

  getRandomNumber() {
    Random rng = new Random();
    List<String> randomList =
        new List<String>.generate(4, (_) => rng.nextInt(100).toString());
    return randomList.join();
  }

  @override
  Widget build(BuildContext context) {
    developer.log(nearbyParkingListDetails.nearbyParkingLot.name.toString());
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 195.0,
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
              Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 1.4),
                  child: InkWell(
                      onTap: () {
                        if (nearbyParkingListDetails != null) {
                          if (nearbyParkingListDetails.currentPage == 'home') {
                            widget.showNearbyParking();
                          }

                          nearbyParkingListDetails.setBookNowTab('bookingTab');
                        }

                        widget.searchBarController.text = '';
                      },
                      child: Icon(Icons.close))),
              NearByParkingList(
                  activeCard: false,
                  imgPath:
                      nearbyParkingListDetails.nearbyParkingLot.images.length >
                              0
                          ? nearbyParkingListDetails.nearbyParkingLot.images[0]
                          : '',
                  parkingPrice: nearbyParkingListDetails.nearbyParkingLot.price,
                  parkingPlaceName:
                      nearbyParkingListDetails.nearbyParkingLot.name.length > 20
                          ? nearbyParkingListDetails.nearbyParkingLot.name
                                  .substring(0, 20) +
                              '...'
                          : nearbyParkingListDetails.nearbyParkingLot.name,
                  rating: nearbyParkingListDetails.nearbyParkingLot.rating,
                  distance: nearbyParkingListDetails.nearbyParkingLot.distance,
                  parkingSlots:
                      nearbyParkingListDetails.nearbyParkingLot.spaces),
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
                  address: nearbyParkingListDetails.nearbyParkingLot.location
                      .toString(),
                  bookingNumber: getRandomNumber(),
                  destination: nearbyParkingListDetails.nearbyParkingLot.name,
                  parkingLotNumber: getRandomNumber(),
                  // TODO: Change that number when in production.
                  price: 1,
                  imagePath:
                      nearbyParkingListDetails.nearbyParkingLot.images[0])));
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
