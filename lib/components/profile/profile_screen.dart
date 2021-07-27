import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/components/profile/edit_screen.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/functions/auth/logout.dart';
import 'package:park254_s_parking_app/pages/login_screen.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import '../../config/globals.dart' as globals;
import 'helpers.dart';

/// Creates a profile screen.
///
/// Requires [profileImgPath], [logo1Path] and [logo2Path].
/// Updates the edit profile page fields.
class ProfileScreen extends StatefulWidget {
  final profileImgPath;
  final logo1Path;
  final logo2Path;
  FlutterSecureStorage loginDetails;
  Function clearStorage;

  ProfileScreen(
      {@required this.profileImgPath,
      @required this.logo1Path,
      @required this.logo2Path,
      @required this.loginDetails,
      this.clearStorage});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool showLoader;
  String errMsg;

  String fullName;
  String carPlate = 'KCB 8793K';
  // String carModel = 'BMW';
  String balance = 'Ksh 2005\nbalance';
  // String email = 'rhondarousey@gmail.com';
  // String phone = '78656789';
  // String password = 'password1';

  @override
  void initState() {
    super.initState();
    showLoader = false;
    errMsg = '';
    fullName = '';
    // Add user's details to the inputs fields.
    updateFields('profile');
  }

  void updateFields(String currentPage) async {
    if (currentPage == 'profile') {
      var name = await widget.loginDetails.read(key: 'name');
      fullNameController.text = name;
      emailController.text = await widget.loginDetails.read(key: 'email');
      phoneController.text = await widget.loginDetails.read(key: 'phone');

      setState(() {
        fullName = name;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Make api call.
  logoutUser() async {
    setState(() {
      showLoader = true;
    });
    var token = await widget.loginDetails.read(key: 'refreshToken');
    logout(refreshToken: token).then((value) {
      if (value == 'success') {
        setState(() {
          showLoader = false;
        });
        // Clear all the user's details.
        clearStorage(widget.loginDetails);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }).catchError((err) {
      // buildNotification(err.message, 'error');
      setState(() {
        showLoader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Material(
              color: Colors.grey[200],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditScreen(
                                  loginDetails: widget.loginDetails,
                                  profileImgPath: widget.profileImgPath,
                                  fullName: fullNameController,
                                  email: emailController,
                                  phone: phoneController,
                                  password: passwordController,
                                  currentScreen: 'profile',
                                )));
                      },
                      child: TopPageStyling(
                        currentPage: 'profile',
                        widget: buildProfileTab(
                            context, widget, fullNameController, balance),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Wallet',
                        style: globals.buildTextStyle(
                            18.0, true, globals.textColor),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    buildContainer(widget.logo1Path, true, 'wallet', carPlate),
                    SizedBox(height: 1.0),
                    buildContainer(widget.logo2Path, false, 'wallet', carPlate),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vehicles',
                            style: globals.buildTextStyle(
                                18.0, true, globals.textColor),
                          ),
                          InkWell(
                            onTap: () {
                              updateFields('vehicles');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditScreen(
                                        currentScreen: 'vehicles',
                                      )));
                            },
                            child: Container(
                              width: 37.0,
                              height: 37.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  color: Colors.white),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    buildContainer('', false, 'vehicles', carPlate),
                    SizedBox(height: 20.0),
                    Center(
                      child: InkWell(
                        onTap: () {
                          logoutUser();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                color: Colors.red[400]),
                            child: Center(
                                child: Text(
                              'Logout',
                              style: globals.buildTextStyle(
                                  15.0, true, Colors.white),
                            ))),
                      ),
                    ),
                    SizedBox(height: 80.0)
                  ])),
        ),
        showLoader ? Loader() : Container()
      ]),
    );
  }
}
