import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Creates a camera widget
///
/// E.g.
/// ```dart
/// Snap();
/// ```
class Snap extends StatefulWidget {

  Snap({
    Key key,
  }) : super(key: key);

  @override
  _SnapState createState() => _SnapState();
}

class _SnapState extends State<Snap> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool snapped = false;
  CameraDescription camera;
  List cameras;
  String path;

  void _toggleDisplay(){
    setState(() {
      snapped = !snapped;
    });
  }

  void _takePicture() async {
    try {
      path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png',);
      await _initializeControllerFuture;
      await _controller.takePicture(path);
      _toggleDisplay();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }
  
  Widget _displayPicture(){
    return Center(child: Image.file(File(path)));
  }

  @override
  void initState(){
    super.initState();
    
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if(cameras.length > 0){
        setState(() {
          camera = cameras[0];
        });
        _controller = CameraController(camera, ResolutionPreset.medium,);
        _initializeControllerFuture = _controller.initialize();
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: <Widget>[
                CameraPreview(_controller),
                snapped ? _displayPicture() : Container(),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: width/10),
          child: FloatingActionButton.extended(
            onPressed: snapped ? _toggleDisplay : _takePicture,
            label: Text(
              snapped ? '+' : 'Snap',
              style: TextStyle(color: globals.textColor),
            ),
            backgroundColor: globals.primaryColor,
          ),
        ),
      ),
    );
  }
}