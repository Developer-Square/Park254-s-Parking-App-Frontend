import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/home_screen.dart';
import 'package:park254_s_parking_app/components/myparking_screen.dart';
import 'package:park254_s_parking_app/components/profile_screen.dart';
import '../config/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// Creates a page depending on which tab icon is active.
///
/// Includes the following screens:
/// [HomeScreen], which contains google maps, parking location markers and nearby parking list.
/// [MyParkingScreen] which contains the history of places the user has parked before.
/// [ProfileScreen] which contains all the profile details of the user.
/// When a user clicks on one of the icons at the bottom he/she is directed to a different page.
class _HomePageState extends State<HomePage> {
  var _activeTab = 'home';

  /// Determines which inputs will be displayed depending on the step count.
  ///
  /// Passes in the info to build out the different steps as parameters.
  /// The parameters include [title], [info] and [step].
  changeScreens() {
    if (_activeTab == 'home') {
      return HomeScreen();
    } else if (_activeTab == 'profile') {
      return ProfileScreen(
        profileImgPath: 'assets/images/profile/profile-1.jpg',
        logo1Path: 'assets/images/profile/visa_2.svg',
        logo2Path: 'assets/images/profile/mpesa.svg',
      );
    } else {
      return MyParkingScreen();
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          AnimatedSwitcher(
            child: changeScreens(),
            key: ValueKey(_activeTab),
            duration: Duration(seconds: 2),
            transitionBuilder: (widget, animation) =>
                ScaleTransition(scale: animation, child: widget),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildNavigatorIcons('home', 'Home'),
                      _buildNavigatorIcons('parking', 'My Parking'),
                      _buildNavigatorIcons('profile', 'Profile')
                    ],
                  ))),
        ],
      ),
    ));
  }

  /// Creates the navigation buttons at the bottom of the page.
  Widget _buildNavigatorIcons(String icon, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          _activeTab = icon;
        });
      },
      child: Column(
        children: [
          Icon(
            icon == 'home'
                ? Icons.home_filled
                : icon == 'parking'
                    ? Icons.local_parking
                    : Icons.person_outline,
            color: _activeTab == icon
                ? globals.textColor
                : Colors.grey.withOpacity(0.8),
          ),
          Text(
            text,
            style: globals.buildTextStyle(
                12.0,
                true,
                _activeTab == icon
                    ? globals.textColor
                    : Colors.grey.withOpacity(0.8)),
          )
        ],
      ),
    );
  }
}
