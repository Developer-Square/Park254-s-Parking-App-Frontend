import 'package:flutter/material.dart';

/// Dismisses keyboard when user touches a stateless widget
///
/// Wrap around the desired widget
/// E.g.
/// ```dart
/// DismissKeyboard(
///   child: Container()
/// );
/// ```
class DismissKeyboard extends StatelessWidget {
  final Widget child;

  DismissKeyboard({
    @required this.child
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }
}