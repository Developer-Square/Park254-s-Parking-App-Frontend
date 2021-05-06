import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// Creates a grey overlay and centered loader.
///
/// E.g.
/// ```dart
/// showLoader ?
///   Container(
///    width: MediaQuery.of(context).size.width,
///       height: MediaQuery.of(context).size.height,
///       color: Colors.grey[300].withOpacity(0.5),
///       child: Center(
///       child: CircularProgressIndicator(),
///     ),
///    )
///    :
///   Container()
/// ```
class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[300].withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: globals.backgroundColor,
        ),
      ),
    );
  }
}
