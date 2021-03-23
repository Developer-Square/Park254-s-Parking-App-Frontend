import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:park254_s_parking_app/pages/login_screen.dart';
import 'dart:async';
import '../config/globals.dart' as globals;
import '../components/OnBoardingScreen.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  Timer _timer;
  int _start = 20;
  bool _startTimer = true;

  /// Runs a periodic countdown timer of type [Timer]
  ///
  /// Timer can be adjusted by setting [_start]
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          if (_start == 0) {
            setState(() {
              _start = 20;
            });
          } else if (_startTimer == false) {
            timer.cancel();
          } else {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  /// Changes the onboarding screens at set intervals
  ///
  /// Relies on [_start] value which is set by [startTimer()]
  changeScreens() {
    if (_start > 15) {
      return Logo();
    } else if (_start > 10 && _start < 16) {
      return OnBoardingScreen(
          iconName: Icons.near_me,
          iconSemanticLabel: 'find in page icon',
          heading: 'Find the Perfect Parking Lot',
          description: 'We can"t find perfect parking if we can"t find you');
    } else if (_start > 5 && _start < 11) {
      return OnBoardingScreen(
          iconName: Icons.notifications,
          iconSemanticLabel: 'Notifications icon',
          heading: 'Stay Updated With Nearby Parking Lot',
          description:
              'Only important reminders regarding the parking you choose');
    } else {
      return OnBoardingScreen(
          iconName: Icons.directions_run,
          iconSemanticLabel: 'Running icon',
          heading: 'Always Find Your Parked Vehicle',
          description: 'We can always help you to locate your vehicle');
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void deactivate() {
    _timer.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          child: changeScreens(),
          key: ValueKey(_start),
          duration: Duration(seconds: 1),
          transitionBuilder: (widget, animation) => ScaleTransition(
            scale: animation,
            child: widget,
          ),
        ),
      ),
      backgroundColor: globals.primaryColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        label: Text(
          'Skip',
          style: TextStyle(color: globals.textColor),
        ),
        backgroundColor: globals.primaryColor,
      ),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/Logo/PARK_254_1000x400-01.svg',
    );
  }
}
