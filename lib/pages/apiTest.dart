import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
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
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDc5NTVlYTA4YzE1OTAwMjAzZGZlYjciLCJpYXQiOjE2MTkwODA1MzMsImV4cCI6MTYxOTA5ODUzMywidHlwZSI6ImFjY2VzcyJ9.6dY-CZevxG5klDjO7KgfMWef-9X8Hoexoq2PEqIaCuQ';

  @override
  void initState() {
    super.initState();
    futureParkingLots = getParkingLots(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Testing Page'),
        centerTitle: true,
      ),
      body: Center(
          child: FutureBuilder<QueryParkingLots>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.parkingLots.first.id),
                  Text(snapshot.data.parkingLots.first.name),
                  Text(snapshot.data.parkingLots.first.owner),
                  Text(snapshot
                      .data.parkingLots.first.location.coordinates.first
                      .toString()),
                  Text(snapshot.data.parkingLots.first.location.coordinates.last
                      .toString()),
                  Text(snapshot.data.limit.toString()),
                  Text(snapshot.data.page.toString()),
                  Text(snapshot.data.totalPages.toString()),
                  Text(snapshot.data.totalResults.toString()),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
        future: futureParkingLots,
      )),
    );
  }
}
