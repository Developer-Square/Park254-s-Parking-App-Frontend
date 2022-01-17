import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

import 'PrimaryText.dart';

/// Creates a custom button
///
/// E.g.
/// ```dart
/// GoButton(onTap: () => _togglePayUp, title: 'Pay now'),
/// ```
class GoButton extends StatelessWidget {
  final Function onTap;
  final String title;

  GoButton({@required this.onTap, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Expanded(
          child: Material(
            color: globals.primaryColor,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: PrimaryText(content: title),
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          flex: 2,
        ),
        Spacer(),
      ],
    );
  }
}
