import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLotById.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/functions/parkingLots/updateParkingLot.dart';
import 'package:park254_s_parking_app/models/location.model.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/queryParkingLots.models.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<ParkingLot> futureParkingLot;
  Future<QueryParkingLots> futureParkingLots;
  final String name = 'MHS Parking Lot';
  final String owner = '60793ea363b8370020aa6fe3';
  final int spaces = 800;
  final num longitude = 36.07784383173969;
  final num latitude = -0.2860435293491271;
  final List<String> images = [
    "https://imageone.com",
    "https://imagetwo.com",
    "https://imagethree.com",
  ];
  final String role = 'vendor';
  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDc5NTVlYTA4YzE1OTAwMjAzZGZlYjciLCJpYXQiOjE2MTkwODUxNDYsImV4cCI6MTYxOTEwMzE0NiwidHlwZSI6ImFjY2VzcyJ9.Dw52vmgyi5xGFciyk-5AvajvKFMj6F8o6U8yFlX5AOw';

  @override
  void initState() {
    super.initState();
    futureParkingLot = updateParkingLot(
      token: token,
      parkingLotId: '60813c3660d11c0020639017',
      name: "Holy Minor Basilica Basement Parking",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Testing Page'),
        centerTitle: true,
      ),
      body: Center(
          child: FutureBuilder<ParkingLot>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.id),
                  Text(snapshot.data.name),
                  Text(snapshot.data.owner),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
        future: futureParkingLot,
      )),
    );
  }
}
