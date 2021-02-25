import 'package:flutter/material.dart';
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
  int _step = 1;

  /// Determines which inputs will be displayed depending on the step count.
  ///
  /// Passes in the info to build out the different steps as parameters.
  /// The parameters include [title], [info] and [step].
  changeScreens() {
    if (_step == 1) {
      return RegistrationScreens(
          title: 'Email',
          info: 'Welcome to our Parking app, kindly provide your email below',
          step: _step);
    } else if (_step == 2) {
      return RegistrationScreens(
          title: 'Verification',
          info: 'Enter the code to verify your account',
          step: _step);
    } else if (_step == 3) {
      return RegistrationScreens(
          title: 'Password', info: 'Enter your password', step: _step);
    }
  }

  Widget _buildSteps(String text) {
    return Padding(
      padding: text.contains('STEP')
          ? EdgeInsets.only(left: 30.0)
          : EdgeInsets.only(left: 5.0),
      child: Text(text,
          style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: text.contains('STEP')
                  ? globals.fontColor
                  : Colors.grey.withOpacity(0.9))),
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
              color: globals.fontColor,
              onPressed: () {
                _step > 1
                    ? setState(() {
                        _step -= 1;
                      })
                    : Navigator.of(context).pop();
              }),
          title: Text(
            _step == 1
                ? 'Email'
                : _step == 2
                    ? 'Verification'
                    : 'Password',
            style: TextStyle(
                color: globals.fontColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(height: 40.0),
          Row(
            children: <Widget>[
              _buildSteps('STEP $_step'),
              _buildSteps('of 3'),
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
          InkWell(
              onTap: () {
                setState(() {
                  if (_step < 3) {
                    _step += 1;
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 50.0,
                decoration: BoxDecoration(
                    color: globals.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Center(
                  child: Text(
                    _step == 3 ? 'Finish' : 'Next',
                    style: TextStyle(
                        color: globals.fontColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
        ])),
      ),
    );
  }
}
