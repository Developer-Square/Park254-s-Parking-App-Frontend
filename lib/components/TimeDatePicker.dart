import 'package:flutter/material.dart';
import './TimePicker.dart';
import './DatePicker.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

class TimeDatePicker extends StatelessWidget{
  final Function pickArrivalDate;
  final Function pickArrivalTime;
  final Function pickLeavingDate;
  final Function pickLeavingTime;
  final String parkingTime;
  final String arrivalDate;
  final String arrivalTime;
  final String leavingDate;
  final String leavingTime;

  TimeDatePicker({
    @required this.pickArrivalDate,
    @required this.pickArrivalTime,
    @required this.pickLeavingDate,
    @required this.pickLeavingTime,
    @required this.arrivalDate,
    @required this.arrivalTime,
    @required this.leavingDate,
    @required this.leavingTime,
    @required this.parkingTime
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54.withOpacity(0.1))
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Arriving',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          color: globals.textColor
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DatePicker(
                              onSelect: pickArrivalDate,
                              dateDisplay: arrivalDate,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: TimePicker(
                              onSelect: pickArrivalTime,
                              timeDisplay: arrivalTime,
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54.withOpacity(0.1))
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Leaving',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: globals.textColor
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DatePicker(
                              onSelect: pickLeavingDate,
                              dateDisplay: leavingDate,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: TimePicker(
                              onSelect: pickLeavingTime,
                              timeDisplay: leavingTime,
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              flex: 1,
            ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              parkingTime,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }
}