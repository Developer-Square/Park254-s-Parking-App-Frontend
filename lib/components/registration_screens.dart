import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../components/globals_registration_login.dart' as globals;

class RegistrationScreens extends StatelessWidget {
  final String title;
  final String info;
  final int step;

  RegistrationScreens({this.title, this.info, this.step});

  @override
  Widget build(BuildContext context) {
    //Widget function that displays the inputs
    Widget _buildFormField(String text) {
      return Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: text == 'Password'
                  ? Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Create password',
                              labelStyle: TextStyle(
                                  color: globals.backgroundColor,
                                  fontSize: 19.0),
                              hintText: text,
                              hintStyle:
                                  TextStyle(color: globals.placeHolderColor)),
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Confirm password',
                              labelStyle: TextStyle(
                                  color: globals.backgroundColor,
                                  fontSize: 19.0),
                              hintText: text,
                              hintStyle:
                                  TextStyle(color: globals.placeHolderColor)),
                        ),
                      ],
                    )
                  : text == 'Verification'
                      ? Column(
                          children: [
                            PinCodeTextField(
                              appContext: context,
                              onChanged: (value) {
                                print(value);
                              },
                              length: 6,
                              obscureText: true,
                              obscuringCharacter: '●',
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeColor: globals.backgroundColor,
                                  inactiveColor: Colors.black),
                              animationDuration: Duration(milliseconds: 300),
                              backgroundColor: Colors.white,
                              enableActiveFill: false,
                              onCompleted: (v) {
                                print("Completed");
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                            SizedBox(height: 15.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Didn\'t receive the code?',
                                      style: TextStyle(
                                          color: globals.fontColor
                                              .withOpacity(0.75),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  FlatButton(
                                      onPressed: () {},
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Text('Resend',
                                          style: TextStyle(
                                              color: globals.backgroundColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)))
                                ])
                          ],
                        )
                      : TextFormField(
                          decoration: InputDecoration(
                              hintText: text,
                              hintStyle:
                                  TextStyle(color: globals.placeHolderColor)),
                        )),
        ),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Text(
            info,
            style: TextStyle(
                color: globals.fontColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ),
        SizedBox(height: 35.0),
        _buildFormField(title),
        SizedBox(height: 40.0),
      ],
    );
  }
}
