import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import '../../../config/globals.dart' as globals;

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
