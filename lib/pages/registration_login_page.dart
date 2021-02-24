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
                        color: Color(0xFF212832),
                        height: 1.5,
                        fontSize: 29.0))),
            SizedBox(height: 200.0),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterailPageRoute(
                        //   builder: (context) => LoginPage
                        // ))
                      },
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        child: Center(
                            child: Text('Login with email',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212832)))),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 35,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Color(0xFF3C5898),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                              child: Center(
                                child: Text('Facebook',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 35,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                              child: Center(
                                child: Text('Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          ],
        ));
  }
}

class MediaQuer {}
