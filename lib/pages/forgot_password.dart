import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/SimpleTextField.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/functions/auth/forgotPassword.dart';
import 'package:park254_s_parking_app/pages/reset_password.dart';
import '../config/globals.dart' as globals;

class ForgotResetPassword extends StatefulWidget {
  final String pageType;

  ForgotResetPassword({@required this.pageType});

  @override
  _ForgotResetPasswordState createState() => _ForgotResetPasswordState();
}

class _ForgotResetPasswordState extends State<ForgotResetPassword> {
  // Helps in validation of the form.
  final formKey = GlobalKey<FormState>();
  TextEditingController forgotEmail = new TextEditingController();
  bool showLoader;

  @override
  void initState() {
    super.initState();
    showLoader = false;
  }

  // Make api.
  sendForgotEmail() {
    if (formKey.currentState.validate()) {
      setState(() {
        showLoader = true;
      });
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => ResetPassword()));
      forgotPassword(email: forgotEmail.text).then((value) {
        if (value == 'success') {
          buildNotification(
              'Check your email for the token we\'ve sent', 'success');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ResetPassword()));
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
                        'Once you input your email and click \'Send\' you\'ll get an email from us to reset your password.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: globals.textColor,
                            fontSize: 16.5),
                      ),
                      SizedBox(height: 15.0),
                      Form(
                        key: formKey,
                        child: SimpleTextField(
                          validate: true,
                          placeholder: 'Email',
                          controller: forgotEmail,
                          fontWeight: FontWeight.normal,
                          textColor: globals.textColor,
                          decorate: true,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Kindly enter your email',
                              labelStyle:
                                  TextStyle(color: globals.backgroundColor)),
                          alignLeft: true,
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 2,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    sendForgotEmail();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: globals.backgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        'Send',
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
}
