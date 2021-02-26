import 'package:flutter/material.dart';
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
  /// Builds out every form field depending on the [text] variable passed to it.
  Widget _buildFormField(String text) {
    return Column(children: <Widget>[
      Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
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
                    style: TextStyle(color: globals.fontColor, fontSize: 15.0),
                  )),
            ))
          : SizedBox(height: 0),
    ]);
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
            color: globals.fontColor,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image(
                image: AssetImage(
                  'assets/images/parking-icon.png',
                ),
                color: Colors.grey.withOpacity(0.6),
                height: 300.0,
              ),
            ),
            Container(
                child: Form(
              child: Column(children: <Widget>[
                _buildFormField('Email'),
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
                    onTap: () {},
                    child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: globals.backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        child: Center(
                          child: Text('Log in',
                              style: TextStyle(
                                  color: globals.fontColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'or',
                        style:
                            TextStyle(color: globals.fontColor, fontSize: 18.0),
                      ),
                      FlatButton(
                          padding: EdgeInsets.only(right: 10.0),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                color: globals.backgroundColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ])),
          ],
        ),
      ),
    ));
  }
}
