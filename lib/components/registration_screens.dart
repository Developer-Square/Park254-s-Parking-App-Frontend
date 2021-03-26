import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import '../config/globals.dart' as globals;

/// Creates the input widgets that are displayed on each of the registration pages.
///
/// Requires a [title] which acts as the placeholder, [info] which gives the user.
/// more information and finally [step] so to be displayed on the top left.
/// Returns a [Widget].
class RegistrationScreens extends StatelessWidget {
  final String title;
  final String info;
  final int step;
  TextEditingController _controller = new TextEditingController();

  RegistrationScreens(
      {@required this.title, @required this.info, @required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: title == 'Password'
              ? const EdgeInsets.only(left: 30.0, right: 30.0, top: 130.0)
              : const EdgeInsets.only(left: 30.0, right: 30.0, top: 160.0),
          child: Text(
            info,
            style: globals.buildTextStyle(18.0, true, globals.textColor),
          ),
        ),
        SizedBox(height: 35.0),
        buildFormField(title, context, '', _controller),
        SizedBox(height: 40.0),
      ],
    );
  }
}
