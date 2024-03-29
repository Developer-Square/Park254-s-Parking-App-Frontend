import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/dataModels/VehicleModel.dart';
import 'package:park254_s_parking_app/functions/users/updateUser.dart';
import 'package:park254_s_parking_app/functions/vehicles/createVehicle.dart';
import 'package:park254_s_parking_app/functions/vehicles/updateVehicle.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import 'package:provider/provider.dart';
import '../../config/globals.dart' as globals;

/// Creates a dynamic edit screen page for user profiles and adding vehicles.
///
/// Requires [currentScreen].
class EditScreen extends StatefulWidget {
  final profileImgPath;
  final fullName;
  final email;
  final phone;
  final password;
  final currentScreen;
  final vehicleTypeController;
  final vehiclePlateController;
  final String vehicleStatus;
  final String vehicleId;

  EditScreen({
    this.profileImgPath,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    @required this.currentScreen,
    this.vehiclePlateController,
    this.vehicleTypeController,
    this.vehicleStatus,
    this.vehicleId,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool showLoader;
  bool showToolTip;
  String text;
  // User's details from the store.
  UserWithTokenModel storeDetails;
  VehicleModel vehicleDetails;

  initState() {
    super.initState();
    showLoader = false;
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      vehicleDetails = Provider.of<VehicleModel>(context, listen: false);
    }
  }

  void clearFields() {
    setState(() {
      widget.fullName.text = '';
      widget.email.text = '';
      widget.phone.text = '';
      widget.password.text = '';
      widget.vehicleTypeController.text = '';
      widget.vehiclePlateController.text = '';
    });
  }

  updateProfile() async {
    setState(() {
      showLoader = true;
    });
    var accessToken = storeDetails.user.accessToken.token;
    var userId = storeDetails.user.user.id;

    // Add the new vehicle or update an existing vehicle.
    if (widget.currentScreen != 'profile' &&
        widget.vehiclePlateController != '' &&
        widget.vehicleTypeController != '') {
      if (widget.vehicleStatus != 'vehicleUpdate') {
        createVehicle(
                token: accessToken,
                owner: userId,
                plate: widget.vehiclePlateController.text,
                model: widget.vehicleTypeController.text)
            .then((value) {
          clearFields();
          setState(() {
            showLoader = false;
          });
          // Add the new vehicle to the store.
          if (vehicleDetails != null) {
            vehicleDetails.add(vehicle: value);
          }

          buildNotification('Vehicle added successfully', 'success');
          Navigator.pop(context);
        }).catchError((err) {
          setState(() {
            showLoader = false;
          });
          log('In editScreen.dart, createVehicle function');
          log(err.toString());
          buildNotification(err.message, 'error');
        });
      } else {
        updateVehicle(
          token: accessToken,
          vehicleId: widget.vehicleId,
          model: widget.vehicleTypeController.text,
          plate: widget.vehiclePlateController.text,
          owner: userId,
        ).then((value) {
          // Update the vehicle in the store.
          if (vehicleDetails != null) {
            vehicleDetails.updateVehicle(vehicle: value);
          }

          buildNotification('Vehicle updated successfully', 'success');
          setState(() {
            showLoader = false;
          });
          Navigator.pop(context);
        }).catchError((err) {
          setState(() {
            showLoader = false;
          });
          log('In editScreen.dart, updateVehicle function');
          log(err.toString());
          buildNotification(err.message, 'error');
        });
      }
    } else {
      updateUser(
        token: accessToken,
        userId: userId,
        name: widget.fullName.text,
        email: widget.email.text,
        phone: int.parse(widget.phone.text),
      ).then((value) async {
        storeDetails.updateUser(
          widget.fullName.text,
          widget.email.text,
          int.parse(widget.phone.text),
        );

        clearFields();
        setState(() {
          showLoader = false;
        });

        buildNotification('Profile updated successfully.', 'success');
        Navigator.pop(context);
      }).catchError((err) {
        setState(() {
          showLoader = false;
        });
        log('In editScreen.dart');
        log(err.toString());
        buildNotification(err.message, 'error');
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackArrow(
          clearFields: () {},
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
          widget.currentScreen == 'profile'
              ? 'Edit Profile'
              : widget.vehicleStatus == 'vehicleUpdate'
                  ? 'Update Vehicle'
                  : 'Add New Vehicle',
          style: globals.buildTextStyle(18.0, true, globals.textColor),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: widget.currentScreen == 'profile'
                  ? buildEditProfile()
                  : Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3.1),
                        BuildFormField(
                            text: 'vehicle',
                            label: 'Add vehicle type',
                            placeholder: 'vehicle type',
                            controller: widget.vehicleTypeController),
                        SizedBox(height: 20.0),
                        BuildFormField(
                            text: 'vehicle',
                            label: 'Add vechicle plate',
                            placeholder: 'vehicle plate',
                            controller: widget.vehiclePlateController),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 10.0),
                        buildSubmitButton(type: 'vehicle')
                      ],
                    ),
            ),
          ),
          showLoader ? Loader() : Container()
        ],
      ),
    );
  }

  /// Builds out an edit profile screen.
  Widget buildEditProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50.0),
        CircleAvatar(
            radius: 49,
            backgroundColor: globals.randomColorGenerator() != null
                ? globals.randomColorGenerator()
                : globals.profile3,
            child: Text(
              widget.fullName.text.length > 1
                  ? widget.fullName.text.substring(0, 1).toUpperCase()
                  : '',
              style: globals.buildTextStyle(53, true, globals.textColor),
            )),
        SizedBox(height: 40.0),
        BuildFormField(
            text: 'Profile',
            label: 'Full name',
            placeholder: 'Ken Smith',
            controller: widget.fullName),
        SizedBox(height: 20.0),
        BuildFormField(
            text: 'Profile',
            label: 'Email',
            placeholder: 'test@gmail.com',
            controller: widget.email),
        SizedBox(height: 20.0),
        BuildFormField(
            text: 'International Number',
            label: '',
            placeholder: '789876078',
            controller: widget.phone),
        SizedBox(height: 20.0),
        SizedBox(height: 40.0),
        SizedBox(
          height: 55.0,
        ),
        buildSubmitButton(type: 'profile')
      ],
    );
  }

  Widget buildSubmitButton({@required String type}) {
    return InkWell(
        onTap: () {
          updateProfile();
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 30.0,
          height: 53.0,
          decoration: BoxDecoration(
              color: globals.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(35.0))),
          child: Center(
              child: Text(
            type == 'profile'
                ? 'Save Edits'
                : widget.vehicleStatus == 'vehicleUpdate'
                    ? 'Update Vehicle'
                    : 'Add Vehicle',
            style: globals.buildTextStyle(18.0, true, globals.textColor),
          )),
        ));
  }
}
