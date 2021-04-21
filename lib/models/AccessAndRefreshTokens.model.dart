import 'package:flutter/material.dart';
import './token.model.dart';

class AccessAndRefreshTokens {
  final Token accessToken;
  final Token refreshToken;

  AccessAndRefreshTokens({
    @required this.accessToken,
    @required this.refreshToken,
  });

  factory AccessAndRefreshTokens.fromJson(Map<String, dynamic> json) {
    return AccessAndRefreshTokens(
      accessToken: Token.fromJson(json['access']),
      refreshToken: Token.fromJson(json['refresh']),
    );
  }
}
