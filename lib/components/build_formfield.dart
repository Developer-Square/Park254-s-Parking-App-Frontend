import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../config/globals.dart' as globals;

/// Builds out every form field depending on the [text] variable passed to it.
Widget buildFormField(String text, context, placeholder, _controller) {
  return Column(children: <Widget>[
    Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: text == 'Password'
              ? Column(
                  children: [
                    buildSingleTextField(
                        'Create Password', text, '', _controller),
                    SizedBox(height: 15.0),
                    buildSingleTextField(
                        'Confirm Password', text, '', _controller)
                  ],
                )
              : text == 'Verification'
                  ? buildVerificationField(context)
                  : text == 'Profile' || text == 'vehicle'
                      ? buildSingleTextField(
                          context, placeholder, text, _controller)
                      : text == 'International Number'
                          ? buildInternationalNumberField(
                              _controller, placeholder)
                          : TextFormField(
                              decoration: InputDecoration(
                                  hintText: text,
                                  hintStyle: TextStyle(
                                      color: globals.placeHolderColor)),
                            )),
    ),
  ]);
}

/// Creates a form field with more features e.g. [labelText and labelStyle].
///
/// Requires [label or context], [placeholder], [text] and [controller].
Widget buildSingleTextField(label, placeholder, text, _controller) {
  return TextFormField(
    controller: _controller,
    obscureText: placeholder == 'Password' ? true : false,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: text == 'Profile'
            ? TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 18.0)
            : TextStyle(color: globals.backgroundColor, fontSize: 18.0),
        hintText: placeholder,
        hintStyle: TextStyle(color: globals.placeHolderColor)),
  );
}

/// Creates a verification text field with all the necessary functions.
///
/// It also has a text widget and flat button at the bottom.
/// Requires [context].
Widget buildVerificationField(context) {
  return Column(
    children: [
      /// A pub.dev library that builds out the pin code input field in step 2.
      ///
      /// makes handling of the inputs easier and has a few parameters you can play with.
      /// example:
      /// dart ```
      /// obscuringCharacter: '●'
      /// ```
      /// can be changed to.
      /// dart```
      /// obscuringCharacter: '*'.
      /// ```
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

        /// if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        ///
        /// but you can show anything you want here, like your pop up saying wrong paste format or etc.
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          return true;
        },
      ),
      SizedBox(height: 15.0),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text('Didn\'t receive the code?',
            style: TextStyle(
                color: globals.textColor.withOpacity(0.75),
                fontSize: 16.0,
                fontWeight: FontWeight.bold)),
        FlatButton(
            onPressed: () {},
            padding: EdgeInsets.only(right: 20.0),
            child: Text('Resend',
                style: globals.buildTextStyle(
                    16.0, true, globals.backgroundColor)))
      ])
    ],
  );
}

/// Creates a international number field with a prefix e.g. [+254]
///
/// Requires [_controller] and [placeholder].
Widget buildInternationalNumberField(_controller, placeholder) {
  return Row(
    children: [
      Hero(
          tag: 'assets/images/profile/kenya-flag-icon.png',
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profile/kenya-flag-icon.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: 30.0,
            width: 40.0,
          )),
      SizedBox(width: 10.0),
      Text(
        '+254',
        style: globals.buildTextStyle(16.0, true, globals.textColor),
      ),
      SizedBox(width: 10.0),
      Expanded(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: globals.placeHolderColor)),
        ),
      )
    ],
  );
}
