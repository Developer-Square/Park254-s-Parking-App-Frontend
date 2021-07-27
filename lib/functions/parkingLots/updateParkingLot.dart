import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import '../../config/globals.dart' as globals;

/// Updates parking lot details using Id
///
/// Returns the [ParkingLot]
/// Requires: [token], [parkingLotId]
/// Optional params: [name], [owner], [spaces], [longitude], [latitude], [images]
Future<ParkingLot> updateParkingLot({
  @required String token,
  @required String parkingLotId,
  String name = '',
  String owner = '',
  int spaces = 0,
  num longitude = 0,
  num latitude = 0,
  List<dynamic> images = const [],
  int price = 0,
  String address = '',
  String city = '',
  bool nameChanged = false,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  Map<String, dynamic> body = {
    "name": name,
    "owner": owner,
    "spaces": spaces,
    'location': {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    },
    'images': images,
    'price': price,
    'address': address,
    'city': city,
  };
  body.removeWhere((key, value) => value == '' || value == 0);
  if (longitude == 0 || latitude == 0) {
    body.remove('location');
  }
  if (images.length == 0) {
    body.remove('images');
  }
  // If the name wasn't changed then don't send it.
  if (!nameChanged) {
    body.remove('name');
  }
  final url = Uri.https(globals.apiKey, '/v1/parkingLots/$parkingLotId');
  final response = await http.patch(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final parkingLot = ParkingLot.fromJson(jsonDecode(response.body));
    return parkingLot;
  } else {
    handleError(response.body);
  }
}
