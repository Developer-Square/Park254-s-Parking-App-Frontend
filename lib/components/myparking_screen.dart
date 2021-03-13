import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import '../config/globals.dart' as globals;

/// Creates a my parking screen that shows you a history of places you've parked.
///
///
class MyParkingScreen extends StatefulWidget {
  @override
  MyParkingState createState() => MyParkingState();
}

class MyParkingState extends State<MyParkingScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Material(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TopPageStyling(
                    currentPage: 'myparking', widget: buildParkingTab()),
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    'History',
                    style:
                        globals.buildTextStyle(17.0, true, globals.textColor),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                buildParkingContainer(
                    'MALL: P2 . 5B',
                    'Ksh 2400',
                    'First Church of Christ',
                    'Payment Success',
                    globals.backgroundColor),
                SizedBox(height: 10.0),
                buildParkingContainer(
                    'MALL: P2 . 5B',
                    'Ksh 2400',
                    'Parklands Ave, Nairobi',
                    'Payment failed',
                    Colors.orange[800]),
                SizedBox(height: 10.0),
                buildParkingContainer(
                    'MALL: P2 . 5B',
                    'Ksh 2400',
                    'Parklands Ave, Nairobi',
                    'Payment failed',
                    Colors.orange[800]),
                SizedBox(height: 100.0)
              ],
            )),
      ),
    );
  }

  /// Builds out the parking tabs on the page.
  Widget buildParkingTab() {
    return Center(
        child: buildParkingContainer(
            'SPACE: P5 . 6A',
            'Ksh 200',
            'Parking on Wabera St',
            'Waiting for payment',
            globals.backgroundColor));
  }

  /// Builds out the different containers on the page
  Widget buildParkingContainer(parkingLotNumber, parkingPrice, parkingLocation,
      paymentStatus, paymentColor) {
    return BoxShadowWrapper(
      offsetY: 0.0,
      offsetX: 0.0,
      blurRadius: 4.0,
      opacity: 0.6,
      height: 150.0,
      content: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width - 40.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  parkingLotNumber,
                  style: globals.buildTextStyle(15.5, true, Colors.blue[400]),
                ),
                Text(
                  parkingPrice,
                  style: globals.buildTextStyle(16.0, true, globals.textColor),
                )
              ],
            ),
          ),
          SizedBox(height: 7.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              parkingLocation,
              style: globals.buildTextStyle(17.0, true, globals.textColor),
            ),
          ),
          SizedBox(
              height: 25.0,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black54.withOpacity(0.1)))),
              )),
          Padding(
            padding: EdgeInsets.only(top: 6.0, left: 20.0, right: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          height: 20.0,
                          width: 20,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              color: paymentColor)),
                      SizedBox(width: 10.0),
                      Text(
                        paymentStatus,
                        style: globals.buildTextStyle(
                            15.0, true, globals.textColor),
                      ),
                    ],
                  ),
                  _popUpMenu()
                ]),
          )
        ]),
      ),
    );
  }

  Widget _popUpMenu() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Share Spot'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Report an issue',
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
      onSelected: (value) => {},
      icon: Icon(
        Icons.more_vert,
        color: globals.textColor,
      ),
      offset: Offset(0, 100),
    );
  }
}
