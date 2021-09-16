import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/userWithToken.model.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';

/// User model object with setters and getters
class UserWithTokenModel with ChangeNotifier {
  UserWithToken _user =
      new UserWithToken(user: null, accessToken: null, refreshToken: null);

  UserWithToken get user => _user;

  void setUser(UserWithToken value) {
    _user = value;
    notifyListeners();
  }

  void updateUser(String name, String email, num phone) {
    _user.user.name = name;
    _user.user.email = email;
    _user.user.phone = phone;
    notifyListeners();
  }

  void clear() {
    _user =
        new UserWithToken(user: null, accessToken: null, refreshToken: null);
  }
}
