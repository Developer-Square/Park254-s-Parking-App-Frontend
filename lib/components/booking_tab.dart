import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
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

  BookingTab(
      {@required this.searchBarController,
      this.homeScreen,
      this.showNearbyParking,
      this.hideMapButtons,
      this.index});
  @override
  _BookingTabState createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
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
                                  widget.hideMapButtons('bookingTab');
                                  widget.searchBarController.text = '';
                                }
                              : () {},
                          child: Icon(Icons.close)))
                  : Container(),
              NearByParkingList(
                  activeCard: false,
                  imgPath:
                      'assets/images/parking_photos/parking_${widget.index}.jpg',
                  parkingPrice: 400,
                  parkingPlaceName: widget.searchBarController.text.length > 20
                      ? widget.searchBarController.text.substring(0, 20) + '...'
                      : widget.searchBarController.text,
                  rating: 4.2,
                  distance: 350,
                  parkingSlots: 6),
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
                  address:
                      '100 West 33rd Street, Nairobi Industrial Area, 00100, Kenya',
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
