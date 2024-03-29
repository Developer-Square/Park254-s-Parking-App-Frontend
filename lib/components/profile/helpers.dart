import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import '../../config/globals.dart' as globals;

/// Builds out the pop-up that appears when you click on the three dots.
/// that comes with every parking lot.
Widget profilePopUpMenu({
  @required String id,
  @required Function updateVehicles,
  @required Function deleteVehicles,
}) {
  return PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text(
          'Update',
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          'Delete',
          style: TextStyle(color: Colors.red),
        ),
      )
    ],
    onSelected: (value) => {
      value == 1 ? updateVehicles(vehicleId: id) : deleteVehicles(itemId: id)
    },
    icon: Icon(
      Icons.more_vert,
      color: globals.textColor,
    ),
    offset: Offset(0, 100),
  );
}

/// Builds out the profile tab at the top of the page.
Widget buildProfileTab(context, widget, fullNameController, balance) {
  return Center(
    child: Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width - 40.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 49,
                  backgroundColor: globals.randomColorGenerator(),
                  child: Text(
                    fullNameController.text.substring(0, 1).toUpperCase(),
                    style: globals.buildTextStyle(53, true, globals.textColor),
                  ),
                ),
                SizedBox(width: 10.0),
                Center(
                  child: Text(
                    fullNameController.text == ''
                        ? 'User'
                        : fullNameController.text,
                    style:
                        globals.buildTextStyle(16.0, true, globals.textColor),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Builds out the wallet section
///
/// Requires [logo] and [phone number] variables.
Widget buildWalletItem({String logo, String phonenumber}) {
  return Row(children: <Widget>[
    SvgPicture.asset(
      logo,
      color: Colors.grey,
      width: 40.0,
    ),
    SizedBox(width: 15.0),
    phonenumber.length < 9
        ? Text(
            'No Phonenumber.',
            style: globals.buildTextStyle(16.0, true, globals.textColor),
          )
        : buildDots(phonenumber: phonenumber),
    SizedBox(width: 10.0),
  ]);
}

/// Builds out the vehicle section.
Widget buildVehicleItem({String carPlate}) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          carPlate,
          style: globals.buildTextStyle(16.0, true, globals.textColor),
        ),
      ],
    ),
  );
}

/// Builds out the different containers on the page e.g. the vehicle container.
///
/// Requires the [logo], [card] and [type] variables.
Widget buildContainer({
  String logo,
  String type,
  String carPlate,
  String carModel,
  Function updateVehicles,
  Function deleteVehicles,
  String id,
  String phoneNumber,
}) {
  return BoxShadowWrapper(
      offsetY: 0.0,
      offsetX: 0.0,
      blurRadius: 4.0,
      opacity: 0.6,
      height: 60.0,
      content: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            type == 'wallet'
                ? buildWalletItem(logo: logo, phonenumber: phoneNumber)
                : buildVehicleItem(carPlate: carPlate),
            type == 'wallet'
                ? Container()
                : profilePopUpMenu(
                    id: id,
                    updateVehicles: updateVehicles,
                    deleteVehicles: deleteVehicles,
                  )
          ],
        ),
      ));
}

/// Returns dots or numbers.
Widget buildDots({String phonenumber}) {
  int len = phonenumber.length;
  return Text(
    '● ● ● ● ● ● ${phonenumber.substring(len - 4)}',
    style: globals.buildTextStyle(16.0, true, Colors.black),
  );
}
