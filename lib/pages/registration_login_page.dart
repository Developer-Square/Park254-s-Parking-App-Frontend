import 'package:flutter/material.dart';

class RegistrationLoginPage extends StatefulWidget {
  @override
  _RegistrationLoginPageState createState() => _RegistrationLoginPageState();
}

class _RegistrationLoginPageState extends State<RegistrationLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2BE9BA),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 120.0,
            ),
            Container(
                height: 55.0,
                padding: const EdgeInsets.only(left: 60.0),
                child: Transform.rotate(
                  angle: (-360 / 30),
                  child: Icon(
                    Icons.lock,
                    color: Color(0xFF202B30).withOpacity(0.2),
                    size: 90.0,
                  ),
                )),
            SizedBox(height: 100.0),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                child: Text(
                    'You need to sign in or create an account to continue',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202B30),
                        height: 1.5,
                        fontSize: 29.0))),
            SizedBox(height: 240.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 40.0,
                    width: MediaQuery.of(context).size.width - 50,
                  )
                ])
          ],
        ));
  }
}
