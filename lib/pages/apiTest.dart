import 'package:park254_s_parking_app/functions/parkingLots/createParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/deleteParkingLot.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getNearbyParkingLots.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLotById.dart';
import 'package:park254_s_parking_app/functions/parkingLots/getParkingLots.dart';
import 'package:park254_s_parking_app/functions/parkingLots/updateParkingLot.dart';
import 'package:park254_s_parking_app/functions/ratings/createRatings.dart';
import 'package:park254_s_parking_app/functions/ratings/deleteRating.dart';
import 'package:park254_s_parking_app/functions/ratings/getRatingById.dart';
import 'package:park254_s_parking_app/functions/ratings/getRatings.dart';
import 'package:park254_s_parking_app/models/location.model.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLots.model.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';

import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/queryParkingLots.models.dart';
import 'package:park254_s_parking_app/models/queryRatings.model.dart';
import 'package:park254_s_parking_app/models/rating.model.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<ParkingLot> futureParkingLot;
  Future<QueryParkingLots> futureParkingLots;
  Future<NearbyParkingLots> futureNearbyParkingLots;
  Future<Rating> futureRating;
  Future<QueryRatings> futureRatings;
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
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDc5NTVlYTA4YzE1OTAwMjAzZGZlYjciLCJpYXQiOjE2MTkxMDE0OTIsImV4cCI6MTYxOTExOTQ5MiwidHlwZSI6ImFjY2VzcyJ9.yTC60ue3OQTquqwN-NDanC_fNn5tbVfvqD_gF-H5E4s';

  @override
  void initState() {
    super.initState();
    futureRating = getRatingById(
      token: token,
      ratingId: '60818860d573ef0020d468ac',
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
          child: FutureBuilder<Rating>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.id),
                  Text(snapshot.data.userId),
                  Text(snapshot.data.parkingLotId),
                  Text(snapshot.data.value.toString()),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
        future: futureRating,
      )),
    );
  }
}
