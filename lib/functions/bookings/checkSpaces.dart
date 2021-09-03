import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/spaceList.model.dart';
import '../../config/globals.dart' as globals;

/// Check occupied spaces
Future<SpaceList> checkSpaces({
  @required String token,
  @required List<String> parkingLots,
  @required DateTime entryTime,
  @required DateTime exitTime,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
    dartIO.HttpHeaders.contentTypeHeader: "application/json",
  };
  final url = Uri.https(globals.apiKey, '/v1/spaces');

  Map<String, dynamic> body = {
    "parkingLots": parkingLots,
    "entryTime": entryTime.toUtc().toIso8601String(),
    "exitTime": exitTime.toUtc().toIso8601String(),
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final spaces = SpaceList.fromJson(jsonDecode(response.body));
    return spaces;
  } else {
    handleError(response.body);
  }
}
