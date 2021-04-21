import 'package:park254_s_parking_app/components/CustomFloatingActionButton.dart';
import 'package:park254_s_parking_app/functions/auth/login.dart';
import 'package:park254_s_parking_app/functions/auth/logout.dart';

import '../models/userWithToken.model.dart';

import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<UserWithToken> futureUser;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Testing Page'),
        centerTitle: true,
      ),
      body: Center(
        child: loggedIn
            ? FutureBuilder<UserWithToken>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      updateLogin(snapshot.data.refreshToken.token);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('name: ${snapshot.data.user.name}'),
                          Text(snapshot.data.user.email),
                          Text(snapshot.data.user.id),
                          Text(snapshot.data.user.role),
                          Text(snapshot.data.accessToken.token),
                          Text('${snapshot.data.accessToken.expires}'),
                          Text(snapshot.data.refreshToken.token),
                          Text('${snapshot.data.refreshToken.expires}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                  }
                  return CircularProgressIndicator();
                },
                future: futureUser,
              )
            : Text('Successfully logged out'),
      ),
      floatingActionButton: loggedIn
          ? CustomFloatingActionButton(
              label: 'logout',
              onPressed: () {
                logout(refreshToken);
                updateLogout();
              },
            )
          : Container(),
    );
  }
}
