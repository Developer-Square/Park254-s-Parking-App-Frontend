import 'package:flutter/material.dart';

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