import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/deleteParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getNearbyParkingLots.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLotById.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/functions/parkingLots/updateParkingLot.dart';
import 'package:park254_s_parking_app/models/location.model.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLots.model.dart';
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
  Future<NearbyParkingLots> futureNearbyParkingLots;
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
    futureNearbyParkingLots = getNearbyParkingLots(
      token: token,
      longitude: 36.82007791173121,
      latitude: -1.2872608287560152,
      maxDistance: 200,
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
          child: FutureBuilder<NearbyParkingLots>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.lots.first.name),
                  Text(snapshot.data.lots.first.distance.toString()),
                  Text(snapshot.data.lots.last.name),
                  Text(snapshot.data.lots.last.distance.toString()),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
        future: futureNearbyParkingLots,
      )),
    );
  }
}
