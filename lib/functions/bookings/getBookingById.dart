import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/booking.populated.model.dart';
import '../../config/globals.dart' as globals;

/// Gets a booking using id
Future<BookingDetailsPopulated> getBookingById({
  @required String token,
  @required String bookingId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/bookings/$bookingId');
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final booking = BookingDetailsPopulated.fromJson(jsonDecode(response.body));
    return booking;
  } else {
    handleError(response.body);
  }
}
