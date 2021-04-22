import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

/// Deletes a parking Lot
///
/// Requires: [token], [parkingLotId]
Future<String> deleteParkingLot({
  @required String token,
  @required String parkingLotId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.httpsUrl, '/v1/parkingLots/$parkingLotId');
  final response = await http.delete(url, headers: headers);

  if (response.statusCode == 200) {
    return 'success';
  } else {
    handleError(response.body);
  }
}
