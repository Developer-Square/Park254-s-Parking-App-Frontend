import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import '../config/globals.dart' as globals;

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

  EditScreen(
      {this.profileImgPath,
      this.fullName,
      this.email,
      this.phone,
      this.password,
      @required this.currentScreen});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController vehicleTypeController = new TextEditingController();
  TextEditingController vehiclePlateController = new TextEditingController();
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
      body: SingleChildScrollView(
        child: Center(
          child: widget.currentScreen == 'profile'
              ? buildEditProfile()
              : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 3.1),
                    buildFormField('vehicle', 'Add vehicle type',
                        'vehicle type', vehicleTypeController),
                    SizedBox(height: 20.0),
                    buildFormField('vehicle', 'Add vechicle plate',
                        'vehicle plate', vehiclePlateController)
                  ],
                ),
        ),
      ),
    );
  }

  /// Builds out an edit profile screen
  Widget buildEditProfile() {
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
        buildFormField('Profile', 'Full name', 'Ken Smith', widget.fullName),
        SizedBox(height: 20.0),
        buildFormField('Profile', 'Email', 'test@gmail.com', widget.email),
        SizedBox(height: 20.0),
        buildFormField('International Number', '', '789876078', widget.phone),
        SizedBox(height: 20.0),
        buildFormField('Profile', 'Password', 'Password', widget.password),
        SizedBox(height: 40.0),
        Text(
          'Do you want to top up your balance ?',
          style: globals.buildTextStyle(16.0, true, globals.backgroundColor),
        ),
        SizedBox(
          height: 55.0,
        ),
        InkWell(
            onTap: () {},
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
