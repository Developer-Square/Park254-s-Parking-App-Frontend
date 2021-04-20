import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/CustomFloatingActionButton.dart';
import 'package:park254_s_parking_app/components/DismissKeyboard.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/components/SimpleTextField.dart';
import 'package:park254_s_parking_app/components/Snap.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

class RegisterParking extends StatefulWidget {
  @override
  _RegisterParkingState createState() => _RegisterParkingState();
}

class _RegisterParkingState extends State<RegisterParking> {
  String parkingLot;
  int spaces;
  Future<Position> location;
  bool showCamera = false;

  void _toggleCamera(){
    setState(() {
      showCamera = !showCamera;
    });
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget _customTextField(String hintText, TextInputType keyboardType){
    return SimpleTextField(
      textColor: globals.textColor,
      decorate: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        border: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: Colors.black54,
          ),
        ),
      ),
      alignLeft: true,
      keyboardType: keyboardType,
    );
  }

  Widget _addPhotos(){
    return CustomFloatingActionButton(
      onPressed: () => _toggleCamera(),
      label: showCamera ? 'Finish' : 'Add Photos',
      heroTag: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return DismissKeyboard(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: PrimaryText(content: 'Register Parking',),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            leading: BackArrow(),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: width/10, right: width/10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _customTextField("Parking lot name", TextInputType.text),
                    SizedBox(height: 20,),
                    _customTextField("Number of spaces", TextInputType.number),
                  ],
                ),
              ),
              showCamera ? Snap() : Container(),
            ],
          ),
          floatingActionButton: showCamera ? _addPhotos() : Padding(
            padding: EdgeInsets.only(left: width/12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _addPhotos(),
                CustomFloatingActionButton(
                  onPressed: () => {},
                  label: 'Register',
                  heroTag: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}