import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/dataModels/UserModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../config/globals.dart' as globals;

/// Builds out every the input fields on registration screens.
///
/// Depending on the [text] variable passed to it.

class BuildFormField extends StatefulWidget {
  final String text;
  final BuildContext context;
  final String placeholder;
  final TextEditingController controller;
  String selectedValue;
  Function validateFn;
  final String label;
  Function verification;
  final GlobalKey formKey;
  TextEditingController name;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController vehicleModel;
  TextEditingController vehiclePlate;
  TextEditingController createPassword;
  TextEditingController confirmPassword;

  BuildFormField({
    this.text,
    this.label,
    this.context,
    this.placeholder,
    this.controller,
    this.selectedValue,
    this.validateFn,
    this.formKey,
    this.name,
    this.email,
    this.phone,
    this.verification,
    this.vehicleModel,
    this.vehiclePlate,
    this.createPassword,
    this.confirmPassword,
  });
  @override
  BuildFormFieldState createState() => BuildFormFieldState();
}

class BuildFormFieldState extends State<BuildFormField> {
  UserModel userModel;
  @override
  initState() {
    super.initState();
    if (mounted) {
      userModel = Provider.of<UserModel>(context, listen: false);
    }
  }

  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: widget.text == 'Password'
                  // Create the two input fields in step 4 of registration screens.
                  ? Column(
                      children: [
                        buildSingleTextField('Create Password', widget.text, '',
                            widget.createPassword),
                        SizedBox(height: 15.0),
                        buildSingleTextField('Confirm Password', widget.text,
                            '', widget.confirmPassword)
                      ],
                    )
                  // Create the verification input field.
                  : widget.text == 'Verification'
                      ? buildVerificationField(context)
                      // Create radio buttons for role selection.
                      : widget.text == 'Role'
                          ? buildRoleRadioButtons()
                          // Create the input fields in the Profile page, Add Parking Lot page and Add vehicle page.
                          : widget.text == 'Profile' ||
                                  widget.text == 'vehicle' ||
                                  widget.text == 'Parking Lot'
                              ? buildSingleTextField(
                                  widget.label,
                                  widget.placeholder,
                                  widget.text,
                                  widget.controller)
                              // Create the phone number input field.
                              : widget.text == 'International Number'
                                  ? buildInternationalNumberField(
                                      widget.controller, widget.placeholder)
                                  // Creates the input fields in step 1 of the registration screens and is reused.
                                  // to create the input fields in step 4
                                  : widget.text == 'Phone number' ||
                                          widget.text == 'Vehicle Details'
                                      ? Column(children: <Widget>[
                                          TextFormField(
                                            controller:
                                                widget.text == 'Phone number'
                                                    ? widget.name
                                                    : widget.vehicleModel,
                                            validator: (value) {
                                              if (value == '' ||
                                                  value.isEmpty) {
                                                return 'Please enter your ${widget.text == 'Phone number' ? 'full name' : 'vehicle model'}';
                                              }
                                              // return value;
                                            },
                                            decoration: InputDecoration(
                                                hintText: widget.text ==
                                                        'Phone number'
                                                    ? 'Full Name'
                                                    : 'Vehicle model e.g. prius or toyota',
                                                hintStyle: TextStyle(
                                                    color: globals
                                                        .placeHolderColor)),
                                          ),
                                          SizedBox(height: 25.0),
                                          TextFormField(
                                            controller:
                                                widget.text == 'Phone number'
                                                    ? widget.phone
                                                    : widget.vehiclePlate,
                                            validator: (value) {
                                              if (value == '' ||
                                                  value.isEmpty) {
                                                return 'Please enter your ${widget.text == 'Phone number' ? 'phone number' : 'vehicle plate number'}';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText: widget.text ==
                                                        'Phone number'
                                                    ? widget.text
                                                    : 'Vehicle plate number e.g. KCB 394F',
                                                hintStyle: TextStyle(
                                                    color: globals
                                                        .placeHolderColor)),
                                          ),
                                          SizedBox(height: 15.0),
                                          widget.text == 'Phone number'
                                              ? buildSingleTextField(
                                                  '', 'Email', '', widget.email)
                                              : Container()
                                        ])
                                      : TextFormField(
                                          validator: (value) {
                                            if (value == '' || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                          },
                                          decoration: InputDecoration(
                                              hintText: widget.text,
                                              hintStyle: TextStyle(
                                                  color: globals
                                                      .placeHolderColor)),
                                        )),
        ),
      ]),
    );
  }

  /// Creates Radio buttons that help a user choose.
  /// which account they're creating.
  Widget buildRoleRadioButtons() {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: globals.textColor,
          value: 'user',
          groupValue: widget.selectedValue,
          onChanged: (value) {
            widget.validateFn(value);
          },
        ),
        Text(
          'Normal User',
          style: globals.buildTextStyle(16.0, true, globals.textColor),
        ),
        Radio(
          value: 'vendor',
          activeColor: globals.textColor,
          groupValue: widget.selectedValue,
          onChanged: (value) {
            widget.validateFn(value);
          },
        ),
        Text(
          'Vendor',
          style: globals.buildTextStyle(16.0, true, globals.textColor),
        )
      ],
    );
  }

  /// Creates a form field with more features e.g. [labelText and labelStyle].
  ///
  /// Requires [label or context], [placeholder], [text] and [controller].
  Widget buildSingleTextField(label, placeholder, text, _controller) {
    return TextFormField(
      // When a vendor is updating a parking lot, disable the parking lot name field.
      enabled: userModel != null
          ? userModel.currentScreen == 'update' && label == 'Parking Lot Name'
              ? false
              : true
          : true,
      validator: (value) {
        if (value == '' || value.isEmpty) {
          return 'Please enter ${placeholder == 'Email' ? 'your email' : 'some text'}';
        }
      },
      controller: _controller,
      obscureText: placeholder == 'Password' ? true : false,
      decoration: InputDecoration(
          // When a vendor is updating a parking lot, add the message that the parking lot name.
          // can't be edited.
          labelText: label != ''
              ? userModel != null
                  ? userModel.currentScreen == 'update' &&
                          label == 'Parking Lot Name'
                      ? '$label(Can\'t be edited)'
                      : label
                  : label
              : null,
          labelStyle: text == 'Profile' || text == 'Parking Lot'
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
          validator: (value) {
            if (value == '' || value.isEmpty) {
              return 'Please enter ${value.length != 6 ? 'a valid' : 'the'} verification code';
            }
          },
          appContext: context,
          onChanged: (value) {
            widget.verification(value);
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
                  image:
                      AssetImage('assets/images/profile/kenya-flag-icon.png'),
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
            validator: (value) {
              if (value == '' || value.isEmpty) {
                return 'Please enter some text';
              }
            },
            controller: _controller,
            decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: globals.placeHolderColor)),
          ),
        )
      ],
    );
  }
}
