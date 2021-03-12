import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/MyText.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

class PayUp extends StatefulWidget {
  final int total;
  final Widget timeDatePicker;
  final Function toggleDisplay;

  PayUp({
    @required this.total,
    @required this.timeDatePicker,
    @required this.toggleDisplay,
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
                    alignment: Alignment.centerRight,
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
                        MyText(content: 'Total'),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(
                                    Icons.attach_money,
                                    color: globals.textColor,
                                  )
                              ),
                              TextSpan(
                                text: '${widget.total.toString()}'
                              ),
                            ],
                            style: TextStyle(
                              color: globals.textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
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
                            onTap: () => {},
                            child: Center(
                              child: MyText(
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