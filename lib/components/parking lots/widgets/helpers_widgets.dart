import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import 'package:park254_s_parking_app/dataModels/BookingProvider.dart';
import 'package:park254_s_parking_app/models/booking.populated.model.dart';
import '../../../config/globals.dart' as globals;
import '../../BackArrow.dart';
import '../../BoxShadowWrapper.dart';
import '../ParkingInfo.dart';
import 'helper_functions.dart';

/// Builds out the info details displayed in the modalBottomSheet.
///
Widget infoDetails({String key, String value}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          '$key',
          style: globals.buildTextStyle(15.0, true, globals.textColor),
        ),
        Text('$value')
      ],
    ),
  );
}

/// Builds out the bottom sheet modal.
///
/// This modal displays all the necessary details from the QR Code.
Future<dynamic> showBottomModal({
  @required BuildContext context,
  @required BookingDetailsPopulated bookingsDetails,
  @required String numberPlate,
  @required String model,
}) {
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 25.0, bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              infoDetails(
                  key: 'Parking Lot Name',
                  value: bookingsDetails.parkingLotId.name),
              infoDetails(key: 'Number Plate', value: numberPlate),
              infoDetails(key: 'Model', value: model),
              infoDetails(
                  key: 'Time In',
                  value: timeOfDayToString(bookingsDetails.entryTime)),
              infoDetails(
                  key: 'Time Out',
                  value: timeOfDayToString(bookingsDetails.exitTime)),
              infoDetails(
                  key: 'Client Name', value: bookingsDetails.clientId.name)
            ],
          ),
        );
      });
}

/// Builds out all the parking widgets on the page.
///
/// This happens after the parking lots are fetched from the backend.
Widget buildParkingLotResults({
  @required List results,
  @required String userRole,
  @required List parkingLotDetails,
  @required Function timeOfDayToString,
  @required BuildContext context,
  @required BookingProvider bookingDetailsProvider,
  @required Function updateParking,
  @required Function deleteParkingLot,
  @required Function updateParkingTime,
}) {
  return ListView.builder(
    itemCount: results.length,
    itemBuilder: (context, index) {
      return Column(
        children: [
          InkWell(
            child: userRole == 'user'
                ? buildParkingContainer(
                    bookingDetailsProvider: bookingDetailsProvider,
                    userRole: userRole,
                    context: context,
                    parkingLotName: parkingLotDetails != null
                        ? parkingLotDetails[index]['name']
                        : 'Loading...',
                    parkingPrice: timeOfDayToString(results[index].entryTime),
                    parkingLocation: parkingLotDetails != null
                        ? parkingLotDetails[index]['address']
                        : 'Loading...',
                    paymentStatus: timeOfDayToString(results[index].exitTime),
                    parkingLotData: parkingLotDetails[index],
                    bookingDetails: results[index],
                    updateParking: updateParking,
                    updateParkingTime: updateParkingTime,
                    deleteParkingLot: deleteParkingLot,
                  )
                : buildParkingContainer(
                    bookingDetailsProvider: bookingDetailsProvider,
                    userRole: userRole,
                    context: context,
                    parkingLotName: results[index].name,
                    parkingPrice: 'Ksh ${results[index].price} / hr',
                    parkingLocation: results[index].address,
                    paymentStatus: 'Parking Slots: ${results[index].spaces}',
                    paymentColor: Colors.white,
                    parkingLotData: results[index],
                    updateParking: updateParking,
                    updateParkingTime: updateParkingTime,
                    deleteParkingLot: deleteParkingLot,
                  ),
            onTap: userRole == 'vendor'
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ParkingInfo(
                          images: results[index].images,
                          name: results[index].name,
                          accessibleParking:
                              results[index].features.accessibleParking,
                          cctv: results[index].features.cctv,
                          carWash: results[index].features.carWash,
                          evCharging: results[index].features.evCharging,
                          valetParking: results[index].features.valetParking,
                          rating: results[index].rating,
                        ),
                      ),
                    );
                  }
                : () {},
          ),
          SizedBox(height: results.length - 1 == index ? 480.0 : 15.0)
        ],
      );
    },
  );
}

/// Builds out a text followed by an icon to be used as a label.
/// for an active or expired booking.
Widget bookingLabel({@required bool active}) {
  return Container(
      child: Row(children: <Widget>[
    Text(active ? 'Active' : 'Expired',
        style: globals.buildTextStyle(16.0, true, globals.textColor)),
    SizedBox(width: 5.0),
    Container(
      width: 14.0,
      height: 14.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: active ? globals.backgroundColor : Colors.red),
    )
  ]));
}

