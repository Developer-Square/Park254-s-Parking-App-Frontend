import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import '../../config/globals.dart' as globals;

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = '';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      scan();
    }
  }

  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() {
          barcode = 'Unknown error: $e';
        });
      }
    } on FormatException {
      setState(() {
        barcode =
            'null (User returned using the "back" button before scanning anything)';
      });
    } catch (e) {
      setState(() {
        barcode = 'Unknown error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackArrow(),
        title: Text('Scan QR Code',
            style: globals.buildTextStyle(
              16.0,
              true,
              globals.textColor,
            )),
        centerTitle: true,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RaisedButton(
                color: globals.backgroundColor,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: const Text('START CAMERA SCAN')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(barcode, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}
