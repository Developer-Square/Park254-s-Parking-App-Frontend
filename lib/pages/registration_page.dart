import 'package:flutter/material.dart';
import '../components/globals_registration_login.dart' as globals;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _step = 1;

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
              icon: Icon(Icons.arrow_back_ios),
              color: globals.fontColor,
              onPressed: () {
                setState(() {
                  _step -= 1;
                });
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
            duration: Duration(seconds: 1),
            transitionBuilder: (widget, animation) =>
                ScaleTransition(scale: animation, child: widget),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  _step += 1;
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
