import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/components/Booking.dart';
import 'package:park254_s_parking_app/pages/search_page.dart';
import 'config/home_page_arguments.dart';
import 'config/search_page_arguments.dart';
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
          '/homepage': (context) => HomePage()
        },
        onGenerateRoute: (settings) {
          if (settings.name == Booking.routeName) {
            final BookingArguments args = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return Booking(
                  bookingNumber: args.bookingNumber,
                  destination: args.destination,
                  parkingLotNumber: args.parkingLotNumber,
                  price: args.price,
                  imagePath: args.imagePath);
            });
          } else if (settings.name == SearchPage.routeName) {
            final SearchPageArguments args = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return RecentSearches(
                specificLocation: args.specificLocation,
                town: args.specificLocation,
                setShowRecentSearches: args.setShowRecentSearches,
              );
            });
          } else if (settings.name == HomePage.routeName) {
            final HomePageArguments args = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return NearByParkingList(
                imgPath: args.imgPath,
                parkingPrice: args.parkingPrice,
                parkingPlaceName: args.parkingPlaceName,
                rating: args.rating,
                distance: args.distance,
                parkingSlots: args.parkingSlots,
              );
            });
          }
        });
  }
}
