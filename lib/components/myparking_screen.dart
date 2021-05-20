import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/create_update_parking_lot.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/functions/parkingLots/deleteParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
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
  var parkingLotsResults;
  bool showLoader;
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController spacesController = new TextEditingController();
  TextEditingController pricesController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();

  @override
  initState() {
    super.initState();
    showLoader = false;
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    spacesController.dispose();
    pricesController.dispose();
    addressController.dispose();
    cityController.dispose();
  }

  getUserDetails() async {
    var role = await widget.loginDetails.read(key: 'role');

    setState(() {
      userRole = role;
    });
  }

  redirectToCreateorUpdatePage(text, [parkingData]) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateUpdateParkingLot(
              loginDetails: widget.loginDetails,
              currentScreen: text,
              name: fullNameController,
              spaces: spacesController,
              prices: pricesController,
              address: addressController,
              city: cityController,
              parkingData: parkingData,
            )));
  }

// Get all the parking lots owned by the current user.
  getParkingDetails() async {
    var token = await widget.loginDetails.read(key: 'accessToken');
    var userId = await widget.loginDetails.read(key: 'userId');

    getParkingLots(token: token, owner: userId).then((value) {
      parkingLotsResults = value.parkingLots;
    }).catchError((err) {
      print(err);
    });
  }

  _updateParking(parkingLotData) {
    // Update the form fields then move to the page.
    setState(() {
      fullNameController.text = parkingLotData.name;
      spacesController.text = parkingLotData.spaces.toString();
      pricesController.text = parkingLotData.price.toString();
      addressController.text = parkingLotData.address;
      cityController.text = parkingLotData.city;
    });
    redirectToCreateorUpdatePage('update', parkingLotData);
  }

  _deleteParkingLot(parkingLotId) async {
    setState(() {
      showLoader = true;
    });
    var token = await widget.loginDetails.read(key: 'accessToken');
    deleteParkingLot(token: token, parkingLotId: parkingLotId).then((value) {
      if (value == 'success') {
        setState(() {
          showLoader = false;
        });
      }
    }).catchError((err) {
      setState(() {
        showLoader = false;
      });
      print(err);
    });
  }

  Widget build(BuildContext context) {
    getUserDetails();
    getParkingDetails();
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Material(
              color: Colors.grey[200],
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
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
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CreateUpdateParkingLot(
                                          loginDetails: widget.loginDetails,
                                          currentScreen: 'create',
                                          name: fullNameController,
                                          spaces: spacesController,
                                          prices: pricesController,
                                          address: addressController,
                                          city: cityController,
                                        )));
                              },
                              child: Container(
                                width: 37.0,
                                height: 37.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0)),
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
                      userRole == 'vendor' && parkingLotsResults != null
                          ? buildParkingLotResults(parkingLotsResults)
                          : userRole == 'user'
                              ? Column(
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
                                )
                              : Center(
                                  child: Text(
                                  'Loading....',
                                  style: globals.buildTextStyle(
                                      17.0, true, Colors.grey),
                                )),
                      SizedBox(height: 100.0)
                    ],
                  ),
                ),
              )),
          showLoader ? Loader() : Container()
        ]),
      ),
    );
  }

  /// Builds out all the parking widgets on the page.
  ///
  /// This happens after the parking lots are fetched from the backend.
  Widget buildParkingLotResults(List results) {
    return new Column(
        children: results
            .map(
              (item) => Column(
                children: [
                  buildParkingContainer(
                      item.name,
                      'Ksh ${item.price} / hr',
                      item.address,
                      'Parking Slots: ${item.spaces}',
                      Colors.white,
                      item),
                  SizedBox(height: 15.0)
                ],
              ),
            )
            .toList());
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
  /// Requires [parkingLotNumber], [parkingPrice], [parkingLocation], [paymentStatus], [paymentColor] and [parkingLotData].
  /// The parkingLotData will be used when updating and deleting parking lots.
  Widget buildParkingContainer(parkingLotNumber, parkingPrice, parkingLocation,
      paymentStatus, paymentColor,
      [parkingLotData]) {
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
                  _popUpMenu(parkingLotData)
                ]),
          )
        ]),
      ),
    );
  }

  Widget _popUpMenu(parkingLotData) {
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
      onSelected: (value) => {
        userRole == 'vendor'
            ? value == 1
                ? _updateParking(parkingLotData)
                : _deleteParkingLot(parkingLotData.id)
            : () {}
      },
      icon: Icon(
        Icons.more_vert,
        color: globals.textColor,
      ),
      offset: Offset(0, 100),
    );
  }
}
