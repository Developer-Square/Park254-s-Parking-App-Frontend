import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/functions/auth/resetPassword.dart';
import 'package:park254_s_parking_app/pages/login_page.dart';
import '../config/globals.dart' as globals;

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // Helps in validation of the form.
  final formKey = GlobalKey<FormState>();
  TextEditingController token = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  bool showLoader;

  @override
  void initState() {
    super.initState();
    showLoader = false;
  }

  // Make api.
  sendResetPassword() {
    if (formKey.currentState.validate() &&
        password.text == confirmPassword.text) {
      setState(() {
        showLoader = true;
      });
      resetPassword(token: token.text, password: confirmPassword.text)
          .then((value) {
        if (value == 'success') {
          buildNotification(
              'Password reset successfully. You can now login.', 'success');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
          setState(() {
            showLoader = false;
          });
        }
      }).catchError((err) {
        buildNotification(err.message, 'error');
        setState(() {
          showLoader = false;
        });
      });
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: BackArrow()),
        body: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Spacer(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Column(
                    children: [
                      Text(
                        'Once you reset your password, you can try logging in again.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: globals.textColor,
                            fontSize: 16.5),
                      ),
                      SizedBox(height: 15.0),
                      Form(
                          key: formKey,
                          child: Column(children: <Widget>[
                            _buildFormField(text: 'Token', controller: token),
                            _buildFormField(
                                text: 'Password', controller: password),
                            _buildFormField(
                                text: 'Confirm Password',
                                controller: confirmPassword)
                          ]))
                    ],
                  ),
                ),
                flex: 5,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    sendResetPassword();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: globals.backgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        'Confirm',
                        style: globals.buildTextStyle(
                            18.0, true, globals.textColor),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          showLoader ? Loader() : Container()
        ]),
      ),
    );
  }

  /// Builds out every form field depending on the [text] variable passed to it.
  Widget _buildFormField({String text, TextEditingController controller}) {
    return Column(children: <Widget>[
      Container(
          child: TextFormField(
        validator: (value) {
          if (value == '' || value.isEmpty) {
            return 'Please enter your ${text.toLowerCase()}';
          }
        },
        controller: controller,
        obscureText:
            text == 'Password' || text == 'Confirm Password' ? true : false,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(color: globals.placeHolderColor)),
      )),
      SizedBox(height: 15.0),
    ]);
  }
}
