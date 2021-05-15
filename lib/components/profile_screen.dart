import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/edit_screen.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/components/tooltip.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import 'package:park254_s_parking_app/functions/auth/logout.dart';
import 'package:park254_s_parking_app/pages/login_screen.dart';
import '../config/globals.dart' as globals;

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
  bool showToolTip;
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
    showToolTip = false;
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
        widget.clearStorage();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }).catchError((err) {
      setState(() {
        showLoader = false;
        showToolTip = true;
        errMsg = err.message;
      });
    });
  }

  hideToolTip() {
    setState(() {
      showToolTip = false;
      errMsg = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        ToolTip(showToolTip: showToolTip, text: errMsg, hideToolTip: null),
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
                        widget: buildProfileTab(),
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
                    _buildContainer(widget.logo1Path, true, 'wallet'),
                    SizedBox(height: 1.0),
                    _buildContainer(widget.logo2Path, false, 'wallet'),
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
                    _buildContainer('', false, 'vehicles'),
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

  /// Builds out the card widget.
  ///
  /// Requires a [card] variable.
  Widget _buildCardDetails(card) {
    return Row(
      children: [
        _buildDots(false, card),
        SizedBox(width: 10.0),
        _buildDots(false, card),
        SizedBox(width: 10.0),
        _buildDots(false, card),
        SizedBox(width: 10.0),
        _buildDots(true, card),
      ],
    );
  }

  /// Builds out the wallet section
  ///
  /// Requires [logo] and [card] variables.
  Widget _buildWalletItem(logo, card) {
    return Row(children: <Widget>[
      SvgPicture.asset(
        logo,
        color: Colors.grey,
        width: 40.0,
      ),
      SizedBox(width: 15.0),
      card ? (_buildCardDetails(card)) : (_buildDots(false, card)),
      SizedBox(width: 10.0),
    ]);
  }

  /// Builds out the vehicle section.
  Widget _buildVehicleItem() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'BMW',
            style: globals.buildTextStyle(16.0, true, globals.textColor),
          ),
          Text(
            carPlate,
            style: globals.buildTextStyle(16.0, true, globals.textColor),
          )
        ],
      ),
    );
  }

  /// Builds out the different containers on the page e.g. the vehicle container.
  ///
  /// Requires the [logo], [card] and [type] variables.
  Widget _buildContainer(logo, card, type) {
    return BoxShadowWrapper(
        offsetY: 0.0,
        offsetX: 0.0,
        blurRadius: 4.0,
        opacity: 0.6,
        height: 60.0,
        content: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              type == 'wallet'
                  ? _buildWalletItem(logo, card)
                  : _buildVehicleItem()
            ],
          ),
        ));
  }

  /// Returns dots or numbers.
  Widget _buildDots(number, card) {
    return Text(
      //If it's  card display card details else display phone details.
      card
          ? number
              ? '4567'
              : '● ● ● ●'
          : '● ● ● ● ● ● 7328',
      style: globals.buildTextStyle(16.0, true, Colors.black),
    );
  }

  /// Builds out the profile tab at the top of the page.
  Widget buildProfileTab() {
    return Center(
      child: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width - 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: Hero(
                      tag: widget.profileImgPath,
                      child: Image(
                        height: 60.0,
                        width: 60.0,
                        fit: BoxFit.cover,
                        image: AssetImage(widget.profileImgPath),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    fullNameController.text == ''
                        ? 'User'
                        : fullNameController.text,
                    style:
                        globals.buildTextStyle(16.0, true, globals.textColor),
                  )
                ],
              ),
              Text(
                balance,
                textAlign: TextAlign.right,
                style: globals.buildTextStyle(16.0, true, globals.textColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
