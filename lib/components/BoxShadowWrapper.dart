import 'package:flutter/material.dart';

/// Adds the specified box shadow to the widget passed to it.
///
/// Requires [offsetY], [blurRadius], [opacity] and [controller].
/// ```
/// BoxShadowWrapper(
/// offsetY: 4.0,
/// blurRadius: 6.0,
/// opacity: 0.9,
/// content: content,
/// )
///```
class BoxShadowWrapper extends StatelessWidget {
  final offsetY;
  final offsetX;
  final blurRadius;
  final opacity;
  final content;
  final height;

  BoxShadowWrapper(
      {@required this.offsetY,
      @required this.offsetX,
      @required this.blurRadius,
      @required this.opacity,
      @required this.content,
      this.height});

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(opacity),
              offset: Offset(offsetX, offsetY), //(x,y)
              blurRadius: blurRadius,
            )
          ],
        ),
        child: content,
      ),
    );
  }
}
