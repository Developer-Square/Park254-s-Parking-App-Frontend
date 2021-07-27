import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import '../../config/globals.dart' as globals;

/// Builds out the card widget.
///
/// Requires a [card] variable.
Widget buildCardDetails(card) {
  return Row(
    children: [
      buildDots(false, card),
      SizedBox(width: 10.0),
      buildDots(false, card),
      SizedBox(width: 10.0),
      buildDots(false, card),
      SizedBox(width: 10.0),
      buildDots(true, card),
    ],
  );
}

/// Builds out the wallet section
///
/// Requires [logo] and [card] variables.
Widget buildWalletItem(logo, card) {
  return Row(children: <Widget>[
    SvgPicture.asset(
      logo,
      color: Colors.grey,
      width: 40.0,
    ),
    SizedBox(width: 15.0),
    card ? (buildCardDetails(card)) : (buildDots(false, card)),
    SizedBox(width: 10.0),
  ]);
}

/// Builds out the vehicle section.
Widget buildVehicleItem(carPlate) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'BMW',
          style: globals.buildTextStyle(16.0, true, globals.textColor),
        ),
        Text(
          carPlate,
          style: globals.buildTextStyle(16.0, true, globals.textColor),
        )
      ],
    ),
  );
}

/// Builds out the different containers on the page e.g. the vehicle container.
///
/// Requires the [logo], [card] and [type] variables.
Widget buildContainer(logo, card, type, carPlate) {
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
          children: <Widget>[
            type == 'wallet'
                ? buildWalletItem(logo, card)
                : buildVehicleItem(carPlate)
          ],
        ),
      ));
}

/// Returns dots or numbers.
Widget buildDots(number, card) {
  return Text(
    //If it's  card display card details else display phone details.
    card
        ? number
            ? '4567'
            : '● ● ● ●'
        : '● ● ● ● ● ● 7328',
    style: globals.buildTextStyle(16.0, true, Colors.black),
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
            Text(
              balance,
              textAlign: TextAlign.right,
              style: globals.buildTextStyle(16.0, true, globals.textColor),
            )
          ],
        ),
      ),
    ),
  );
}
