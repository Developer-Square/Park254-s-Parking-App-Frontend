import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:park254_s_parking_app/dataModels/ParkingLotListModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/cloudinary/upload_images.dart';
import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/updateParkingLot.dart';

import '../../helper_functions.dart';

createUpdateParkingLots({
  List links,
  UserWithTokenModel storeDetails,
  List backendImages,
  ParkingLotListModel parkingLotList,
  String address,
  String city,
  String currentScreen,
  String name,
  String spaces,
  String prices,
  Function setLoader,
  BuildContext context,
  Function clearFields,
  dynamic parkingData,
}) async {
  // Combine the newly added images with the old ones.
  var updatedImages = links + backendImages;
  var accessToken = storeDetails.user.accessToken.token;
  var userId = storeDetails.user.user.id;
  // Get the coordinates of the address the user entered.
  List<dynamic> locations = await locationFromAddress(address + ', ' + city);

  setLoader(true);
  if (currentScreen == 'create') {
    createParkingLot(
            token: accessToken,
            owner: userId,
            name: name,
            spaces: int.parse(spaces),
            images: links,
            price: int.parse(prices),
            address: address,
            city: city,
            latitude: locations[0].latitude,
            longitude: locations[0].longitude)
        .then((value) {
      buildNotification('Parking lot created successfully', 'success');
      if (parkingLotList != null) {
        parkingLotList.add(parkingLot: value);
      }
      setLoader(false);
      clearFields();
      Navigator.of(context).pop();
    }).catchError((err) {
      setLoader(false);

      log("In create_update_parking_lot");
      log(err.toString());
      buildNotification(err.message, 'error');
    });
  } else if (currentScreen == 'update') {
    setLoader(true);

    // ToDo: Add a way to check if the values were changed.
    updateParkingLot(
            token: accessToken,
            parkingLotId: parkingData.id,
            spaces: int.parse(spaces),
            price: int.parse(prices),
            address: address,
            images: updatedImages,
            city: city,
            latitude: locations[0].latitude,
            longitude: locations[0].longitude)
        .then((value) {
      buildNotification('Parking lot updated successfully', 'success');
      setLoader(false);

      if (parkingLotList != null) {
        parkingLotList.updateParkingLot(value);
      }
      clearFields();
      Navigator.of(context).pop();
    }).catchError((err) {
      setLoader(false);

      log("In create_update_parking_lot");
      log(err.toString());
      buildNotification(err.toString(), 'error');
    });
  }
}

createUpdateParking({
  List links,
  UserWithTokenModel storeDetails,
  List backendImages,
  ParkingLotListModel parkingLotList,
  String address,
  String city,
  String currentScreen,
  String name,
  String spaces,
  String prices,
  Function setLoader,
  BuildContext context,
  Function clearFields,
  dynamic parkingData,
  List imagesToSend,
}) async {
  // Links to send to the backend.
  var cloudinaryLinks = [];
  // Make a fixed list from the imagesToSend array so that we can use its values as indexes.
  final List fixedList = Iterable<int>.generate(imagesToSend.length).toList();
  setLoader(true);
  if (imagesToSend.length != 0) {
    fixedList.map((index) {
      // Make sure that we're not sending images that have already been uploaded.
      if (!imagesToSend[index].contains('https')) {
        // Upload the images to cloudinary.
        uploadImages(imagePath: imagesToSend[index]).then((value) {
          cloudinaryLinks.add(value.secureUrl);

          // check if the map is done.
          if (index == imagesToSend.length - 1) {
            // Call backend api.
            createUpdateParkingLots(
              links: cloudinaryLinks,
              storeDetails: storeDetails,
              setLoader: setLoader,
              backendImages: backendImages,
              parkingData: parkingData,
              parkingLotList: parkingLotList,
              address: address,
              city: city,
              currentScreen: currentScreen,
              name: name,
              spaces: spaces,
              prices: prices,
              context: context,
              clearFields: clearFields,
            );
          }
        }).catchError((err) {
          setLoader(false);
          log(err);
        });
      }
      // If the mapping is done, make sure cloudinaryLinks has some value before updating the backend
      else if (index == imagesToSend.length - 1) {
        createUpdateParkingLots(
          links: cloudinaryLinks,
          storeDetails: storeDetails,
          setLoader: setLoader,
          backendImages: backendImages,
          parkingData: parkingData,
          parkingLotList: parkingLotList,
          address: address,
          city: city,
          currentScreen: currentScreen,
          name: name,
          spaces: spaces,
          prices: prices,
          context: context,
          clearFields: clearFields,
        );
      }
    }).toList();
  } else {
    // For updating the backend with the altered or deleted links.
    createUpdateParkingLots(
      links: cloudinaryLinks,
      storeDetails: storeDetails,
      setLoader: setLoader,
      backendImages: backendImages,
      parkingData: parkingData,
      parkingLotList: parkingLotList,
      address: address,
      city: city,
      currentScreen: currentScreen,
      name: name,
      spaces: spaces,
      prices: prices,
      context: context,
      clearFields: clearFields,
    );
  }
}
