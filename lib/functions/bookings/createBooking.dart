import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'package:park254_s_parking_app/models/features.model.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import '../../config/globals.dart' as globals;

/// Creates a new parking lot
///
/// Returns [ParkingLot]
/// Requires: [owner], [name], [spaces], [longitude], [latitude], [images], [token]
Future<Booking> createBooking({
  @required String token,
  @required String parkingLotId,
  @required String clientId,
  @required int spaces,
  @required DateTime entryTime,
  @required DateTime exitTime,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
    dartIO.HttpHeaders.contentTypeHeader: "application/json",
  };
  final url = Uri.https('${globals.apiKey}', '/v1/parkingLots');
  final body = jsonEncode({
    'parkingLotId': parkingLotId,
    'clientId': clientId,
    'spaces': spaces,
    'entryTime': entryTime,
    'exitTime': exitTime,
  });
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 201) {
    final parkingLot = Booking.fromJson(jsonDecode(response.body));
    return parkingLot;
  } else {
    handleError(response.body);
  }
}
