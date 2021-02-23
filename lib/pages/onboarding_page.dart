import 'package:flutter/material.dart';
import 'dart:async';
import '../config/globals.dart' as globals;

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  Timer _timer;
  int _start = 12;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            _start = 12;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  changeScreens() {
    if(_start > 9){
      return Logo();
    } else if (_start > 6 && _start < 10){
      return Find();
    } else if (_start > 3 && _start < 7){
      return StayUpdated();
    } else {
      return Track();
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome',
          style: TextStyle(
              color: globals.textColor
          ),
        ),
      ),
      body: Center(
        child: AnimatedSwitcher(
          child: changeScreens(),
          key: ValueKey(_start),
          duration: Duration(seconds: 1),
        ),
      ),
      backgroundColor: globals.primaryColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          //navigate to search page
        },
        label: Text(
          'Skip',
          style: TextStyle(
            color: globals.textColor
          ),
        ),
        backgroundColor: globals.primaryColor,
      ),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
        image: AssetImage(
          'assets/images/Park254_logo.png',
        ),
        color: Color.fromRGBO(255, 255, 255, 0.5),
        colorBlendMode: BlendMode.modulate
    );
  }
}

class Find extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            child: Icon(
              Icons.near_me,
              semanticLabel: 'find in page icon',
              color: Colors.black54,
              size: 100,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Text(
              'Find the Perfect Parking Lot',
              style: TextStyle(
                  color: globals.textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'We can"t find perfect parking if we can"t find you',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StayUpdated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            child: Icon(
              Icons.notifications,
              semanticLabel: 'Notifications icon',
              color: Colors.black54,
              size: 100,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Text(
              'Stay Updated With Nearby Parking Lot',
              style: TextStyle(
                  color: globals.textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Only important reminders regarding the parking you choose',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Track extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            child: Icon(
              Icons.directions_run,
              semanticLabel: 'Running icon',
              color: Colors.black54,
              size: 100,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Text(
              'Always Find Your Parked Vehicle',
              style: TextStyle(
                  color: globals.textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'We can always help you to locate your vehicle',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}
