import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/loader.dart';
import 'package:park254_s_parking_app/functions/auth/register.dart';
import 'package:park254_s_parking_app/pages/login_page.dart';
import '../config/globals.dart' as globals;
import '../components/registration_screens.dart';

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
  bool showToolTip;
  bool showLoader;
  String roleError;
  var details = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController vehicelModel = new TextEditingController();
  TextEditingController vehicelPlate = new TextEditingController();
  TextEditingController createPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _step = 1;
    showToolTip = false;
    showLoader = false;
    roleError = '';
  }

  void validateRadioButton(value) {
    setState(() {
      selectedValue = value;
    });
  }

  void hideToolTip() {
    setState(() {
      showToolTip = false;
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
          info: 'Welcome to Park254, kindly provide your phone number below',
          step: _step,
          formKey: formKey,
          nameController: name,
          emailController: email,
          phoneController: phone);
    } else if (_step == 2) {
      return RegistrationScreens(
        title: 'Verification',
        info: 'Enter the code to verify your account',
        step: _step,
        formKey: formKey,
        verificationController: setVerifiationCode,
      );
    } else if (_step == 3) {
      return RegistrationScreens(
        title: 'Role',
        info: 'Kindly choose the type of account you\'re creating',
        step: _step,
        selectedValue: selectedValue,
        validateFn: validateRadioButton,
        formKey: formKey,
        showToolTip: showToolTip,
        hideToolTip: hideToolTip,
        text: roleError,
      );
    } else if (_step == 4) {
      return RegistrationScreens(
          title: 'Vehicle Details',
          info: 'Enter your vehicle model',
          step: _step,
          formKey: formKey,
          vehicelModelController: vehicelModel,
          vehicelPlateController: vehicelPlate);
    } else if (_step == 5) {
      return RegistrationScreens(
          title: 'Password',
          info: 'Enter your password',
          step: _step,
          formKey: formKey,
          showToolTip: showToolTip,
          hideToolTip: hideToolTip,
          text: roleError,
          createPasswordController: createPassword,
          confirmPasswordController: confirmPassword);
    }
  }

  // Make api call to register a user.
  void sendRegisterDetails() async {
    // ToDo: Add a way to verify the verification code
    //
    // Verify that the user has chosen a role.
    if (_step == 3 && selectedValue == null) {
      setState(() {
        showToolTip = true;
        roleError = 'Kindly choose a role';
      });
    } else if (_step == 3 && selectedValue == 'vendor') {
      setState(() {
        _step += 2;
      });
    } else if (_step == 5) {
      FocusScope.of(context).unfocus();
      if (createPassword.text == confirmPassword.text) {
        setState(() {
          showLoader = true;
        });
        register(
                email: email.text,
                name: name.text,
                password: createPassword.text,
                phone: phone.text)
            .then((value) {
          if (value.user.id != null) {
            setState(() {
              showLoader = false;
              roleError =
                  'You were registered successfully. \n Try Logging in now.';
            });
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage(message: roleError)));
          }
        }).catchError((err) {
          setState(() {
            showLoader = false;
            showToolTip = true;
            roleError = err.message;
          });
        });
      } else {
        setState(() {
          showToolTip = true;
          roleError = 'Passwords don\'t match';
        });
      }
    } else {
      setState(() {
        _step += 1;
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
                ? 'Phone number'
                : _step == 2
                    ? 'Verification'
                    : _step == 3
                        ? 'Role'
                        : _step == 4
                            ? 'Vehicle Details'
                            : 'Password',
            style: globals.buildTextStyle(18.0, true, globals.textColor),
          ),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          SizedBox(height: 40.0),
          Row(
            children: <Widget>[
              _buildSteps('STEP $_step'),
              _buildSteps('of 5'),
            ],
          ),
          SizedBox(height: 170.0),
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
                  if (_step <= 5 && formKey.currentState.validate()) {
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
                      _step == 5 ? 'Finish' : 'Next',
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
