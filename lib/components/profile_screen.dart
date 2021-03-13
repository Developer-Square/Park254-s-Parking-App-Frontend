import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:park254_s_parking_app/components/BoxShadowWrapper.dart';
import 'package:park254_s_parking_app/components/edit_screen.dart';
import 'package:park254_s_parking_app/components/top_page_styling.dart';
import '../config/globals.dart' as globals;

class ProfileScreen extends StatefulWidget {
  final profileImgPath;
  final logo1Path;
  final logo2Path;

  ProfileScreen(
      {@required this.profileImgPath,
      @required this.logo1Path,
      @required this.logo2Path});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String fullName = 'Rhonda Rousey';
  String carPlate = 'KCB 8793K';
  String carModel = 'BMW';
  String balance = 'Ksh 2005\nbalance';
  String email = 'rhondarousey@gmail.com';
  String phone = '78656789';
  String password = 'password1';

  void updateFields(String currentPage) {
    if (currentPage == 'profile') {
      fullNameController.text = fullName;
      emailController.text = email;
      phoneController.text = phone;
      passwordController.text = password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.grey[200],
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  updateFields('profile');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditScreen(
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
                  style: globals.buildTextStyle(18.0, true, globals.textColor),
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
                      style:
                          globals.buildTextStyle(18.0, true, globals.textColor),
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
              _buildContainer('', false, 'vehicles')
            ]));
  }

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

  Widget _buildContainer(logo, card, type) {
    return BoxShadowWrapper(
        offsetY: 0.0,
        offsetX: 0.0,
        blurRadius: 4.0,
        opacity: 0.6,
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
                    fullName,
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
