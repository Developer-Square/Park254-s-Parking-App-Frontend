import '../models/user.model.dart';
import '../functions/register.dart';

import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  Future<User> futureUser;
  final String name = 'clare';
  final String email = 'clare@example.com';
  final String password = 'password1';
  final String role = 'vendor';

  @override
  void initState() {
    super.initState();
    futureUser = register(email, name, role, password);
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
                  children: <Widget>[
                    Text(snapshot.data.name),
                    Text(snapshot.data.email),
                    Text(snapshot.data.id),
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
        ),
      ),
    );
  }
}
