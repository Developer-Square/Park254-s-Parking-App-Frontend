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
          style: TextStyle(color: Colors.red),
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
    onSelected: (value) =>
        {value == 1 ? updateVehicles() : deleteVehicles(itemId: id)},
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
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: Hero(
                    tag: widget.profileImgPath,
                    child: Image(
                      height: 60.0,
                      width: 60.0,
                      fit: BoxFit.cover,
                      image: AssetImage(widget.profileImgPath),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Text(
                  fullNameController.text == ''
                      ? 'User'
                      : fullNameController.text,
                  style: globals.buildTextStyle(16.0, true, globals.textColor),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Builds out the card widget.
///
/// Requires a [card] variable.
Widget buildCardDetails() {
  return Row(
    children: [
      buildDots(false),
      SizedBox(width: 10.0),
      buildDots(false),
      SizedBox(width: 10.0),
      buildDots(false),
      SizedBox(width: 10.0),
      buildDots(true),
    ],
  );
}

/// Builds out the wallet section
///
/// Requires [logo] and [card] variables.
Widget buildWalletItem(logo) {
  return Row(children: <Widget>[
    SvgPicture.asset(
      logo,
      color: Colors.grey,
      width: 40.0,
    ),
    SizedBox(width: 15.0),
    buildDots(false),
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
                ? buildWalletItem(logo)
                : buildVehicleItem(carPlate: carPlate),
            type == 'wallet'
                ? Container()
                : profilePopUpMenu(
                    id: id,
                    updateVehicles: () {},
                    deleteVehicles: deleteVehicles,
                  )
          ],
        ),
      ));
}

/// Returns dots or numbers.
Widget buildDots(number) {
  return Text(
    '● ● ● ● ● ● 7328',
    style: globals.buildTextStyle(16.0, true, Colors.black),
  );
}
