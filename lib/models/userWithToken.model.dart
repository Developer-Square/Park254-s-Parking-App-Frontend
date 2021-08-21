import 'package:flutter/material.dart';

import './user.model.dart';
import './token.model.dart';

/// Creates a user object with their access and refresh tokens objects from Json
class UserWithToken {
  User user;
  final Token accessToken;
  final Token refreshToken;

  UserWithToken({
    @required this.user,
    @required this.accessToken,
    @required this.refreshToken,
  });

  factory UserWithToken.fromJson(Map<String, dynamic> json) {
    return UserWithToken(
      user: User.fromJson(json['user']),
      accessToken: Token.fromJson(json['tokens']['access']),
      refreshToken: Token.fromJson(json['tokens']['refresh']),
    );
  }
}
