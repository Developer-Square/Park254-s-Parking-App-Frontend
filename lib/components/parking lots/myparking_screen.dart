import 'dart:developer';
import 'dart:math' as dartMath;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/parking%20lots/ParkingInfo.dart';
import 'package:park254_s_parking_app/components/parking%20lots/create_update_parking_lot.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/dataModels/UserModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/bookings/getBookings.dart';
import 'package:park254_s_parking_app/functions/parkingLots/deleteParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLotById.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/dataModels/ParkingLotListModel.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'package:park254_s_parking_app/models/booking.populated.model.dart';
import 'package:provider/provider.dart';
import '../../config/globals.dart' as globals;
import '../helper_functions.dart';
import 'package:park254_s_parking_app/models/queryParkingLots.models.dart';

/// Creates a my parking screen that shows you a history of places you've parked.
///
///
class MyParkingScreen extends StatefulWidget {
  @override
  MyParkingState createState() => MyParkingState();
}

class MyParkingState extends State<MyParkingScreen> {
  var userRole;
  var accessToken;
  var userId;
  List parkingLotsResults;
  bool showLoader;
  // User's details from the store.
  UserWithTokenModel storeDetails;
  // Parking lots from the store.
  ParkingLotListModel parkingLotList;
  // Used when we are fetching details for individual parking lots.
  List parkingLotDetails = [];
  UserModel userModel;
  List<BookingDetails> bookingDetailsList;
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController spacesController = new TextEditingController();
  TextEditingController pricesController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    showLoader = false;

    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      parkingLotList = Provider.of<ParkingLotListModel>(context, listen: false);
      userModel = Provider.of<UserModel>(context, listen: false);
      userRole = storeDetails.user.user.role;
      accessToken = storeDetails.user.accessToken.token;
      userId = storeDetails.user.user.id;
      getParkingDetails();
      // If the current user is a normal user fetch their parkingLots history.
      if (userRole == 'user') {
        fetchParkingLotHistory(access: accessToken, userId: userId);
      }
    }
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

  void fetchParkingLotHistory({String access, String userId}) {
    getBookings(token: access, clientId: userId, sortBy: 'desc').then((value) {
      setState(() {
        bookingDetailsList = value.bookingDetailsList;
      });
      // Get parking lot details i.e. names, ratings etc.
      value.bookingDetailsList.forEach((element) {
        if (element.parkingLotId != null) {
          getParkingLotById(token: access, parkingLotId: element.parkingLotId)
              .then((value) {
            setState(() {
              parkingLotDetails
                  .add({'name': value.name, 'address': value.address});
            });
          }).catchError((err) {
            log("In fetchParkingLotHistory, myparking_screen");
            log(err.toString());
          });
        }
      });
    }).catchError((err) {
      log("In fetchParkingLotHistory, myparking_screen");
      log(err.toString());
      buildNotification(err.message, 'error');
    });
  }

  redirectToCreateorUpdatePage(text, [parkingData]) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateUpdateParkingLot(
              currentScreen: text,
              name: fullNameController,
              spaces: spacesController,
              prices: pricesController,
              address: addressController,
              city: cityController,
              parkingData: parkingData,
              getParkingDetails: getParkingDetails,
            )));
  }

  // Get all the parking lots owned by the current user.
  getParkingDetails() async {
    if (accessToken != null && userId != null) {
      parkingLotList.fetch(token: accessToken, owner: userId);
    }
  }

  // Convert DateTime to TimeOfDay to be displayed in the parking history list.
  String timeOfDayToString(value) {
    var time = TimeOfDay.fromDateTime(value).toString();
    return time.substring(10, 15);
  }

  // Update the form fields then move to the page.
  _updateParking(parkingLotData) {
    setState(() {
      fullNameController.text = parkingLotData.name;
      spacesController.text = parkingLotData.spaces.toString();
      pricesController.text = parkingLotData.price.toString();
      addressController.text = parkingLotData.address;
      cityController.text = parkingLotData.city;
    });
    if (userModel != null) {
      userModel.setCurrentScreen('update');
    }
    redirectToCreateorUpdatePage('update', parkingLotData);
  }

  _deleteParkingLot(parkingLot) async {
    setState(() {
      showLoader = true;
    });
    var token = storeDetails.user.accessToken.token;
    deleteParkingLot(token: token, parkingLotId: parkingLot.id).then((value) {
      if (value == 'success') {
        buildNotification('Deleted parking lot successfully', 'success');
        if (parkingLotList != null) {
          parkingLotList.remove(parkingLot: parkingLot);
        }
        setState(() {
          showLoader = false;
        });
      }
    }).catchError((err) {
      setState(() {
        showLoader = false;
      });
      print("In deleteParkingLot, myparking_screen");
      buildNotification(err.message, 'error');
      log(err.toString());
    });
  }

  Widget build(BuildContext context) {
    parkingLotList = Provider.of<ParkingLotListModel>(context);
    if (parkingLotList.parkingLotList.parkingLots != null) {
      var availableParkingLots = parkingLotList.parkingLotList.parkingLots;
      parkingLotsResults = availableParkingLots;
    }
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
                          currentPage: 'myparking',
                          widget:
                              userRole == 'vendor' ? Container() : Container()),
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
                                if (userModel != null) {
                                  userModel.setCurrentScreen('create');
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CreateUpdateParkingLot(
                                            currentScreen: 'create',
                                            name: fullNameController,
                                            spaces: spacesController,
                                            prices: pricesController,
                                            address: addressController,
                                            city: cityController,
                                            getParkingDetails:
                                                getParkingDetails)));
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
                          ? buildParkingLotResults(results: parkingLotsResults)
                          : userRole == 'user' && bookingDetailsList != null
                              ? buildParkingLotResults(
                                  results: bookingDetailsList)
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
  Widget buildParkingLotResults({List results}) {
    return new Column(
        children: results
            .map(
              (item) => Column(
                children: [
                  InkWell(
                    child: userRole == 'user'
                        ? buildParkingContainer(
                            parkingLotName: parkingLotDetails.length != 0
                                ? parkingLotDetails[0]['name']
                                : 'Loading...',
                            parkingPrice: timeOfDayToString(item.entryTime),
                            parkingLocation: parkingLotDetails.length != 0
                                ? parkingLotDetails[0]['address']
                                : 'Loading...',
                            paymentStatus: timeOfDayToString(item.exitTime),
                          )
                        : buildParkingContainer(
                            parkingLotName: item.name,
                            parkingPrice: 'Ksh ${item.price} / hr',
                            parkingLocation: item.address,
                            paymentStatus: 'Parking Slots: ${item.spaces}',
                            paymentColor: Colors.white,
                            parkingLotData: item,
                          ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ParkingInfo(
                            images: item.images,
                            name: item.name,
                            accessibleParking: item.features.accessibleParking,
                            cctv: item.features.cctv,
                            carWash: item.features.carWash,
                            evCharging: item.features.evCharging,
                            valetParking: item.features.valetParking,
                            rating: item.rating,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15.0)
                ],
              ),
            )
            .toList());
  }

  /// Builds out the parking tabs on the page.
  // Widget buildParkingTab() {
  //   return Center(
  //       child: buildParkingContainer(
  //           'SPACE: P5 . 6A',
  //           'Ksh 200',
  //           'Parking on Wabera St',
  //           'Waiting for payment',
  //           globals.backgroundColor));
  // }

  /// Builds out the different containers on the page
  ///
  /// Requires [parkingLotNumber], [parkingPrice], [parkingLocation], [paymentStatus], [paymentColor] and [parkingLotData].
  /// The parkingLotData will be used when updating and deleting parking lots.
  Widget buildParkingContainer({
    String parkingLotName,
    String parkingPrice,
    String parkingLocation,
    String paymentStatus,
    Color paymentColor,
    dynamic parkingLotData,
  }) {
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
                  parkingLotName ?? '',
                  style: globals.buildTextStyle(15.5, true, Colors.blue[400]),
                ),
                Text(
                  parkingPrice ?? '',
                  style: globals.buildTextStyle(16.0, true, globals.textColor),
                )
              ],
            ),
          ),
          SizedBox(height: 7.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              parkingLocation ?? '',
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
                        userRole == 'user'
                            ? '$parkingPrice - $paymentStatus'
                            : paymentStatus,
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
                : _deleteParkingLot(parkingLotData)
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
