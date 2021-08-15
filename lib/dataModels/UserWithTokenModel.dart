import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/userWithToken.model.dart';

/// User model object with setters and getters
class UserWithTokenModel with ChangeNotifier {
  UserWithToken _user =
      new UserWithToken(user: null, accessToken: null, refreshToken: null);

  UserWithToken get user => _user;

  set user(UserWithToken value) {
    _user = value;
    notifyListeners();
  }

  void clear() {
    _user =
        new UserWithToken(user: null, accessToken: null, refreshToken: null);
  }
}
