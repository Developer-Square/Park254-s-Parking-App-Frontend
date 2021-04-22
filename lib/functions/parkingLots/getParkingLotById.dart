import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import '../../config/globals.dart' as globals;

/// Get parking lot using id
///
/// Returns [ParkingLot]
/// Requires: [token], [parkingLotId]
Future<ParkingLot> getParkingLotById({
  @required String token,
  @required String parkingLotId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.httpsUrl, '/v1/parkingLots/$parkingLotId');
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final parkingLot = ParkingLot.fromJson(jsonDecode(response.body));
    return parkingLot;
  } else {
    handleError(response.body);
  }
}
