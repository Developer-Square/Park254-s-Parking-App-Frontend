import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/google_map.dart';
import 'package:park254_s_parking_app/components/home_screen.dart';
import 'package:park254_s_parking_app/components/MoreInfo.dart';
import 'package:park254_s_parking_app/components/PaymentSuccessful.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/rating_tab.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/config/receiptArguments.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/components/Booking.dart';
import 'package:park254_s_parking_app/pages/search_page.dart';
import 'components/booking_tab.dart';
import 'components/top_page_styling.dart';
import 'config/home_page_arguments.dart';
import 'config/search_page_arguments.dart';
import 'pages/login_screen.dart';
import 'package:park254_s_parking_app/pages/onboarding_page.dart';
import 'package:park254_s_parking_app/config/bookingArguments.dart';
import 'package:park254_s_parking_app/config/moreInfoArguments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xff14eeb5);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialized the InfoWindowModel so that I can use it.
    // in the homescreen tab
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
                imagePath: args.imagePath,
                address: args.address,
              );
            });
          } else if (settings.name == SearchPage.routeName) {
            final SearchPageArguments args = settings.arguments;
            final RatingTabArguements args2 = settings.arguments;
            final GoogleMapWidgetArguements args3 = settings.arguments;
            final SearchBarArguements args4 = settings.arguments;
            final RecentSearches args5 = settings.arguments;
            final BookingTabArguements args6 = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return Column(
                children: [
                  RecentSearches(
                    specificLocation: args.specificLocation,
                    town: args.specificLocation,
                    setShowRecentSearches: args.setShowRecentSearches,
                  ),
                  GoogleMapWidget(
                    mapCreated: args3.mapCreated,
                    customInfoWindowController:
                        args3.customInfoWindowController,
                  ),
                  RatingTab(
                    hideRatingTabFn: args2.hideRatingTabFn,
                    parkingPlaceName: args2.parkingPlaceName,
                  ),
                  SearchBar(
                      offsetY: args4.offsetY,
                      blurRadius: args4.blurRadius,
                      opacity: args4.opacity,
                      controller: args4.controller,
                      searchBarTapped: args4.searchBarTapped),
                  RecentSearches(
                    setShowRecentSearches: args5.setShowRecentSearches,
                    town: args5.town,
                    specificLocation: args5.specificLocation,
                  ),
                  BookingTab(searchBarController: args6.searchBarControllerText)
                ],
              );
            });
          } else if (settings.name == HomeScreen.routeName) {
            final NearByParkingListArguments args = settings.arguments;
            final NearByParkingArguements args1 = settings.arguments;
            final TopPageStylingArguements args2 = settings.arguments;
            final GoogleMapWidgetArguements args3 = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return Column(
                children: [
                  NearByParking(
                      showNearByParkingFn: args1.showNearByParkingFn,
                      hideDetails: args1.hideDetails,
                      mapController: args1.mapController,
                      customInfoWindowController:
                          args1.customInfoWindowController,
                      showFullBackground: args1.showFullBackground),
                  NearByParkingList(
                    activeCard: false,
                    imgPath: args.imgPath,
                    parkingPrice: args.parkingPrice,
                    parkingPlaceName: args.parkingPlaceName,
                    rating: args.rating,
                    distance: args.distance,
                    parkingSlots: args.parkingSlots,
                  ),
                  TopPageStyling(
                      searchBarController: args2.searchBarController,
                      currentPage: args2.currentPage,
                      widget: args2.widget),
                  GoogleMapWidget(
                    mapCreated: args3.mapCreated,
                    customInfoWindowController:
                        args3.customInfoWindowController,
                  )
                ],
              );
            });
          } else if (settings.name == MoreInfo.routeName) {
            final MoreInfoArguments args = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return MoreInfo(
                  destination: args.destination,
                  city: args.city,
                  distance: args.distance,
                  price: args.price,
                  rating: args.rating,
                  availableSpaces: args.availableSpaces,
                  availableLots: args.availableLots,
                  address: args.address,
                  imageOne: args.imageOne,
                  imageTwo: args.imageTwo);
            });
          } else if (settings.name == PaymentSuccessful.routeName) {
            final ReceiptArguments args = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return PaymentSuccessful(
                bookingNumber: args.bookingNumber,
                parkingSpace: args.parkingSpace,
                price: args.price,
                destination: args.destination,
                address: args.address,
              );
            });
          }
        });
  }
}
