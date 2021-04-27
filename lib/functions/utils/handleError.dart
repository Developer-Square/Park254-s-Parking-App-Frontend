import 'dart:convert';

import 'package:park254_s_parking_app/models/error.model.dart';

/// Custom error handler for Apis
void handleError(err) {
  final error = Error.fromJson(jsonDecode(err));
  throw error.message;
}
