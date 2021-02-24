import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import '../components/globals_registration_login.dart' as globals;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  //Widget function that displays the inputs
  Widget _buildFormField(String text) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: text,
                  hintStyle: TextStyle(color: globals.placeHolderColor)),
            )),
      ),
    ]);
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
        resizeToAvoidBottomInset: false,
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
          title: Text(
            'Email',
            style: TextStyle(
                color: globals.fontColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: FooterLayout(
          footer: Text('hey'),
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            SizedBox(height: 40.0),
            Row(
              children: <Widget>[
                _buildSteps('STEP 1'),
                _buildSteps('of 2'),
              ],
            ),
            SizedBox(height: 170.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Text(
                    'Welcome to our Parking app, kindly provide your email below',
                    style: TextStyle(
                        color: globals.fontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 35.0),
                _buildFormField('Email'),
                SizedBox(height: 40.0),
                InkWell(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: globals.backgroundColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      child: Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: globals.fontColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
              ],
            )
          ])),
        ),
      ),
    );
  }
}
