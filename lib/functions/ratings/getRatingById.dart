import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/rating.model.dart';
import '../../config/globals.dart' as globals;

/// Gets rating using id
///
/// Returns [Rating]
/// Requires: [token], [ratingId]
Future<Rating> getRatingById({
  @required String token,
  @required String ratingId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/ratings/$ratingId');
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final rating = Rating.fromJson(jsonDecode(response.body));
    return rating;
  } else {
    handleError(response.body);
  }
}
