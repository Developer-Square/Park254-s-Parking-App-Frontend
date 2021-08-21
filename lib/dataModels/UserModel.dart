import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/users/getUserById.dart';
import 'package:park254_s_parking_app/models/user.model.dart';

class UserModel with ChangeNotifier {
  User _user =
      new User(id: null, email: null, name: null, role: null, phone: null);
  bool loading = false;
  // To allow tracking of whether a user is updating or creating a new parking.
  // lot.
  String _currentScreen;

  User get user => _user;

  String get currentScreen => _currentScreen;

  set user(User value) {
    _user = value;
    notifyListeners();
  }

  void setCurrentScreen(String value) {
    _currentScreen = value;
  }

  void fetch({
    @required String token,
    @required String userId,
  }) async {
    loading = true;
    _user = await getUserById(token: token, userId: userId);
    loading = false;

    notifyListeners();
  }

  void clear() {
    _user =
        new User(id: null, email: null, name: null, role: null, phone: null);
    notifyListeners();
  }
}
