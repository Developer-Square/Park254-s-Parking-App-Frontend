import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as dartIO;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import '../../config/globals.dart' as globals;

/// Books a parking lot
///
/// Requires [token], [parkingLotId, clientId, spaces, entryTime, exitTime]
Future<BookingDetails> book({
  @required String token,
  @required String parkingLotId,
  @required String clientId,
  @required num spaces,
  @required DateTime entryTime,
  @required DateTime exitTime,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
  };

  final url = Uri.https('${globals.apiKey}', '/v1/bookings');

  final Map<String, dynamic> body = BookingDetails(
    parkingLotId: parkingLotId,
    clientId: clientId,
    spaces: spaces,
    entryTime: entryTime,
    exitTime: exitTime,
  ).toJson();
  log(body.toString());

  final response = await http.post(url, body: body, headers: headers);

  if (response.statusCode == 201) {
    final bookingDetails = BookingDetails.fromJson(jsonDecode(response.body));
    return bookingDetails;
  } else {
    handleError(response.body);
  }
}
