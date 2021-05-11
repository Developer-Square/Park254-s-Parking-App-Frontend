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
          widget.text != null
              ? widget.text.contains('Incorrect') ||
                      widget.text.contains('successfully')
                  ? Container()
                  : SizedBox(height: 35.0)
              : Container(),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: widget.text != null
                        ? widget.text.contains('successfully')
                            ? globals.backgroundColor
                            : Colors.red
                        : Colors.red,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.text != null ? widget.text : '',
                        style:
                            globals.buildTextStyle(14.0, false, Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: InkWell(
                            onTap: () {
                              widget.hideToolTip();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
