import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/Image_loader.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/cloudinary/upload_images.dart';
import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:park254_s_parking_app/functions/parkingLots/updateParkingLot.dart';
import 'package:provider/provider.dart';
import '../../config/globals.dart' as globals;
import 'widgets/helpers.dart';

/// Builds a page where vendors can create or update their parking lots.

class CreateUpdateParkingLot extends StatefulWidget {
  TextEditingController name;
  TextEditingController spaces;
  TextEditingController prices;
  TextEditingController address;
  TextEditingController city;
  final currentScreen;
  final parkingData;
  Function getParkingDetails;

  CreateUpdateParkingLot(
      {@required this.name,
      @required this.spaces,
      @required this.prices,
      @required this.address,
      @required this.city,
      @required this.getParkingDetails,
      this.currentScreen,
      this.parkingData});
  @override
  _CreateUpdateParkingLotState createState() => _CreateUpdateParkingLotState();
}

class _CreateUpdateParkingLotState extends State<CreateUpdateParkingLot> {
  /// We are storing the images twice because inorder to display the images.
  /// need to put them in [File] format while sending them to cloudinary requires.
  /// them to be [String] format.
  // Intial images links in the backend.
  final List _backendImages = [];
  // Active image files to be displayed to the user.
  var _imageFiles = [];
  // Image files to be sent to cloudinary.
  var _imagesToSend = [];
  // Set the links parameter to an empty array as its default value.
  static const linksParam = [];
  // Used when selecting which image to remove or crop.
  var selected;
  var index;
  bool showLoader;
  final picker = ImagePicker();
  var fields;
  // User's details from the store.
  UserWithTokenModel storeDetails;

  initState() {
    super.initState();
    showLoader = false;
    storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);

    if (widget.currentScreen == 'update') {
      // Add all the links to the cloudinary images so that we can display them.
      widget.parkingData.images.forEach((image) {
        // The list of backend images will be merged when into the cloudinaryLinks list
        // for updating in the createUpdateParkingLots function.
        _backendImages.add(image);
        _imagesToSend.add(image);
        // Get the images from cloudinary and indicate progress while retrieving them.
        _imageFiles.add(Image.network(
          image,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return imageLoader(loadingProgress);
          },
        ));
      });
    }
  }

  // Select an image via gallery or camera.
  Future<void> pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (selected != null) {
        // If it's an update then add the image.file so that it can be displayed.
        if (widget.currentScreen == 'update') {
          _imageFiles.add(Image.file(File(selected.path)));
        } else {
          _imageFiles.add(File(selected.path));
        }
        _imagesToSend.add(selected.path);
      } else {
        print('No image selected.');
      }
    });
  }

