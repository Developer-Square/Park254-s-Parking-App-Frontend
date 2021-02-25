import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// Creates a screen for the onboarding section
///
/// Requires [iconName], [iconSemanticLabel], [heading], and [description]
/// Returns a [Widget]
/// Example:
/// ```dart
/// OnBoardingScreen(
///   iconName: Icons.near_me,
///   iconSemanticLabel: 'find in page icon',
///   heading: 'Find the Perfect Parking Lot',
///   description: 'We can"t find perfect parking if we can"t find you'
/// );
/// ```
class OnBoardingScreen extends StatelessWidget {
  final IconData iconName;
  final String iconSemanticLabel;
  final String heading;
  final String description;

  OnBoardingScreen({
    @required this.iconName,
    @required this.iconSemanticLabel,
    @required this.heading,
    @required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Icon(
                iconName,
                semanticLabel: iconSemanticLabel,
                color: Colors.black54,
                size: 100,
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Text(
                heading,
                style: TextStyle(
                    color: globals.textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              child: Text(
                description,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }
}