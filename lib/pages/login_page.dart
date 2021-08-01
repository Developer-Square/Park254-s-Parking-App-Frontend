import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/functions/auth/login.dart';
import 'package:park254_s_parking_app/pages/forgot_password.dart';
import 'package:park254_s_parking_app/pages/home_page.dart';
import 'package:park254_s_parking_app/pages/registration_page.dart';
import 'package:park254_s_parking_app/pages/vendor_page.dart';
import '../config/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  String message;
  LoginPage({this.message});
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// Create a login page, where users can login.
///
/// Has an option at the bottom, where a user can choose to signup.
/// Returns a [Widget].
class _LoginPageState extends State<LoginPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool showLoader;
  bool keyboardVisible;
  int maxRetries;
  final formKey = GlobalKey<FormState>();
  var userDetails = new FlutterSecureStorage();
  var loginDetails;
  bool locationEnabled;

  @override
  void initState() {
    super.initState();
    email.text = 'ryanvendor2@gmail.com';
    password.text = 'ryann254';
    showLoader = false;
    keyboardVisible = false;
    maxRetries = 0;
    locationEnabled = false;
    // Check whether there's a message to display
    if (widget.message != null) {
      if (widget.message.length > 0) {
        buildNotification(widget.message, 'success');
      }
    }
  }

  clearStorage() async {
    await userDetails.deleteAll();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the function will request for permission.
  Future checkPermissions() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return Future.value('true');
    }

    return Future.value('true');
  }

  // Make the api call.
  void sendLoginDetails() async {
    if (formKey.currentState.validate()) {
      // Dismiss the keyboard.
      FocusScope.of(context).unfocus();
      setState(() {
        showLoader = true;
      });
      login(email: email.text, password: password.text).then((value) {
        // Only proceed to the HomePage when permissions are granted.
        checkPermissions().then((permissionValue) {
          if (value.user.id != null) {
            buildNotification('Logged in successfully', 'success');
            setState(() {
              showLoader = false;
              loginDetails = value;
            });

            if (loginDetails != null) {
              // Store the refresh and access userDetails.
              storeLoginDetails(loginDetails, userDetails);
              // Choose how to redirect the user based on the role.
              if (value.user.role == 'user') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(
                          loginDetails: userDetails,
                          storeLoginDetails: storeLoginDetails,
                          clearStorage: clearStorage,
                        )));
              } else if (value.user.role == 'vendor') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VendorPage(
                          loginDetails: userDetails,
                          storeLoginDetails: storeLoginDetails,
                          clearStorage: clearStorage,
                        )));
              }
            }
          }
        });
      }).catchError((err) {
        buildNotification(err.message, 'error');
        print("In login_page");
        print(err);
        setState(() {
          showLoader = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check whether the keyboard is visible.
    MediaQuery.of(context).viewInsets.bottom == 0
        ? setState(() {
            keyboardVisible = true;
          })
        : setState(() {
            keyboardVisible = false;
          });
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: globals.textColor,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              keyboardVisible
                  ? Expanded(
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/Logo/PARK_254_1000x400-01.svg',
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      flex: 3,
                    )
                  : Container(),
              Spacer(
                flex: 1,
              ),
              Expanded(
                child: Container(
                    child: Form(
                  key: formKey,
                  child: Column(children: <Widget>[
                    _buildFormField('Phone number'),
                    SizedBox(height: 15.0),
                    _buildFormField('Password'),
                  ]),
                )),
                flex: 3,
              ),
              Expanded(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      InkWell(
                        onTap: () {
                          sendLoginDetails();
                        },
                        child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(
                                color: globals.backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            child: Center(
                              child: Text('Log in',
                                  style: globals.buildTextStyle(
                                      18.0, true, globals.textColor)),
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'or',
                            style: TextStyle(
                                color: globals.textColor, fontSize: 18.0),
                          ),
                          FlatButton(
                              padding: EdgeInsets.only(right: 10.0),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegistrationPage()));
                              },
                              child: Text(
                                'Sign up',
                                style: globals.buildTextStyle(
                                    18.0, true, globals.backgroundColor),
                              )),
                        ],
                      )
                    ])),
                flex: 2,
              ),
            ],
          ),
          showLoader ? Loader() : Container()
        ],
      ),
    ));
  }

  /// Builds out every form field depending on the [text] variable passed to it.
  Widget _buildFormField(String text) {
    return Column(children: <Widget>[
      Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
            validator: (value) {
              if (value == '' || value.isEmpty) {
                return 'Please enter your ${text.toLowerCase()}';
              }
            },
            controller: text == 'Password' ? password : email,
            obscureText: text == 'Password' ? true : false,
            obscuringCharacter: '*',
            decoration: InputDecoration(
                hintText: text,
                hintStyle: TextStyle(color: globals.placeHolderColor)),
          )),
      text == 'Password'
          ? (Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotResetPassword(
                              pageType: 'forgot',
                            )));
                  },
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: globals.textColor, fontSize: 15.0),
                  )),
            ))
          : SizedBox(height: 0),
    ]);
  }
}