// Allows the user to crop the image.
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: selected.path,
    );

    // If the image was changed set the new value to state otherwise.
    // retain the old value.
    setState(() {
      _imageFiles[index] = cropped.path ?? selected.path;
      _imagesToSend[index] = cropped.path ?? selected.path;
    });
  }

  // Clear the image.
  void _clear() {
    setState(() {
      _imageFiles.remove(selected);
      _imagesToSend.removeAt(index);
      selected = null;
      // ToDo: Add a way to delete images from cloudinary.
    });
  }

  displayPicture(pic, picIndex) {
    setState(() {
      selected = pic;
      index = picIndex;
    });
  }

  clearFields() {
    setState(() {
      widget.name.text = '';
      widget.spaces.text = '';
      widget.prices.text = '';
      widget.address.text = '';
      widget.city.text = '';
    });
  }

  createUpdateParkingLots([links = linksParam]) async {
    // Combine the newly added images with the old ones.
    var updatedImages = links + _backendImages;
    var accessToken = storeDetails.user.accessToken.token;
    var userId = storeDetails.user.user.id;
    // Get the coordinates of the address the user entered.
    // Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
    List<dynamic> locations = await locationFromAddress(
        widget.address.text + ', ' + widget.city.text);

    setState(() {
      showLoader = false;
    });
    if (widget.currentScreen == 'create') {
      createParkingLot(
              token: accessToken,
              owner: userId,
              name: widget.name.text,
              spaces: int.parse(widget.spaces.text),
              images: links,
              price: int.parse(widget.prices.text),
              address: widget.address.text,
              city: widget.city.text,
              latitude: locations[0].latitude,
              longitude: locations[0].longitude)
          .then((value) {
        buildNotification('Parking lot created successfully', 'success');
        // Retrieve the new details from the backend.
        widget.getParkingDetails();
        setState(() {
          showLoader = false;
        });
        clearFields();
        Navigator.of(context).pop();
      }).catchError((err) {
        buildNotification(err.message, 'error');
        setState(() {
          showLoader = false;
        });
        print("In create_update_parking_lot");
        print(err);
      });
    } else if (widget.currentScreen == 'update') {
      setState(() {
        showLoader = true;
      });
      // ToDo: Add a way to check if the values were changed.
      updateParkingLot(
              token: accessToken,
              parkingLotId: widget.parkingData.id,
              name: widget.name.text,
              spaces: int.parse(widget.spaces.text),
              price: int.parse(widget.prices.text),
              address: widget.address.text,
              images: updatedImages,
              city: widget.city.text,
              latitude: locations[0].latitude,
              longitude: locations[0].longitude)
          .then((value) {
        buildNotification('Parking lot updated successfully', 'success');
        setState(() {
          showLoader = false;
        });
        // Retrieve the new details from the backend.
        widget.getParkingDetails();
        clearFields();
        Navigator.of(context).pop();
      }).catchError((err) {
        setState(() {
          showLoader = false;
        });
        buildNotification(err.toString(), 'error');
        print("In create_update_parking_lot");
        log(json.encode(err));
      });
    }
  }

  createUpdateParking() async {
    // Links to send to the backend.
    var cloudinaryLinks = [];
    // Make a fixed list from the _imagesToSend array so that we can use its values as indexes.
    final List fixedList =
        Iterable<int>.generate(_imagesToSend.length).toList();
    setState(() {
      showLoader = true;
    });
    if (_imagesToSend.length != 0) {
      fixedList.map((index) {
        // Make sure that we're not sending images that have already been uploaded.
        if (!_imagesToSend[index].contains('https')) {
          // Upload the images to cloudinary.
          uploadImages(imagePath: _imagesToSend[index]).then((value) {
            cloudinaryLinks.add(value.secureUrl);

            // check if the map is done.
            if (index == _imagesToSend.length - 1) {
              // Call backend api.
              createUpdateParkingLots(cloudinaryLinks);
            }
          }).catchError((err) {
            setState(() {
              showLoader = false;
            });
            print(err);
          });
        }
        // If the mapping is done, make sure cloudinaryLinks has some value before updating the backend
        else if (index == _imagesToSend.length - 1) {
          createUpdateParkingLots(cloudinaryLinks);
        }
      }).toList();
    } else {
      // For updating the backend with the altered or deleted links.
      createUpdateParkingLots(cloudinaryLinks);
    }
  }

  Widget build(BuildContext context) {
    fields = [
      {
        'text': 'Parking Lot',
        'label': 'Parking Lot Name',
        'placeholder': 'Holy Basilica Parking',
        'controller': widget.name
      },
      {
        'text': 'Parking Lot',
        'label': 'Spaces Available',
        'placeholder': '500',
        'controller': widget.spaces
      },
      {
        'text': 'Parking Lot',
        'label': 'Price per hour',
        'placeholder': '110',
        'controller': widget.prices
      },
      {
        'text': 'Parking Lot',
        'label': 'Address',
        'placeholder': 'Parliament Road',
        'controller': widget.address
      },
      {
        'text': 'Parking Lot',
        'label': 'City',
        'placeholder': 'Nairobi',
        'controller': widget.city
      },
    ];
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: BackArrow(),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: true,
              title: Text(
                widget.currentScreen != 'create'
                    ? 'Edit Parking Lot'
                    : 'Add New Parking Lot',
                style: globals.buildTextStyle(18.0, true, globals.textColor),
              ),
              elevation: 0.0,
              centerTitle: true,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width - 80,
                        height: _imageFiles.length == 0
                            ? MediaQuery.of(context).size.height / 4
                            : MediaQuery.of(context).size.height / 2,
                        child: Column(
                          children: <Widget>[
                            buildImageFromGallery(pickImage),
                            SizedBox(
                              height: 15.0,
                            ),
                            buildTakeNewPhoto(pickImage),
                            SizedBox(
                              height: 15.0,
                            ),
                            _imageFiles.length > 3 && selected == null
                                ? helperMessage(
                                    'Scroll to the right if you\'re uploading multiple images')
                                : _imageFiles.length > 0
                                    ? helperMessage(
                                        'Tap on one of the images to crop or remove it')
                                    : Container(),
                            _imageFiles.length != 0
                                // If the user selects an image, expand it and to show the crop and clear button.
                                ? selected == null
                                    ? editLocalImage(widget.currentScreen,
                                        displayPicture, _imageFiles)
                                    : editUploadedImage(widget.currentScreen,
                                        selected, _cropImage, _clear)
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text('Kindly fill in the following details',
                          style: globals.buildTextStyle(
                              17.0, true, globals.textColor)),
                      fields != null ? buildFields(fields) : Container(),
                      SizedBox(height: 18.0),
                      InkWell(
                          onTap: createUpdateParking,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30.0,
                            height: 53.0,
                            decoration: BoxDecoration(
                                color: globals.backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0))),
                            child: Center(
                                child: Text(
                              'Save Edits',
                              style: globals.buildTextStyle(
                                  18.0, true, globals.textColor),
                            )),
                          )),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
                showLoader ? Loader() : Container()
              ],
            )));
  }
}
