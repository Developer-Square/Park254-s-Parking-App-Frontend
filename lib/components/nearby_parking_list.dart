import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

class NearByParking extends StatelessWidget {
  final String imgPath;
  final int parkingPrice;
  final String parkingPlaceName;
  final double rating;
  final double distance;
  final int parkingSlots;

  NearByParking(
      {@required this.imgPath,
      @required this.parkingPrice,
      @required this.parkingPlaceName,
      @required this.rating,
      @required this.distance,
      @required this.parkingSlots});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90.0,
        child: Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 6.0), //(x,y)
                  blurRadius: 15.0,
                )
              ],
            ),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Hero(
                    tag: imgPath,
                    child: Image(
                      height: 90.0,
                      width: 85.0,
                      fit: BoxFit.cover,
                      image: AssetImage(imgPath),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    color: Colors.blue,
                    padding: EdgeInsets.all(4.0),
                    child: Text('Ksh $parkingPrice / hr',
                        style: globals.buildTextStyle(12.0, true, 'white')),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parkingPlaceName,
                style: globals.buildTextStyle(15.0, true, globals.fontColor),
              ),
              SizedBox(height: 7.0),
              Row(
                children: [
                  Text('$rating',
                      style: globals.buildTextStyle(
                          15.0, true, globals.backgroundColor)),
                  SizedBox(width: 8.0),
                  Text('PARKING MALL',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey))
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.car_rental),
                  SizedBox(width: 6.0),
                  Text('$parkingSlots Spaces',
                      style: globals.buildTextStyle(
                          14.0, true, globals.fontColor)),
                  SizedBox(width: 15.0),
                  Icon(
                    Icons.near_me,
                    size: 17.0,
                  ),
                  SizedBox(width: 6.0),
                  Text('$distance m',
                      style: globals.buildTextStyle(
                          14.0, true, globals.fontColor)),
                ],
              )
            ],
          )
        ]));
  }
}