/// Builds out the different containers on the page
///
/// Requires [parkingLotNumber], [parkingPrice], [parkingLocation], [paymentStatus], [paymentColor] and [parkingLotData].
/// The parkingLotData will be used when updating and deleting parking lots.
Widget buildParkingContainer({
  @required String parkingLotName,
  @required String parkingPrice,
  @required String parkingLocation,
  @required String paymentStatus,
  Color paymentColor,
  @required dynamic parkingLotData,
  dynamic bookingDetails,
  @required BuildContext context,
  @required BookingProvider bookingDetailsProvider,
  @required String userRole,
  @required Function updateParking,
  @required Function deleteParkingLot,
  @required Function updateParkingTime,
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
              userRole == 'user'
                  ? bookingDetailsProvider != null
                      ? bookingDetailsProvider.activeBookings
                              .contains(bookingDetails.id)
                          ? bookingLabel(active: true)
                          : bookingLabel(active: false)
                      : bookingLabel(active: false)
                  : Text(
                      parkingPrice ?? '',
                      style:
                          globals.buildTextStyle(15.5, true, globals.textColor),
                    ),
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
                      bottom:
                          BorderSide(color: Colors.black54.withOpacity(0.1)))),
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
                          ? int.parse(parkingPrice.substring(0, 2)) > 11
                              ? '$parkingPrice pm - $paymentStatus pm'
                              : '$parkingPrice am - $paymentStatus am'
                          : paymentStatus,
                      style:
                          globals.buildTextStyle(15.0, true, globals.textColor),
                    ),
                  ],
                ),
                _popUpMenu(
                  data: parkingLotData,
                  bookingDetails: bookingDetails,
                  bookingDetailsProvider: bookingDetailsProvider,
                  userRole: userRole,
                  updateParking: updateParking,
                  updateParkingTime: updateParkingTime,
                  deleteParkingLot: deleteParkingLot,
                )
              ]),
        )
      ]),
    ),
  );
}

Widget _popUpMenu({
  @required dynamic data,
  @required dynamic bookingDetails,
  @required BookingProvider bookingDetailsProvider,
  @required String userRole,
  @required Function updateParking,
  @required Function deleteParkingLot,
  @required Function updateParkingTime,
}) {
  return PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text(userRole == 'vendor'
            ? 'Update'
            : bookingDetailsProvider != null
                ? bookingDetailsProvider.activeBookings
                        .contains(bookingDetails.id)
                    ? 'Update Time'
                    : 'Share Spot'
                : 'Share Spot'),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          userRole == 'vendor'
              ? 'Delete'
              : bookingDetailsProvider != null
                  ? bookingDetailsProvider.activeBookings
                          .contains(bookingDetails.id)
                      ? 'Report an issue'
                      : 'Delete'
                  : 'Delete',
          style: TextStyle(color: Colors.red),
        ),
      )
    ],
    onSelected: (value) => {
      userRole == 'vendor'
          ? value == 1
              ? updateParking(data)
              : deleteParkingLot(data)
          : value == 1 &&
                  bookingDetailsProvider.activeBookings
                      .contains(bookingDetails.id)
              ? updateParkingTime(bookingDetails: bookingDetails)
              : () {}
    },
    icon: Icon(
      Icons.more_vert,
      color: globals.textColor,
    ),
    offset: Offset(0, 100),
  );
}

/// Builds the appbar for the page.
Widget appBar({Function clearFields, String currentScreen}) {
  return AppBar(
    leading: BackArrow(clearFields: clearFields),
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: true,
    title: Text(
      currentScreen != 'create' ? 'Edit Parking Lot' : 'Add New Parking Lot',
      style: globals.buildTextStyle(18.0, true, globals.textColor),
    ),
    elevation: 0.0,
    centerTitle: true,
  );
}

/// Edit image that has already been uploaded.
Widget editUploadedImage(currentScreen, selected, _cropImage, _clear) {
  return Expanded(
    child: Column(
      children: [
        Container(
            height: 145.0,
            child: currentScreen == 'update' ? selected : Image.file(selected)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          // User should not be able to crop an uploaded image.
          currentScreen != 'update'
              ? FlatButton(onPressed: _cropImage, child: Icon(Icons.crop))
              : Container(),
          FlatButton(onPressed: _clear, child: Icon(Icons.close))
        ]),
      ],
    ),
    flex: 7,
  );
}

/// Edit local image from the gallery or new photo.
Widget editLocalImage(currentScreen, displayPicture, _imageFiles) {
  return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          return Row(children: [
            Container(
                child: InkWell(
                    onTap: () {
                      displayPicture(_imageFiles[index], index);
                    },
                    child: currentScreen == 'update'
                        ? _imageFiles[index]
                        : Image.file(_imageFiles[index]))),
            SizedBox(
              width: 8.0,
            )
          ]);
        },
      ),
      flex: 3);
}

/// Builds the take a new photo widget.
Widget buildTakeNewPhoto(Function pickImage) {
  return Expanded(
    child: Container(
      color: Colors.grey[200],
      child: Center(
          child: InkWell(
        onTap: () {
          pickImage(ImageSource.camera);
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Take a new photo'),
              Icon(Icons.add_a_photo)
            ]),
      )),
    ),
    flex: 2,
  );
}

/// Builds the add image from gallery widget.
Widget buildImageFromGallery(Function pickImage) {
  return Expanded(
    child: Container(
      color: Colors.grey[200],
      child: Center(
          child: InkWell(
        onTap: () {
          pickImage(ImageSource.gallery);
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Add photo from gallery'),
              Icon(Icons.add)
            ]),
      )),
    ),
    flex: 2,
  );
}

/// Builds out all the form fields on the page.
Widget buildFields(List fields) {
  return new Column(
      children: fields
          .map(
            (item) => Column(
              children: [
                BuildFormField(
                  text: item['text'],
                  label: item['label'],
                  placeholder: item['placeholder'],
                  controller: item['controller'],
                ),
                SizedBox(height: 18.0)
              ],
            ),
          )
          .toList());
}

Widget helperMessage(text) {
  return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(text,
          style: globals.buildTextStyle(13.0, true, globals.textColor)));
}
