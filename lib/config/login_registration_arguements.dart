import 'package:flutter/material.dart';

class LoginRegistrationArguements {
  final bool showToolTip;
  final String text;
  final Function hideToolTip;

  LoginRegistrationArguements(
      {@required this.showToolTip,
      @required this.text,
      @required this.hideToolTip});
}
