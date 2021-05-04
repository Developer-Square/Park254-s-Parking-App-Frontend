import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// A widget meant to inform the user of any errors during.
/// the login process.
/// Requires [Text] and [showToolTip].

class ToolTip extends StatefulWidget {
  bool showToolTip;
  final String text;
  Function hideToolTip;

  ToolTip(
      {@required this.showToolTip,
      @required this.text,
      @required this.hideToolTip});

  _ToolTipState createState() => _ToolTipState();
}

class _ToolTipState extends State<ToolTip> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.showToolTip ? 1.0 : 0.0,
      duration: Duration(milliseconds: 600),
      child: Column(
        children: <Widget>[
          widget.text.contains('Incorrect') ||
                  widget.text.contains('successfully')
              ? Container()
              : SizedBox(height: 35.0),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 8.0),
              width: widget.text.contains('Kindly')
                  ? 200.0
                  : widget.text.contains('don\'t')
                      ? 225.0
                      : widget.text.contains('8')
                          ? 315.0
                          : widget.text.contains('successfully')
                              ? 280.0
                              : 250.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: widget.text.contains('successfully')
                    ? globals.backgroundColor
                    : Colors.red,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 18.0,
                        right: widget.text.contains('Kindly')
                            ? 20.0
                            : widget.text.contains('8') ||
                                    widget.text.contains('successfully')
                                ? 18.0
                                : 25.0),
                    child: Text(
                      widget.text,
                      style: globals.buildTextStyle(14.0, false, Colors.white),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        widget.hideToolTip();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
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
