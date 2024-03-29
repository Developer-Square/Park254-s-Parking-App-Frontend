import 'dart:convert';
import 'dart:developer';
import 'dart:math' as dartMath;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:park254_s_parking_app/components/booking/Booking.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/parking%20lots/ParkingInfo.dart';
import 'package:park254_s_parking_app/components/parking%20lots/create_update_parking_lot.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/parking%20lots/widgets/helper_functions.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/dataModels/BookingProvider.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:park254_s_parking_app/dataModels/UserModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/bookings/getBookingById.dart';
import 'package:park254_s_parking_app/functions/bookings/getBookings.dart';
import 'package:park254_s_parking_app/functions/parkingLots/deleteParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLotById.dart';
import 'package:park254_s_parking_app/dataModels/ParkingLotListModel.dart';
import 'package:park254_s_parking_app/functions/utils/getRandomNumber.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'package:park254_s_parking_app/models/booking.populated.model.dart';
import 'package:provider/provider.dart';
import '../../config/globals.dart' as globals;
import '../helper_functions.dart';
import './widgets/helpers_widgets.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

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
  BookingProvider bookingDetailsProvider;
  NavigationProvider navigationDetails;
  // Used when we are fetching details for individual parking lots.
  List activeBookings = [];
  UserModel userModel;
  List<dynamic> bookingDetailsList;
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController spacesController = new TextEditingController();
  TextEditingController pricesController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  // Local timezone.
  DateTime entryTime;
  DateTime exitTime;
  String barcode = '';

  @override
  void initState() {
    super.initState();
    showLoader = false;

    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      parkingLotList = Provider.of<ParkingLotListModel>(context, listen: false);
      userModel = Provider.of<UserModel>(context, listen: false);
      bookingDetailsProvider =
          Provider.of<BookingProvider>(context, listen: false);
      navigationDetails =
          Provider.of<NavigationProvider>(context, listen: false);
      // Reset the navigation details when moving back to the home and parking pages.
      if (navigationDetails != null) {
        navigationDetails.clear();
      }
      userRole = storeDetails.user.user.role;
      accessToken = storeDetails.user.accessToken.token;
      userId = storeDetails.user.user.id;
      // Get all the parking lots if the current user is a vendor.
      getParkingDetails();
      // If the current user is a normal user fetch their parkingLots history.
      if (bookingDetailsProvider != null) {
        if (bookingDetailsProvider.bookingDetails == null ||
            bookingDetailsProvider.update) {
          if (userRole == 'user') {
            fetchParkingLotHistory(access: accessToken, userId: userId);
          }
        }
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
    getBookings(token: access, clientId: userId, sortBy: 'entryTime:desc')
        .then((value) {
      DateTime currentDate = DateTime.now().toLocal();
      TimeOfDay currentTime = TimeOfDay.now();
      int index = 0;
      // If the user doesn't have any bookings, send an empty array to the store.
      // This is so that the myparking page isn't always in a loading state.
      if (value.bookingDetailsList.length > 0) {
        // Get parking lot details i.e. names, ratings etc.
        value.bookingDetailsList.forEach((element) {
          // Keep track of the iterations.
          var localExitTime = element.exitTime.toLocal();
          index += 1;
          // Check for the active bookings.
          Duration days = localExitTime.difference(currentDate);
          TimeOfDay exitTime = TimeOfDay.fromDateTime(localExitTime);
          double totalTime = (exitTime.hour + (exitTime.minute / 60)) -
              (currentTime.hour + (currentTime.minute / 60));

          if (double.parse(days.inHours.toString()) >= 0 && totalTime >= 0) {
            _getParkingLotsInfo(value: value, index: index);
            // Add the booking id for active bookings.
            activeBookings.add(element.id);
          } else {
            _getParkingLotsInfo(value: value, index: index);
          }
        });
      } else {
        bookingDetailsProvider.setUpdate(value: false);
        bookingDetailsProvider.setBookingDetails(value: [], bookings: []);
      }
    }).catchError((err) {
      log("In fetchParkingLotHistory, myparking_screen");
      log(err.toString());
      buildNotification(err.message, 'error');
    });
  }

  void _getParkingLotsInfo({
    @required value,
    @required int index,
  }) {
    // Set the booking details to the store to avoid needless re-fetching.
    if (bookingDetailsProvider != null) {
      if (value.bookingDetailsList.length == index) {
        bookingDetailsProvider.setUpdate(value: false);
        bookingDetailsProvider.setBookingDetails(
            value: value.bookingDetailsList, bookings: activeBookings);
      }
    }
  }

  void _updateParkingTime({dynamic bookingDetails}) {
    final parkingLotDetails =
        bookingDetailsProvider.bookingDetails[0].parkingLotId;
    bookingDetailsProvider.setUpdate(value: true);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Booking(
              destination: parkingLotDetails.name,
              address: parkingLotDetails.address,
              imagePath: parkingLotDetails.images[0],
              price: 1,
              bookingNumber: getRandomNumber(),
              parkingLotNumber: getRandomNumber(),
              entryDate: bookingDetails.entryTime,
              exitDate: bookingDetails.exitTime,
            )));
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

  showHideLoader({bool value}) {
    setState(() {
      showLoader = value;
    });
  }

  setBarCode({String value}) {
    setState(() {
      barcode = value;
    });
  }

  Widget build(BuildContext context) {
    parkingLotList = Provider.of<ParkingLotListModel>(context);
    bookingDetailsProvider = Provider.of<BookingProvider>(context);
    if (parkingLotList.parkingLotList.parkingLots != null) {
      var availableParkingLots = parkingLotList.parkingLotList.parkingLots;
      parkingLotsResults = availableParkingLots;
    }

    // Get the booking data from the store.
    if (bookingDetailsProvider != null) {
      setState(() {
        bookingDetailsList = bookingDetailsProvider.bookingDetails;
      });
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
                          currentPage: 'myparking', widget: Container()),
                      SizedBox(height: 20.0),
                      userRole == 'vendor'
                          ? Align(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton.extended(
                                backgroundColor: globals.backgroundColor,
                                heroTag: 'scanQrCode',
                                onPressed: () => scan(
                                  storeDetails: storeDetails,
                                  context: context,
                                  showHideLoader: showHideLoader,
                                  setBarCode: setBarCode,
                                ),
                                label: Text('Scan QR Code'),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 15.0),
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
                          userRole == 'vendor'
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (userModel != null) {
                                        userModel.setCurrentScreen('create');
                                      }
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateUpdateParkingLot(
                                                      currentScreen: 'create',
                                                      name: fullNameController,
                                                      spaces: spacesController,
                                                      prices: pricesController,
                                                      address:
                                                          addressController,
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
                                )
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Stack(children: <Widget>[
                        userRole == 'vendor' && parkingLotsResults != null
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: buildParkingLotResults(
                                  userRole: userRole,
                                  results: parkingLotsResults,
                                  updateParking: _updateParking,
                                  updateParkingTime: _updateParkingTime,
                                  deleteParkingLot: _deleteParkingLot,
                                  bookingDetailsProvider:
                                      bookingDetailsProvider,
                                  context: context,
                                ))
                            : userRole == 'user' && bookingDetailsList != null
                                ? bookingDetailsList.length > 0
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: buildParkingLotResults(
                                          userRole: userRole,
                                          results: bookingDetailsList,
                                          updateParking: _updateParking,
                                          updateParkingTime: _updateParkingTime,
                                          deleteParkingLot: _deleteParkingLot,
                                          bookingDetailsProvider:
                                              bookingDetailsProvider,
                                          context: context,
                                        ))
                                    : Center(
                                        child: Text(
                                        'No Parking Results',
                                        style: globals.buildTextStyle(
                                            17.0, true, Colors.grey),
                                      ))
                                : Center(
                                    child: Text(
                                    'Loading....',
                                    style: globals.buildTextStyle(
                                        17.0, true, Colors.grey),
                                  )),
                      ]),
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
}
