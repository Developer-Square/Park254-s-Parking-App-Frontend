import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/users/getUsers.dart';
import 'package:park254_s_parking_app/models/queryUsers.model.dart';
import 'package:park254_s_parking_app/models/user.model.dart';

class UsersListModel with ChangeNotifier {
  QueryUsers _userList = new QueryUsers(
    users: null,
    page: null,
    limit: null,
    totalPages: null,
    totalResults: null,
  );
  bool loading = false;

  QueryUsers get users => _userList;

  void fetch({
    @required String token,
    String name = '',
    String role = '',
    String sortBy = '',
    int limit = 10,
    int page = 1,
  }) async {
    loading = true;
    _userList = await getUsers(
      token: token,
      name: name,
      role: role,
      sortBy: sortBy,
      limit: limit,
      page: page,
    );
    loading = false;
    notifyListeners();
  }

  void add({@required User user}) {
    _userList.users.add(user);
    notifyListeners();
  }

  void remove({@required User user}) {
    _userList.users.removeWhere((u) => u.id == user.id);
    notifyListeners();
  }

  void clear() {
    _userList.users.clear();
    notifyListeners();
  }

  User findById({@required String id}) {
    return _userList.users.firstWhere((u) => u.id == id);
  }

  set updateUser(User user) {
    num index = _userList.users.indexWhere((u) => u.id == user.id);
    _userList.users[index] = user;
    notifyListeners();
  }
}
