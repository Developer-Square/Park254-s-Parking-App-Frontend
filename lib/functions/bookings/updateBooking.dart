import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import '../../config/globals.dart' as globals;

/// Updates a booking
Future<BookingDetails> updateBooking({
  @required String token,
  @required String bookingId,
  @required String parkingLotId,
  @required DateTime exitTime,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
    dartIO.HttpHeaders.contentTypeHeader: "application/json",
  };
  final url = Uri.https(globals.apiKey, '/v1/bookings/$bookingId');

  Map<String, dynamic> body = {
    "parkingLotId": parkingLotId,
    "exitTime": exitTime.toUtc().toIso8601String(),
  };

  final response = await http.patch(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final booking = BookingDetails.fromJson(jsonDecode(response.body));
    return booking;
  } else {
    handleError(response.body);
  }
}
