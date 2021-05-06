import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePageArguements {
  final FlutterSecureStorage loginDetails;

  HomePageArguements({
    @required this.loginDetails,
  });
}
