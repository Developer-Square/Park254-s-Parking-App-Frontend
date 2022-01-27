import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:park254_s_parking_app/components/google_map.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/home_screen.dart';
import 'package:park254_s_parking_app/components/MoreInfo.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/nearby_parking.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/parking%20lots/ParkingInfo.dart';
import 'package:park254_s_parking_app/components/rating_tab.dart';
import 'package:park254_s_parking_app/components/recent_searches.dart';
import 'package:park254_s_parking_app/components/search_bar.dart';
import 'package:park254_s_parking_app/config/login_registration_arguements.dart';
import 'package:park254_s_parking_app/config/parkingInfoArguments.dart';
import 'package:park254_s_parking_app/config/receiptArguments.dart';
import 'package:park254_s_parking_app/dataModels/BookingProvider.dart';
import 'package:park254_s_parking_app/dataModels/VehicleModel.dart';
import 'package:park254_s_parking_app/functions/auth/refreshTokens.dart';
import 'package:park254_s_parking_app/functions/social%20auth/authService.dart';
import 'package:park254_s_parking_app/functions/users/getUserById.dart';
import 'package:park254_s_parking_app/dataModels/NearbyParkingListModel.dart';
import 'package:park254_s_parking_app/dataModels/ParkingLotListModel.dart';
import 'package:park254_s_parking_app/dataModels/ParkingLotModel.dart';
import 'package:park254_s_parking_app/dataModels/RatingListModel.dart';
import 'package:park254_s_parking_app/dataModels/UserModel.dart';
import 'package:park254_s_parking_app/dataModels/NavigationProvider.dart';
import 'package:park254_s_parking_app/dataModels/UserWithTokenModel.dart';
import 'package:park254_s_parking_app/dataModels/UsersListModel.dart';
import 'package:park254_s_parking_app/functions/vehicles/getVehicles.dart';
import 'package:park254_s_parking_app/models/userWithToken.model.dart';
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/components/booking/Booking.dart';
import 'package:park254_s_parking_app/pages/login_page.dart';
import 'package:park254_s_parking_app/pages/onboarding_page.dart';
import 'package:park254_s_parking_app/pages/search%20page/search_page.dart';
import 'package:park254_s_parking_app/pages/vendor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/booking_tab.dart';
import 'components/top_page_styling.dart';
import 'components/transactions/PaymentSuccessful.dart';
import 'config/home_page_arguments.dart';
import 'config/search_page_arguments.dart';
import 'models/token.model.dart';
import 'models/user.model.dart';
import 'pages/login_screen.dart';
import 'package:park254_s_parking_app/config/bookingArguments.dart';
import 'package:park254_s_parking_app/config/moreInfoArguments.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MpesaFlutterPlugin.setConsumerKey('movwC8DA2qfOkAfJBiwxeLHLppJgnM2Z');
  MpesaFlutterPlugin.setConsumerSecret('4r8DAKznXQx1AyPT');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Color(0xff14eeb5);
  // Encrypted token.
  var data;
  // User's Id from memory.
  var userId;
  var role;
  Token accessToken;
  Token refreshToken;
  User userDetails;

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // ToDo: Complete the function.
    // display a dialog with the notification details, tap ok to go to another page.
  }

  Future selectNotification(String payload) async {
    // Handle notification tapped logic here.
  }

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
      log("In storeDetailsMemory, main.dart");
      log(err.toString());
    });
  }

  checkForCredentials() async {
    if (data != null) {
      var token = await encryptDecryptData('userRefreshToken', data, 'decrypt');
      if (token != null && userId != null) {
        refreshTokens(refreshToken: token).then((value) {
          getUserById(token: value.accessToken.token, userId: userId)
              .then((details) async {
            // Set the user's role to be used later for redirection.
            setState(() {
              userDetails = details;
              accessToken = Token(
                  token: value.accessToken.token,
                  expires: value.accessToken.expires);
              refreshToken = Token(
                  token: value.refreshToken.token,
                  expires: value.refreshToken.expires);
              role = details.role;
            });
          }).catchError((err) {
            log("In checkCredentials, main.dart");
            log(err.toString());
            setState(() {
              data = null;
              role = null;
              userDetails = null;
              accessToken = null;
              refreshToken = null;
            });
          });

          var access = encryptDecryptData(
              'userAccessTokens', value.accessToken.token, 'encrypt');
          var refresh = encryptDecryptData(
              'userRefreshToken', value.refreshToken.token, 'encrypt');
          storeDetailsInMemory('accessToken', access.base64);
          storeDetailsInMemory('refreshToken', refresh.base64);
          if (userDetails != null) {
            storeDetailsInMemory('userId', userDetails.id);
          }

          // Then redirect the user to the homepage.
        }).catchError((err) {
          setState(() {
            data = null;
            userId = null;
            userDetails = null;
            accessToken = null;
            refreshToken = null;
          });
          log(err.toString());
          log("In main.dart");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserWithTokenModel>(
            create: (context) => UserWithTokenModel()),
        ChangeNotifierProvider<ParkingLotModel>(
            create: (context) => ParkingLotModel()),
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
        ChangeNotifierProvider<ParkingLotListModel>(
            create: (context) => ParkingLotListModel()),
        ChangeNotifierProvider<NearbyParkingListModel>(
            create: (context) => NearbyParkingListModel()),
        ChangeNotifierProvider<UsersListModel>(
            create: (context) => UsersListModel()),
        ChangeNotifierProvider<RatingListModel>(
            create: (context) => RatingListModel()),
        ChangeNotifierProvider<TransactionModel>(
            create: (context) => TransactionModel()),
        ChangeNotifierProvider<NavigationProvider>(
            create: (context) => NavigationProvider()),
        ChangeNotifierProvider<BookingProvider>(
            create: (context) => BookingProvider()),
        ChangeNotifierProvider<VehicleModel>(
            create: (context) => VehicleModel()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Park254 Parking App',
            theme: ThemeData(
              primaryColor: primaryColor,
            ),
            home: data != null
                ? role != null
                    ? role == 'user'
                        ? HomePage(
                            userDetails: userDetails,
                            accessToken: accessToken,
                            refreshToken: refreshToken,
                          )
                        : VendorPage(
                            userDetails: userDetails,
                            accessToken: accessToken,
                            refreshToken: refreshToken,
                          )
                    : Loader()
                // If there's no data redirect the user to the onboarding page.
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
                return MaterialPageRoute(builder: (context) {
                  return HomePage();
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
                        currentPage: args3.currentPage,
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
                final RatingTabArguements args5 = settings.arguments;
                final SearchBarArguements args6 = settings.arguments;
                final RecentSearchesArguements args7 = settings.arguments;
                final BookingTabArguements args8 = settings.arguments;
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
                        currentPage: args3.currentPage,
                        mapCreated: args3.mapCreated,
                        customInfoWindowController:
                            args3.customInfoWindowController,
                      ),
                      RatingTab(
                        hideRatingTabFn: args5.hideRatingTabFn,
                        parkingPlaceName: args5.parkingPlaceName,
                      ),
                      SearchBar(
                          offsetY: args6.offsetY,
                          blurRadius: args6.blurRadius,
                          opacity: args6.opacity,
                          controller: args6.controller,
                          searchBarTapped: args6.searchBarTapped),
                      RecentSearches(
                        setShowRecentSearches: args7.setShowRecentSearches,
                        town: args7.town,
                        specificLocation: args7.specificLocation,
                      ),
                      BookingTab(
                          searchBarController: args8.searchBarControllerText)
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
                      address: args.address,
                      imageOne: args.imageOne,
                      imageTwo: args.imageTwo);
                });
              } else if (settings.name == PaymentSuccessful.routeName) {
                final ReceiptArguments args = settings.arguments;
                return MaterialPageRoute(builder: (context) {
                  return PaymentSuccessful(
                    bookingId: args.bookingId,
                    price: args.price,
                    destination: args.destination,
                    arrivalTime: args.arrivalTime,
                    arrivalDate: args.arrivalDate,
                    leavingTime: args.leavingTime,
                    leavingDate: args.leavingDate,
                  );
                });
              } else if (settings.name == ParkingInfo.routeName) {
                final ParkingInfoArguments args = settings.arguments;
                return MaterialPageRoute(builder: (context) {
                  return ParkingInfo(
                    images: args.images,
                    name: args.name,
                    accessibleParking: args.accessibleParking,
                    cctv: args.cctv,
                    carWash: args.carWash,
                    evCharging: args.evCharging,
                    valetParking: args.valetParking,
                    rating: args.rating,
                  );
                });
              }
            }),
      ),
    );
  }
}
