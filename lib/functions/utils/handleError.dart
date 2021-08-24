import 'dart:convert';
import 'dart:developer';

import 'package:park254_s_parking_app/models/error.model.dart';

/// Custom error handler for Apis
handleError(err) {
  final error = Error.fromJson(jsonDecode(err));
  log(error.message.toString());
  throw error;
}
