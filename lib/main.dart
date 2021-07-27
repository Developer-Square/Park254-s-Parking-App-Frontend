import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
=======
import 'package:overlay_support/overlay_support.dart';
>>>>>>> 12fab5757ce093f7ec7f5cb0cc784c2f14709b2e
import 'package:park254_s_parking_app/components/google_map.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/home_screen.dart';
import 'package:park254_s_parking_app/components/MoreInfo.dart';
import 'package:park254_s_parking_app/components/PaymentSuccessful.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/rating_tab.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/components/tooltip.dart';
import 'package:park254_s_parking_app/config/login_registration_arguements.dart';
import 'package:park254_s_parking_app/config/receiptArguments.dart';
import 'package:park254_s_parking_app/functions/auth/refreshTokens.dart';
import 'package:park254_s_parking_app/functions/users/getUserById.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/components/Booking.dart';
import 'package:park254_s_parking_app/pages/login_page.dart';
import 'package:park254_s_parking_app/pages/search_page.dart';
import 'package:park254_s_parking_app/pages/vendor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/booking_tab.dart';
import 'components/top_page_styling.dart';
import 'config/home_page_arguments.dart';
import 'config/search_page_arguments.dart';
import 'pages/login_screen.dart';
import 'package:park254_s_parking_app/pages/onboarding_page.dart';
import 'package:park254_s_parking_app/config/bookingArguments.dart';
import 'package:park254_s_parking_app/config/moreInfoArguments.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Color(0xff14eeb5);
<<<<<<< HEAD
  final userDetails = new FlutterSecureStorage();

  // Encrypted token.
  var data;
  // User's Id from memory.
  var userId;
  var role;
=======

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // ToDo: Complete the function.
    // display a dialog with the notification details, tap ok to go to another page.
  }

  Future selectNotification(String payload) async {
    // Handle notification tapped logic here.
  }

>>>>>>> 12fab5757ce093f7ec7f5cb0cc784c2f14709b2e
  // This widget is the root of your application.

  initState() {
    super.initState();
    getDetailsFromMemory();
  }

  // Get the encrypted token from memory.
  getDetailsFromMemory() async {
    await SharedPreferences.getInstance().then((prefs) {
      var refresh = prefs.getString('refreshToken');
      var user = prefs.getString('userId');
      setState(() {
        data = refresh;
        userId = user;
      });
    });
    checkForCredentials();
  }

  storeDetailsInMemory(String key, value) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, value);
    }).catchError((err) {
      print(err);
    });
  }

  checkForCredentials() {
    if (data != null) {
      var token = encryptDecryptData('userRefreshToken', data, 'decrypt');
      if (token != null && userId != null) {
        refreshTokens(refreshToken: token).then((value) {
          getUserById(token: value.accessToken.token, userId: userId)
              .then((details) async {
            // Set the user's role to be used later for redirection.
            setState(() {
              role = details.role;
            });
            await userDetails.write(
                key: 'accessToken', value: value.accessToken.token);
            await userDetails.write(
                key: 'refreshToken', value: value.refreshToken.token);
            await userDetails.write(key: 'role', value: details.role);
            await userDetails.write(key: 'name', value: details.name);
            await userDetails.write(key: 'email', value: details.email);
            await userDetails.write(
                key: 'phone', value: details.phone.toString());
            await userDetails.write(key: 'userId', value: userId);
          }).catchError((err) {
            print(err);
          });
          var access = encryptDecryptData(
              'userAccessTokens', value.accessToken.token, 'encrypt');
          var refresh = encryptDecryptData(
              'userRefreshToken', value.refreshToken.token, 'encrypt');
          storeDetailsInMemory('accessToken', access.base64);
          storeDetailsInMemory('refreshToken', refresh.base64);

          // Then redirect the user to the homepage.
        }).catchError((err) {
          print(err);
        });
      }
    }
  }

  clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return Container();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // checkForCredentials();
    return MaterialApp(
        title: 'Park254 Parking App',
        theme: ThemeData(
          primaryColor: primaryColor,
        ),
        home: data != null
            ? role != null
                ? role == 'user'
                    ? HomePage(
                        loginDetails: userDetails,
                        storeLoginDetails: storeLoginDetails,
                        clearStorage: clearStorage,
                      )
                    : VendorPage(
                        loginDetails: userDetails,
                        storeLoginDetails: storeLoginDetails,
                        clearStorage: clearStorage,
                      )
                : Loader()
            : OnBoardingPage(),
        routes: {
          '/login_screen': (context) => LoginScreen(),
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
          } else if (settings.name == HomePage.routeName) {
            final HomePageArguements args = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return HomePage(
                loginDetails: args.loginDetails,
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
                    tokens: args.loginDetails,
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
            final HomePageArguements args4 = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return Column(
                children: [
                  NearByParking(
                      showNearByParkingFn: args1.showNearByParkingFn,
                      hideDetails: args1.hideDetails,
                      mapController: args1.mapController,
=======
    return OverlaySupport(
      child: MaterialApp(
          title: 'Park254 Parking App',
          theme: ThemeData(
            primaryColor: primaryColor,
          ),
          home: OnBoardingPage(),
          routes: {
            '/login_screen': (context) => LoginScreen(),
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
            } else if (settings.name == HomePage.routeName) {
              final HomePageArguements args = settings.arguments;
              return MaterialPageRoute(builder: (context) {
                return HomePage(
                  loginDetails: args.loginDetails,
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
                      tokens: args.loginDetails,
                      mapCreated: args3.mapCreated,
>>>>>>> 12fab5757ce093f7ec7f5cb0cc784c2f14709b2e
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
                    BookingTab(
                        searchBarController: args6.searchBarControllerText)
                  ],
                );
              });
            } else if (settings.name == HomeScreen.routeName) {
              final NearByParkingListArguments args = settings.arguments;
              final NearByParkingArguements args1 = settings.arguments;
              final TopPageStylingArguements args2 = settings.arguments;
              final GoogleMapWidgetArguements args3 = settings.arguments;
              final HomePageArguements args4 = settings.arguments;
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
                      tokens: args4.loginDetails,
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
            } else if (settings.name == LoginPage.routeName) {
              final LoginRegistrationArguements args = settings.arguments;
              return MaterialPageRoute(builder: (context) {
                return ToolTip(
                  showToolTip: args.showToolTip,
                  text: args.text,
                  hideToolTip: args.hideToolTip,
                );
              });
            }
          }),
    );
  }
}
