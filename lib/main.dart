import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/components/Booking.dart';
import 'pages/login_screen.dart';
import 'package:park254_s_parking_app/pages/onboarding_page.dart';
import 'package:park254_s_parking_app/config/bookingArguments.dart';

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
      routes: {
        '/login_screen': (context) => LoginScreen(),
        '/homepage': (context) => HomePage()},
      onGenerateRoute: (settings) {
        if (settings.name == Booking.routeName) {
          final BookingArguments args = settings.arguments;
          return MaterialPageRoute(
              builder: (context) {
                return Booking(
                    bookingNumber: args.bookingNumber,
                    destination: args.destination,
                    parkingLotNumber: args.parkingLotNumber,
                    price: args.price,
                    imagePath: args.imagePath
                );
              }
          );
        }
      }
    );
  }
}
