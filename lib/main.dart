import 'package:flutter/material.dart';
import './pages/onboarding_page.dart';
import 'pages/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xff14eeb5);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park254 Parking App',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: OnBoardingPage(),
      routes: {'/login_screen': (context) => LoginScreen()},
    );
  }
}