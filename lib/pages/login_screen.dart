import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/functions/social%20auth/authService.dart';
import 'package:park254_s_parking_app/pages/login_page.dart';
import '../config/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/// Creates a login screen, where a user can pick different options on.
/// how to login.
///
/// Options include login with [Facebook] and [Google].
/// Returns a [Widget].
class _LoginScreenState extends State<LoginScreen> {
  bool showLoader;
  @override
  initState() {
    super.initState();
    showLoader = false;
  }

  setLoader({bool state}) {
    setState(() {
      showLoader = state;
    });
  }

  @override
  dispose() {
    showLoader = false;
    super.dispose();
  }

  /// Builds out the social logins at the bottom
  Widget _buildSocials({
    String title,
    int buttonColor,
    bool opacity,
  }) {
    return InkWell(
      onTap: showLoader
          ? () {}
          : () {
              AuthService()
                  .signInWithGoogle(context: context, showLoader: setLoader);
            },
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 35,
        height: 50.0,
        decoration: BoxDecoration(
            color: !showLoader
                ? Colors.blue.withOpacity(0.7)
                : Colors.grey.withOpacity(0.8),
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: Center(
          child: Text(title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // This prevents a user from going back to the booking page since we don't want.
        // them to book again.
        onWillPop: () async => false,
        child: SafeArea(
            child: Scaffold(
                backgroundColor: globals.backgroundColor,
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(flex: 1),
                        Expanded(
                          child: Container(
                              height: 55.0,
                              padding: const EdgeInsets.only(left: 60.0),
                              child: Transform.rotate(
                                angle: (-360 / 30),
                                child: Icon(
                                  Icons.lock,
                                  color: Color(0xFF202B30).withOpacity(0.2),
                                  size: 90.0,
                                ),
                              )),
                          flex: 1,
                        ),
                        Spacer(flex: 1),
                        Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 20.0),
                                      child: Text(
                                          'You need to sign in or create an account to continue',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: globals.textColor,
                                              height: 1.7,
                                              fontSize: 31.0))),
                                  Spacer(flex: 1),
                                  Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: showLoader
                                                ? () {}
                                                : () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginPage()));
                                                  },
                                            child: Container(
                                              height: 50.0,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25.0))),
                                              child: Center(
                                                  child: Text(
                                                      'Login with phone number',
                                                      style: globals.buildTextStyle(
                                                          16.0,
                                                          true,
                                                          showLoader
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.8)
                                                              : globals
                                                                  .textColor))),
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text('Or'),
                                          SizedBox(height: 8.0),
                                          InkWell(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  _buildSocials(
                                                    title: 'Google',
                                                    buttonColor: 0,
                                                    opacity: true,
                                                  ),
                                                ],
                                              ))
                                        ]),
                                  ),
                                  Spacer(flex: 1),
                                ],
                              ),
                            ),
                            flex: 5),
                      ]),
                ))));
  }
}
