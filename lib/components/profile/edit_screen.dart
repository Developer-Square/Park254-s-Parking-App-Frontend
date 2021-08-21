import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/users/updateUser.dart';
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

  EditScreen({
    this.profileImgPath,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    @required this.currentScreen,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController vehicleTypeController = new TextEditingController();
  TextEditingController vehiclePlateController = new TextEditingController();
  FlutterSecureStorage userDetails = new FlutterSecureStorage();
  bool showLoader;
  bool showToolTip;
  String text;
  // User's details from the store.
  UserWithTokenModel storeDetails;

  initState() {
    super.initState();
    showLoader = false;
    storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
    if (widget.currentScreen == 'vehicles') {
      vehicleTypeController.text = storeDetails.user.user.vehicles[0].model;
      vehiclePlateController.text = storeDetails.user.user.vehicles[0].plate;
    }
  }

  hideToolTip() {
    showToolTip = false;
  }

  updateProfile() async {
    setState(() {
      showLoader = true;
    });
    var accessToken = storeDetails.user.accessToken.token;
    var userId = storeDetails.user.user.id;
    updateUser(
            token: accessToken,
            userId: userId,
            name: widget.fullName.text,
            email: widget.email.text,
            phone: int.parse(widget.phone.text))
        .then((value) async {
      storeDetails.updateUser(widget.fullName.text, widget.email.text,
          int.parse(widget.phone.text));
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackArrow(),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
          widget.currentScreen == 'profile'
              ? 'Edit Profile'
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
                  ? buildEditProfile(updateProfile)
                  : Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3.1),
                        BuildFormField(
                            text: 'vehicle',
                            label: 'Add vehicle type',
                            placeholder: 'vehicle type',
                            controller: vehicleTypeController),
                        SizedBox(height: 20.0),
                        BuildFormField(
                            text: 'vehicle',
                            label: 'Add vechicle plate',
                            placeholder: 'vehicle plate',
                            controller: vehiclePlateController)
                      ],
                    ),
            ),
          ),
          showLoader ? Loader() : Container()
        ],
      ),
    );
  }

  /// Builds out an edit profile screen
  Widget buildEditProfile(Function updateProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50.0),
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            child: Hero(
                tag: widget.profileImgPath,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.profileImgPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 80.0,
                  width: 80.0,
                ))),
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
        Text(
          'Do you want to top up your balance ?',
          style: globals.buildTextStyle(16.0, true, globals.backgroundColor),
        ),
        SizedBox(
          height: 55.0,
        ),
        InkWell(
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
                'Save Edits',
                style: globals.buildTextStyle(18.0, true, globals.textColor),
              )),
            ))
      ],
    );
  }
}
