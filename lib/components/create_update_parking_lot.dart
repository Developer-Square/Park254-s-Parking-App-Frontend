import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park254_s_parking_app/functions/cloudinary/upload_images.dart';
import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import '../config/globals.dart' as globals;

/// Builds a page where vendors can create or update their parking lots.

class CreateUpdateParkingLot extends StatefulWidget {
  TextEditingController name;
  TextEditingController spaces;
  TextEditingController prices;
  TextEditingController address;
  TextEditingController city;
  final FlutterSecureStorage loginDetails;
  final currentScreen;

  CreateUpdateParkingLot(
      {@required this.name,
      @required this.spaces,
      @required this.prices,
      @required this.address,
      @required this.city,
      @required this.loginDetails,
      this.currentScreen});
  @override
  _CreateUpdateParkingLotState createState() => _CreateUpdateParkingLotState();
}

class _CreateUpdateParkingLotState extends State<CreateUpdateParkingLot> {
  /// We are storing the images twice because inorder to display the images.
  /// need to put them in [File] format while sending them to cloudinary requires.
  /// them to be [String] format.
  // Active image files to be displayed to the user.
  var _imageFiles = [];
  // Image files to be sent to cloudinary.
  var _imagesToSend = [];
  // Used when selecting which image to remove or crop.
  File selected;
  var index;
  bool showLoader;
  final picker = ImagePicker();

  initState() {
    super.initState();
    showLoader = false;
  }

  // Select an image via gallery or camera.
  Future<void> _pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: source);

    setState(() {
      if (selected != null) {
        _imageFiles.add(File(selected.path));
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
      selected = null;
    });
  }

  displayPicture(pic, picIndex) {
    setState(() {
      selected = pic;
      index = picIndex;
    });
  }

  createUpdateParkingLots(links) async {
    var accessToken = await widget.loginDetails.read(key: 'accessToken');
    var userId = await widget.loginDetails.read(key: 'userId');
    // Get the coordinates of the address the user entered.
    // Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
    List<dynamic> locations = await locationFromAddress(
        widget.address.text + ', ' + widget.city.text);
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
      print('success');
      print(value);
    }).catchError((err) {
      print(err);
    });
  }

  createUpdateParking() async {
    // Links to send to the backend.
    var cloudinaryLinks = [];

    setState(() {
      showLoader = true;
    });

    if (_imagesToSend.length != 0) {
      _imagesToSend.forEach((image) {
        // Upload the images to cloudinary.
        uploadImages(imagePath: image).then((value) {
          setState(() {
            showLoader = false;
          });
          cloudinaryLinks.add(value.secureUrl);

          // check if the forEach is done.
          if (cloudinaryLinks.length == _imagesToSend.length) {
            // Call backend api.
            createUpdateParkingLots(cloudinaryLinks);
          }
        }).catchError((err) {
          setState(() {
            showLoader = false;
          });
          print(err);
        });
      });
    }
  }

  Widget build(BuildContext context) {
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
                            Expanded(
                              child: Container(
                                color: Colors.grey[200],
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Add photo from gallery'),
                                        Icon(Icons.add)
                                      ]),
                                )),
                              ),
                              flex: 2,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.grey[200],
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Take a new photo'),
                                        Icon(Icons.add_a_photo)
                                      ]),
                                )),
                              ),
                              flex: 2,
                            ),
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
                                    ? Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _imageFiles.length,
                                          itemBuilder: (context, index) {
                                            return Row(children: [
                                              Container(
                                                  child: InkWell(
                                                      onTap: () {
                                                        displayPicture(
                                                            _imageFiles[index],
                                                            index);
                                                      },
                                                      child: Image.file(
                                                          _imageFiles[index]))),
                                              SizedBox(
                                                width: 8.0,
                                              )
                                            ]);
                                          },
                                        ),
                                        flex: 3)
                                    : Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                                height: 145.0,
                                                child: Image.file(selected)),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  FlatButton(
                                                      onPressed: _cropImage,
                                                      child: Icon(Icons.crop)),
                                                  FlatButton(
                                                      onPressed: _clear,
                                                      child: Icon(Icons.close))
                                                ]),
                                          ],
                                        ),
                                        flex: 7,
                                      )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text('Kindly fill in the following details',
                          style: globals.buildTextStyle(
                              17.0, true, globals.textColor)),
                      BuildFormField(
                        text: 'Parking Lot',
                        label: 'Parking Lot Name',
                        placeholder: 'Holy Basilica Parking',
                        controller: widget.name,
                      ),
                      SizedBox(height: 20.0),
                      BuildFormField(
                        text: 'Parking Lot',
                        label: 'Spaces Available',
                        placeholder: '500',
                        controller: widget.spaces,
                      ),
                      SizedBox(height: 20.0),
                      BuildFormField(
                        text: 'Parking Lot',
                        label: 'Price per hour',
                        placeholder: '110',
                        controller: widget.prices,
                      ),
                      SizedBox(height: 20.0),
                      BuildFormField(
                        text: 'Parking Lot',
                        label: 'Address',
                        placeholder: 'Parliament Road',
                        controller: widget.address,
                      ),
                      SizedBox(height: 20.0),
                      BuildFormField(
                        text: 'Parking Lot',
                        label: 'City',
                        placeholder: 'Nairobi',
                        controller: widget.city,
                      ),
                      SizedBox(height: 35.0),
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

  Widget helperMessage(text) {
    return Container(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(text,
            style: globals.buildTextStyle(13.0, true, globals.textColor)));
  }
}
