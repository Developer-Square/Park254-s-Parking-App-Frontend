import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/models/location.model.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';

import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<ParkingLot> futureParkingLot;
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
    futureParkingLot = createParkingLot(
      owner: owner,
      name: name,
      spaces: spaces,
      longitude: longitude,
      latitude: latitude,
      images: images,
      token: token,
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
                  Text(snapshot.data.name),
                  Text(snapshot.data.id),
                  Text(snapshot.data.spaces.toString()),
                  Text(snapshot.data.images.first),
                  Text(snapshot.data.location.type),
                  Text(snapshot.data.location.id),
                  Text(snapshot.data.location.coordinates.first.toString()),
                  Text(snapshot.data.location.coordinates.last.toString()),
                  Text(snapshot.data.ratingCount.toString()),
                  Text(snapshot.data.ratingValue.toString()),
                  Text(snapshot.data.rating.toString()),
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
