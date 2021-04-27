import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:park254_s_parking_app/functions/auth/login.dart';
import 'package:park254_s_parking_app/pages/registration_page.dart';
import '../config/globals.dart' as globals;

class LoginPage extends StatefulWidget {
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
  bool showToolTip;
  String text;

  @override
  void initState() {
    super.initState();
    email.text = 'ryan25@gmail.com';
    password.text = 'password1';
    showToolTip = false;
    text = '';
  }

  // Make the api call.
  void sendLoginDetails() async {
    if (email.text != '' && password.text != '') {
      // Dismiss the keyboard.
      FocusScope.of(context).unfocus();
      login(email: email.text, password: password.text).then((value) {
        // Todo: Add a way to store credentials in the phone.
        if (value.user.id != null) {
          print(value.user.id);
        }
      }).catchError((err) {
        setState(() {
          showToolTip = true;
          text = err;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            toolTip(text),
            Container(
              child: SvgPicture.asset(
                'assets/images/Logo/PARK_254_1000x400-01.svg',
                width: 230.0,
                height: 230.0,
              ),
            ),
            SizedBox(height: 65.0),
            Container(
                child: Form(
              child: Column(children: <Widget>[
                _buildFormField('Phone number'),
                SizedBox(height: 15.0),
                _buildFormField('Password'),
              ]),
            )),
            SizedBox(height: 40.0),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  InkWell(
                    onTap: () {
                      sendLoginDetails();
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => HomePage()));
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
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'or',
                        style:
                            TextStyle(color: globals.textColor, fontSize: 18.0),
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
          ],
        ),
      ),
    ));
  }

  /// A widget meant to inform the user of any errors during.
  /// the login process.
  /// Requires [Text].
  Widget toolTip(String text) {
    return AnimatedOpacity(
      opacity: showToolTip ? 1.0 : 0.0,
      duration: Duration(milliseconds: 600),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(right: 8.0),
          width: 250.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.red,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 25.0),
                child: Text(
                  text,
                  style: globals.buildTextStyle(14.0, false, Colors.white),
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      showToolTip = false;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  /// Builds out every form field depending on the [text] variable passed to it.
  Widget _buildFormField(String text) {
    return Column(children: <Widget>[
      Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
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
                  onPressed: () {},
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
