import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

class RecentSearches extends StatelessWidget {
  String specificLocation;
  String town;

  RecentSearches({@required this.specificLocation, @required this.town});
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100.0),
              ),
              color: Colors.grey.withOpacity(0.2)),
          child: Icon(
            Icons.watch_later_outlined,
            color: Colors.grey,
          )),
      SizedBox(width: 20.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            specificLocation,
            style: globals.buildTextStyle(18.0, true, globals.fontColor),
          ),
          SizedBox(height: 7.0),
          Text(
            town,
            style:
                TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 17.0),
          )
        ],
      )
    ]);
  }
}
