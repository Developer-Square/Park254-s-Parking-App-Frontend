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
import 'package:park254_s_parking_app/dataModels/ParkingLotListModel.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/functions/cloudinary/upload_images.dart';
import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:geocoding/geocoding.dart';
import 'package:park254_s_parking_app/functions/parkingLots/updateParkingLot.dart';
import 'package:provider/provider.dart';
import '../../config/globals.dart' as globals;
import 'widgets/helpers_widgets.dart';
import './widgets/helper_functions.dart';

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
  /// we need to put them in [File] format while sending them to cloudinary requires.
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
  // Parking lot details from the store.
  ParkingLotListModel parkingLotList;

  initState() {
    super.initState();
    showLoader = false;
    if (mounted) {
      storeDetails = Provider.of<UserWithTokenModel>(context, listen: false);
      parkingLotList = Provider.of<ParkingLotListModel>(context, listen: false);
    }

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

  void setLoader(bool value) {
    setState(() {
      showLoader = value;
    });
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
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: selected.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
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
      _backendImages.removeAt(index);
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
      _imageFiles.clear();
      _imagesToSend.clear();
      _backendImages.clear();
    });
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
            appBar: appBar(
              clearFields: clearFields,
              currentScreen: widget.currentScreen,
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
                          onTap: () => createUpdateParking(
                                storeDetails: storeDetails,
                                links: linksParam,
                                spaces: widget.spaces.text,
                                backendImages: _backendImages,
                                parkingData: widget.parkingData,
                                parkingLotList: parkingLotList,
                                address: widget.address.text,
                                city: widget.city.text,
                                currentScreen: widget.currentScreen,
                                context: context,
                                clearFields: clearFields,
                                name: widget.name.text,
                                prices: widget.prices.text,
                                setLoader: setLoader,
                                imagesToSend: _imagesToSend,
                              ),
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
