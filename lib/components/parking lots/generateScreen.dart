import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../BackArrow.dart';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPaddding = 50.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  Map<String, dynamic> _dataMap = {
    'numberPlate': 'KCB 353N',
    'bookingId': '0x6f5262a0a0',
  };
  String _inputErrorText;
  String _inputText = 'From Ryan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackArrow(),
        title: Text('Generate QR Code page'),
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPaddding,
            ),
            child: Container(
              height: 200,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: QrImage(
                          data: _dataMap.toString(),
                          size: 0.5 * bodyHeight,
                          errorStateBuilder: (context, ex) {
                            log('[QR] Error - $ex');
                            setState(() {
                              _inputErrorText =
                                  'Error! Maybe your input value is too long';
                            });
                          }),
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
