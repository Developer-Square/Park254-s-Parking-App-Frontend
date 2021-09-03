import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import '../../config/globals.dart' as globals;

/// Cancel a booking using id
Future<BookingDetails> cancelBooking({
  @required String token,
  @required String bookingId,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/bookings/$bookingId');
  final response = await http.post(url, headers: headers);

  if (response.statusCode == 200) {
    final bookingDetails = BookingDetails.fromJson(jsonDecode(response.body));
    return bookingDetails;
  } else {
    handleError(response.body);
  }
}
