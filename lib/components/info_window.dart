import 'package:clippy_flutter/triangle.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../config/globals.dart' as globals;

class InfoWindowWidget extends StatelessWidget {
  final value;

  InfoWindowWidget({@required this.value});

  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 50.0,
      child: Column(
        children: [
          Container(
            height: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0), color: Colors.white),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 2.0,
                      percent: (value.rating / 5),
                      center: Container(
                          width: 26.0,
                          height: 26.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Colors.white),
                          child: Center(
                              child: Text(
                            value.name.substring(0, 1),
                            style: globals.buildTextStyle(
                                17.0, true, globals.textColor),
                          ))),
                      progressColor: value.rating > 3.5
                          ? globals.backgroundColor
                          : value.rating == 0.0
                              ? Colors.grey[400]
                              : Colors.red,
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Text('Ksh ${value.price} / Hr',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: globals.textColor)),
              ],
            )),
          ),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(color: Colors.white, height: 6.0, width: 10.0),
          )
        ],
      ),
    );
  }
}
