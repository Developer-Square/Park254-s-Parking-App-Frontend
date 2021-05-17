// ToDo: Add a reusable alert widget.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../config/globals.dart' as globals;

buildNotification(textMsg, msgType) {
  return showSimpleNotification(Text(textMsg),
      background: msgType == 'error' ? Colors.red : globals.backgroundColor,
      autoDismiss: false, trailing: Builder(builder: (context) {
    return FlatButton(
        onPressed: () {
          OverlaySupportEntry.of(context).dismiss();
        },
        child: Text('Dismiss'));
  }));
}
