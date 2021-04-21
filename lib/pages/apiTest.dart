import 'package:park254_s_parking_app/components/CustomFloatingActionButton.dart';
import 'package:park254_s_parking_app/functions/auth/login.dart';
import 'package:park254_s_parking_app/functions/auth/logout.dart';
import 'package:park254_s_parking_app/functions/users/getUserById.dart';
import 'package:park254_s_parking_app/functions/users/getUsers.dart';
import 'package:park254_s_parking_app/functions/users/updateUser.dart';
import 'package:park254_s_parking_app/models/queryUsers.model.dart';
import 'package:park254_s_parking_app/models/user.model.dart';

import '../models/userWithToken.model.dart';

import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<User> futureUser;
  Future<QueryUsers> futureUsers;
  final String name = 'john';
  final String email = 'john@example.com';
  final String password = 'password1';
  final String role = 'vendor';
  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDc5NTVlYTA4YzE1OTAwMjAzZGZlYjciLCJpYXQiOjE2MTkwMTk4NDgsImV4cCI6MTYxOTAzNzg0OCwidHlwZSI6ImFjY2VzcyJ9.g6IgJIe8rxcHXLSVg1AOuIOiGlcIO1-UOGnLdvaxYAc';

  @override
  void initState() {
    super.initState();
    futureUser =
        updateUser(token, '6079391163b8370020aa6fdd', name: "Sebastian");
    futureUsers = getUsers(
      token,
      role: 'vendor',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Testing Page'),
        centerTitle: true,
      ),
      body: Center(
          child: FutureBuilder<User>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.name),
                  Text(snapshot.data.id),
                  Text(snapshot.data.email),
                  Text(snapshot.data.role),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
        future: futureUser,
      )),
    );
  }
}
