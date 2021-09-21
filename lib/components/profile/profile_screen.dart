import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/profile/edit_screen.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/profile/helpers.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/dataModels/VehicleModel.dart';
import 'package:park254_s_parking_app/functions/auth/logout.dart';
import 'package:park254_s_parking_app/functions/users/updateUser.dart';
import 'package:park254_s_parking_app/functions/vehicles/deleteVehicle.dart';
import 'package:park254_s_parking_app/pages/login_screen.dart';
import 'package:provider/provider.dart';
import '../../config/globals.dart' as globals;
import '../helper_functions.dart';
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';

/// Creates a profile screen.
///
/// Requires [profileImgPath], [logo1Path] and [logo2Path].
/// Updates the edit profile page fields.
class ProfileScreen extends StatefulWidget {
  final profileImgPath;
  final logo1Path;
  final logo2Path;
  Function clearStorage;

  ProfileScreen({
    @required this.profileImgPath,
    @required this.logo1Path,
    @required this.logo2Path,
    this.clearStorage,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController vehicleTypeController = new TextEditingController();
  TextEditingController vehiclePlateController = new TextEditingController();
  bool showLoader;
  String userRole;
  String carPlate = 'KCB 8793K';
  String balance = 'Ksh 2005';
  // User's details from the store.
  UserWithTokenModel storeDetails;
  // Pakring details from the store.
  NearbyParkingListModel nearbyParkingDetails;
  VehicleModel vehicleDetails;
  List vehicles = [];

  @override
  void initState() {
    super.initState();
    showLoader = false;
    if (mounted) {
      vehicleDetails = Provider.of<VehicleModel>(context, listen: false);
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);

      // Fetch the all the vehicles on load.
      if (vehicleDetails != null && storeDetails != null) {
        vehicleDetails.fetch(
          token: storeDetails.user.accessToken.token,
          owner: storeDetails.user.user.id,
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void deleteProfileDetails({@required String itemId}) {
    log(itemId);
    if (storeDetails != null) {
      final String access = storeDetails.user.accessToken.token;

      deleteVehicle(token: access, vehicleId: itemId).then((value) {
        if (vehicleDetails != null) {
          // Remove the vehicle from the store.
          vehicleDetails.remove(id: itemId);
        }
        buildNotification('Vehicle deleted successfully', 'success');
      }).catchError((err) {
        log("In profile_screen.dart, deleteProfileDetails");
        log(err.toString());
        buildNotification(err.message, 'error');
      });
    }
  }

  // Make api call.
  logoutUser() async {
    setState(() {
      showLoader = true;
    });
    var token = storeDetails.user.refreshToken.token;
    logout(refreshToken: token).then((value) {
      if (value == 'success') {
        buildNotification('Logged out successfully', 'success');
        setState(() {
          showLoader = false;
        });
        if (storeDetails != null && nearbyParkingDetails != null) {
          // Clear all the details in the store.
          storeDetails.clear();
          // Clear the details in shared preferences.
          clearStorage();
          nearbyParkingDetails.clear();
        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }).catchError((err) {
      setState(() {
        showLoader = false;
        print("In profile_screen");
        print(err);
        buildNotification(err.message, 'error');
      });
    });
  }

  // Redirect to the edit screen page so that a user can edit the profile.
  pushToEditProfile() {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditScreen(
              profileImgPath: widget.profileImgPath,
              fullName: fullNameController,
              email: emailController,
              phone: phoneController,
              password: passwordController,
              vehiclePlateController: vehiclePlateController,
              vehicleTypeController: vehicleTypeController,
              currentScreen: 'profile',
            )));
  }

  @override
  Widget build(BuildContext context) {
    storeDetails = Provider.of<UserWithTokenModel>(context);
    vehicleDetails = Provider.of<VehicleModel>(context);
    if (storeDetails.user.user != null) {
      fullNameController.text = storeDetails.user.user.name;
      emailController.text = storeDetails.user.user.email;
      phoneController.text = storeDetails.user.user.phone.toString();
      userRole = storeDetails.user.user.role;
    }
    if (vehicleDetails.vehicleData.vehicles != null) {
      setState(() {
        vehicles = vehicleDetails.vehicleData.vehicles;
      });
    }

    return Scaffold(
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Material(
              color: Colors.grey[200],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () => pushToEditProfile(),
                      child: TopPageStyling(
                        currentPage: 'profile',
                        widget: buildProfileTab(
                            context, widget, fullNameController, balance),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Wallet',
                        style: globals.buildTextStyle(
                            18.0, true, globals.textColor),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    buildContainer(logo: widget.logo2Path, type: 'wallet'),
                    SizedBox(height: 50.0),
                    userRole != 'vendor'
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Vehicles',
                                      style: globals.buildTextStyle(
                                          18.0, true, globals.textColor),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditScreen(
                                                      fullName:
                                                          fullNameController,
                                                      email: emailController,
                                                      phone: phoneController,
                                                      password:
                                                          passwordController,
                                                      vehiclePlateController:
                                                          vehiclePlateController,
                                                      vehicleTypeController:
                                                          vehicleTypeController,
                                                      currentScreen: 'vehicles',
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
                                  ],
                                ),
                                SizedBox(height: 25.0),
                                vehicles.length > 0
                                    ? Column(
                                        children: vehicles
                                            .map((vehicle) =>
                                                Column(children: <Widget>[
                                                  buildContainer(
                                                    type: 'vehicles',
                                                    carModel: vehicle.model,
                                                    carPlate: vehicle.plate,
                                                    deleteVehicles:
                                                        deleteProfileDetails,
                                                    id: vehicle.id,
                                                  ),
                                                  SizedBox(
                                                    height: 2.0,
                                                  )
                                                ]))
                                            .toList())
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 25.0),
                    SizedBox(height: 20.0),
                    Center(
                      child: InkWell(
                        onTap: () {
                          logoutUser();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                color: Colors.red[400]),
                            child: Center(
                                child: Text(
                              'Logout',
                              style: globals.buildTextStyle(
                                  15.0, true, Colors.white),
                            ))),
                      ),
                    ),
                    SizedBox(height: 80.0)
                  ])),
        ),
        showLoader ? Loader() : Container()
      ]),
    );
  }
}
