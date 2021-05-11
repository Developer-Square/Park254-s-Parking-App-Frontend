import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import '../config/globals.dart' as globals;

/// Creates a my parking screen that shows you a history of places you've parked.
///
///
class MyParkingScreen extends StatefulWidget {
  final FlutterSecureStorage loginDetails;

  MyParkingScreen({@required this.loginDetails});
  @override
  MyParkingState createState() => MyParkingState();
}

class MyParkingState extends State<MyParkingScreen> {
  var userRole;

  @override
  initState() {
    getUserDetails();
  }

  getUserDetails() async {
    userRole = await widget.loginDetails.read(key: 'role');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Material(
            color: Colors.grey[200],
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TopPageStyling(
                      userRole: userRole,
                      currentPage: 'myparking',
                      widget: userRole == 'vendor'
                          ? Container()
                          : buildParkingTab()),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Text(
                          userRole == 'vendor'
                              ? 'Your Parking Lots'
                              : 'History',
                          style: globals.buildTextStyle(
                              17.0, true, globals.textColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 37.0,
                            height: 37.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                color: Colors.white),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  userRole == 'vendor'
                      ? buildParkingContainer(
                          'Holy Basilica Parking',
                          'Ksh 240 / hr',
                          'First Church of Christ...',
                          'Parking Slots: 600',
                          Colors.white)
                      : Column(
                          children: [
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
                          ],
                        ),
                  SizedBox(height: 100.0)
                ],
              ),
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
  ///
  /// Requires [parkingLotNumber], [parkingPrice], [parkingLocation], [paymentStatus] and [paymentColor].
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
                      userRole == 'vendor'
                          ? Container(
                              height: 20.0,
                              width: 20,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  color: paymentColor))
                          : Container(),
                      userRole == 'vendor'
                          ? SizedBox(width: 10.0)
                          : SizedBox(width: 0.0),
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
          child: Text(userRole == 'vendor' ? 'Update' : 'Share Spot'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            userRole == 'vendor' ? 'Delete' : 'Report an issue',
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
