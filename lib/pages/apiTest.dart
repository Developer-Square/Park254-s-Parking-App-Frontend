import 'package:park254_s_parking_app/components/CustomFloatingActionButton.dart';
import 'package:park254_s_parking_app/functions/auth/login.dart';
import 'package:park254_s_parking_app/functions/auth/logout.dart';
import 'package:park254_s_parking_app/functions/users/getUsers.dart';
import 'package:park254_s_parking_app/models/queryUsers.model.dart';

import '../models/userWithToken.model.dart';

import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<UserWithToken> futureUser;
  Future<QueryUsers> futureUsers;
  final String name = 'john';
  final String email = 'john@example.com';
  final String password = 'password1';
  final String role = 'vendor';
  String refreshToken = '';
  bool loggedIn = true;

  void updateLogin(String token) {
    setState(() {
      refreshToken = token;
      loggedIn = true;
    });
  }

  void updateLogout() {
    setState(() {
      loggedIn = false;
    });
  }

  @override
  void initState() {
    super.initState();
    futureUser = login(email, password);
    futureUsers = getUsers(
      name,
      "admin",
      "desc",
      10,
      1,
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDc5NTVlYTA4YzE1OTAwMjAzZGZlYjciLCJpYXQiOjE2MTg5OTk3MjQsImV4cCI6MTYxOTAxNzcyNCwidHlwZSI6ImFjY2VzcyJ9.KwD03EA7jEL-2GwJ-jFrr9y0y4vtGGu7mHIKhXcjifE',
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
          child: FutureBuilder<QueryUsers>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.users.first.name),
                  Text(snapshot.data.page.toString()),
                  Text(snapshot.data.limit.toString()),
                  Text(snapshot.data.totalPages.toString()),
                  Text(snapshot.data.totalResults.toString()),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
        future: futureUsers,
      )),
    );
  }
}
