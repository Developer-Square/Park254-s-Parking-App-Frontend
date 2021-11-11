import 'package:flutter/material.dart';
import '../../BackArrow.dart';
import '../../../config/globals.dart' as globals;

class CancellationPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cancellation Policy',
            style: globals.buildTextStyle(16.0, true, globals.textColor),
          ),
          centerTitle: true,
          leading: BackArrow(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
            child: SizedBox(
              child: Column(children: <Widget>[
                Text(
                  'Plans change. We get it. Receive a full refund or free cancellation until 6 hours before check-in (time shown in the parking pass). After that, cancel before check-in and get a 70% refund, minus the service fee.',
                  style: globals.buildTextStyle(14.0, false, globals.textColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'You can cancel your spot by going to “My Parking”  in your account and clicking CANCEL. If you need to cancel after your reservation’s start time, call our customer service team at 0729558499',
                  style: globals.buildTextStyle(14.0, false, globals.textColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Our mission is to make parking easy. If anything about your experience goes awry, let us know and we’ll make it right.',
                  style: globals.buildTextStyle(14.0, false, globals.textColor),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'How long does it take to get a refund?',
                    style:
                        globals.buildTextStyle(14.5, true, globals.textColor),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'We send refunds immediately upon cancellation and they usually show up within 3-5 days, but sometimes it takes a little longer before they reflect on the original payment method.',
                  style: globals.buildTextStyle(14.0, false, globals.textColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
