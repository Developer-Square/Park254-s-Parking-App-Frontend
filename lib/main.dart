import 'package:flutter/material.dart';
import './pages/onboarding_page.dart';
import './pages/registration_login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park254 Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/registration_login',
      // home: OnBoarding Page(),
      routes: {'/registration_login': (context) => RegistrationLoginPage()},
    );
  }
}
