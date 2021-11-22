import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/build_formfield.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
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
  String selectedValue;
  Function validateFn;
  final GlobalKey formKey;
  Function verificationController;
  bool showToolTip;
  String text;
  Function hideToolTip;
  TextEditingController _controller = new TextEditingController();
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController vehicleModelController;
  TextEditingController vehiclePlateController;
  TextEditingController createPasswordController;
  TextEditingController confirmPasswordController;

  RegistrationScreens({
    @required this.title,
    @required this.info,
    @required this.step,
    this.selectedValue,
    this.validateFn,
    this.formKey,
    this.nameController,
    this.emailController,
    this.phoneController,
    this.verificationController,
    this.vehicleModelController,
    this.vehiclePlateController,
    this.createPasswordController,
    this.confirmPasswordController,
    this.showToolTip,
    this.hideToolTip,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Render only if we are on the Role or Password page.
            title == 'User Details'
                ? buildNotification(text, 'error')
                : Container(),
            Padding(
              padding: title == 'Password'
                  ? const EdgeInsets.only(left: 30.0, right: 30.0, top: 130.0)
                  : const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              child: Text(
                info,
                style: globals.buildTextStyle(18.0, true, globals.textColor),
              ),
            ),
            SizedBox(height: 35.0),
            BuildFormField(
                text: title,
                context: context,
                placeholder: '',
                controller: _controller,
                selectedValue: selectedValue,
                validateFn: validateFn,
                formKey: formKey,
                email: emailController,
                name: nameController,
                phone: phoneController,
                verification: verificationController,
                vehicleModel: vehicleModelController,
                vehiclePlate: vehiclePlateController,
                createPassword: createPasswordController,
                confirmPassword: confirmPasswordController),
            SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }
}
