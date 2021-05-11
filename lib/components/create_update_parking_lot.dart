import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds a page where vendors can create or update their parking lots.

class CreateUpdateParkingLot extends StatefulWidget {
  final imgPath;

  CreateUpdateParkingLot({@required this.imgPath});
  @override
  _CreateUpdateParkingLotState createState() => _CreateUpdateParkingLotState();
}

class _CreateUpdateParkingLotState extends State<CreateUpdateParkingLot> {
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                child: Image(
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                  image: AssetImage(widget.imgPath),
                ),
              ),
              Container(
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(Icons.camera_enhance)],
                  )),
                ),
              )
            ],
          ),
        )
      ],
    )));
  }
}
