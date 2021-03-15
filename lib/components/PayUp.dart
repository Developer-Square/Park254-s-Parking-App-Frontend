import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a Pay Up pop up that prompts user to pay
///
/// ```dart
/// PayUp(
///   total: amount,
///   timeDatePicker: _timeDatePicker(),
///   toggleDisplay: () => _togglePayUp(),
///   receiptGenerator: () => _generateReceipt(),
/// )
///```
class PayUp extends StatefulWidget {
  final int total;
  final Widget timeDatePicker;
  final Function toggleDisplay;
  final Function receiptGenerator;

  PayUp({
    @required this.total,
    @required this.timeDatePicker,
    @required this.toggleDisplay,
    @required this.receiptGenerator
  });
  @override
  _PayUpState createState() => _PayUpState();
}

class _PayUpState extends State<PayUp> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: height/2,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(width/10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: widget.toggleDisplay,
                        child: Icon(
                          Icons.close,
                          color: globals.textColor,
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PrimaryText(content: 'Total'),
                        PrimaryText(content: "Kes ${widget.total.toString()}"),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: widget.timeDatePicker,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Expanded(
                        child: Material(
                          color: globals.primaryColor,
                          child: InkWell(
                            onTap: widget.receiptGenerator,
                            child: Center(
                              child: PrimaryText(
                                  content: 'Pay Up'
                              ),
                            ),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        flex: 2,
                      ),
                      Spacer(),
                    ],
                  ),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}