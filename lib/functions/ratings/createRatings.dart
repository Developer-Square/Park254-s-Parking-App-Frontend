import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/rating.model.dart';
import '../../config/globals.dart' as globals;

/// Creates a new rating
///
/// Returns [Rating]
/// Requires: [userId], [parkingLotId], [value], [token]
Future<Rating> createRating({
  @required String userId,
  @required String parkingLotId,
  @required int value,
  @required String token,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
    HttpHeaders.contentTypeHeader: "application/json",
  };

  final url = Uri.https(globals.apiKey, '/v1/ratings');
  final body = jsonEncode({
    'userId': userId,
    'parkingLotId': parkingLotId,
    'value': value,
  });
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 201) {
    final rating = Rating.fromJson(jsonDecode(response.body));
    return rating;
  } else {
    handleError(response.body);
  }
}
