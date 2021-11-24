import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/functions/auth/register.dart';
import 'package:park254_s_parking_app/functions/vehicles/createVehicle.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import 'package:park254_s_parking_app/pages/login_page.dart';
import '../config/globals.dart' as globals;
import '../components/registration_screens.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

/// Creates a registration page, where a user can register an account.
///
/// The page has a three steps, email submission, email verification.
/// and password selection.
/// Returns a [Widget].
class _RegistrationPageState extends State<RegistrationPage> {
  int _step;
  String selectedValue;
  String verification;
  bool showLoader;
  String roleError;
  String verificationID;
  var details = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController vehicleModel = new TextEditingController();
  TextEditingController vehiclePlate = new TextEditingController();
  TextEditingController createPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _step = 1;
    showLoader = false;
    roleError = '';
  }

  void validateRadioButton(value) {
    setState(() {
      selectedValue = value;
    });
  }

// Get the verification from the PinCodeTextField and add to state.
  void setVerifiationCode(value) {
    setState(() {
      verification = value;
    });
  }

  /// Determines which inputs will be displayed depending on the step count.
  ///
  /// Passes in the info to build out the different steps as parameters.
  /// The parameters include [title], [info] and [step].
  changeScreens() {
    if (_step == 1) {
      return RegistrationScreens(
        title: 'Phone number',
        info: 'Welcome to Park254, kindly provide your details below',
        step: _step,
        formKey: formKey,
        nameController: name,
        emailController: email,
        phoneController: phone,
        selectedValue: selectedValue,
        validateFn: validateRadioButton,
        createPasswordController: createPassword,
        confirmPasswordController: confirmPassword,
      );
    } else if (_step == 2) {
      return RegistrationScreens(
        title: 'Verification',
        info: 'Enter the code to verify your account',
        step: _step,
        formKey: formKey,
        verificationController: setVerifiationCode,
      );
    }
  }

  // Make api call to register a user.
  void sendRegisterDetails() async {
    // Verify that the user has chosen a role.
    if (_step == 1 && selectedValue == null) {
      buildNotification('Kindly choose a role', 'error');
    } else if (_step == 1) {
      if (createPassword.text != confirmPassword.text) {
        buildNotification('Passwords don\'t match', 'error');
      } else {
        FocusScope.of(context).unfocus();
        firebaseVerification();
        setState(() {
          _step += 1;
        });
      }
    } else if (_step == 2) {
      FocusScope.of(context).unfocus();
      verifyCode();
      setState(() {
        showLoader = true;
      });
      register(
        email: email.text,
        name: name.text,
        password: createPassword.text,
        phone: phone.text,
        role: selectedValue,
      ).then((value) {
        if (value.user.id != null) {
          setState(() {
            showLoader = false;
            buildNotification(
                'You were registered successfully. Try Logging in now.',
                'success');
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(message: roleError)));
        }
      }).catchError((err) {
        setState(() {
          showLoader = false;
        });
        buildNotification(err.message, 'error');
      });
    }
  }

  // Verify the user's code.
  void verifyCode() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (verification != null) {
      String smsCode = verification.trim();

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: smsCode);

      try {
        // Sign the user in (or link) with the credential
        var firebaseUser = await auth.signInWithCredential(credential);
        if (firebaseUser.user.phoneNumber != null) {
          buildNotification('Verification complete', 'success');
          setState(() {
            _step += 1;
          });
        } else {
          buildNotification(
              'Verification code failed, Kindly try again', 'error');
        }
      } catch (e) {
        log(e.toString());
        buildNotification(e.toString().substring(32), 'error');
      }
    }
  }

  // Change the number to international format because that's what.
  // firebase is expecting.
  String refinePhoneNumber({String phone}) {
    if (phone.substring(0, 1) == '0') {
      return '+254' + phone.substring(1);
    } else if (phone.substring(0, 1) == '2') {
      return '+' + phone;
    } else if (phone.substring(0, 1) == '+') {
      return phone;
    }
  }

  // Verify a user's phone number.
  void firebaseVerification() async {
    setState(() {
      _step += 1;
    });
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      // Add a plus to make the phone number valid.
      phoneNumber: refinePhoneNumber(phone: phone.text),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // ANDROID ONLY.
        log('No automatic code verification');
      },
      verificationFailed: (FirebaseAuthException error) {
        if (error.code == 'invalid-phone-number') {
          buildNotification('The provided number is not valid', 'error');
        } else {
          log(error.toString());
          buildNotification('Something went wrong, kindly try again', 'error');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        setState(() {
          verificationID = verificationId;
        });
        // Update the UI - wait for the user to enter the SMS code
        buildNotification('Check for the code and add it manually', 'info');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('no automatic code verification');
      },
    );
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
              icon: Icon(Icons.arrow_back_outlined),
              color: globals.textColor,
              onPressed: () {
                _step > 1
                    ? setState(() {
                        _step -= 1;
                      })
                    : Navigator.of(context).pop();
              }),
          title: Text(
            _step == 1
                ? 'User Details'
                : _step == 2
                    ? 'Verification'
                    : '',
            style: globals.buildTextStyle(18.0, true, globals.textColor),
          ),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          SizedBox(height: 40.0),
          Row(
            children: <Widget>[
              _buildSteps('STEP $_step'),
              _buildSteps('of 2'),
            ],
          ),
          AnimatedSwitcher(
            child: changeScreens(),
            key: ValueKey(_step),
            duration: Duration(seconds: 2),
            transitionBuilder: (widget, animation) =>
                ScaleTransition(scale: animation, child: widget),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () {
                  // Validate the form.
                  if (_step <= 2 && formKey.currentState.validate()) {
                    // Get and record details from every page.
                    sendRegisterDetails();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: globals.backgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      _step == 2 ? 'Finish' : 'Next',
                      style:
                          globals.buildTextStyle(18.0, true, globals.textColor),
                    ),
                  ),
                )),
          ),
          // Adding a loader
          showLoader ? Loader() : Container()
        ]),
      ),
    );
  }

  Widget _buildSteps(String text) {
    return Container(
      child: Padding(
        padding: text.contains('STEP')
            ? EdgeInsets.only(left: 30.0, top: 40.0)
            : EdgeInsets.only(left: 5.0, top: 40.0),
        child: Text(text,
            style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: text.contains('STEP')
                    ? globals.textColor
                    : Colors.grey.withOpacity(0.9))),
      ),
    );
  }
}
