import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/features.model.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import '../../config/globals.dart' as globals;

/// Creates a new parking lot
///
/// Returns [ParkingLot]
/// Requires: [owner], [name], [spaces], [longitude], [latitude], [images], [token]
Future<ParkingLot> createParkingLot({
  @required String owner,
  @required String name,
  @required int spaces,
  @required num longitude,
  @required num latitude,
  @required List<dynamic> images,
  @required String token,
  @required int price,
  @required String address,
  String city = 'Nairobi',
  bool accessibleParking = false,
  bool cctv = false,
  bool carWash = false,
  bool evCharging = false,
  bool valetParking = false,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
    dartIO.HttpHeaders.contentTypeHeader: "application/json",
  };
  final url = Uri.https('${globals.apiKey}', '/v1/parkingLots');
  final Map<String, dynamic> features = new Features(
    accessibleParking: accessibleParking,
    cctv: cctv,
    carWash: carWash,
    evCharging: evCharging,
    valetParking: valetParking,
  ).toJson();
  final body = jsonEncode({
    'owner': owner,
    'spaces': spaces.toString(),
    'name': name,
    'location': {
      'type': 'Point',
      'coordinates': [longitude.toString(), latitude.toString()],
    },
    'images': images,
    'price': price,
    'address': address,
    'city': city,
    'features': features,
  });
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 201) {
    final parkingLot = ParkingLot.fromJson(jsonDecode(response.body));
    return parkingLot;
  } else {
    handleError(response.body);
  }
}
