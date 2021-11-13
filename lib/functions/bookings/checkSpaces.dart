import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/spaceList.model.dart';
import '../../config/globals.dart' as globals;
import 'package:park254_s_parking_app/models/error.model.dart';

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
    final error = Error.fromJson(jsonDecode(response.body));
    // When the parking lot is empty the request returns a 'Not Found error'.
    // we don't want to show this to the user.
    if (response.statusCode == 404) {
      buildNotification('The Parking lot is empty.', 'success');
    } else {
      throw error;
    }
  }
}
