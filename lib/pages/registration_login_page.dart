import 'package:flutter/material.dart';

class RegistrationLoginPage extends StatefulWidget {
  @override
  _RegistrationLoginPageState createState() => _RegistrationLoginPageState();
}

class _RegistrationLoginPageState extends State<RegistrationLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Login page',
            ),
          ],
        ),
      ),
    );
  }
}
