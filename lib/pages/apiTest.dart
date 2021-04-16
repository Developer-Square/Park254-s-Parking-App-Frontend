import 'package:park254_s_parking_app/functions/login.dart';

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
        child: FutureBuilder<UserWithToken>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
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
        ),
      ),
    );
  }
}
