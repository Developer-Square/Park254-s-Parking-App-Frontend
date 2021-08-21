import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

Widget imageLoader(loadingProgress) {
  return Center(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Loading...',
        style: globals.buildTextStyle(15.0, true, Colors.grey),
      ),
      SizedBox(height: 10.0),
      CircularProgressIndicator(
        backgroundColor: globals.backgroundColor,
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
            : null,
      ),
    ],
  ));
}
