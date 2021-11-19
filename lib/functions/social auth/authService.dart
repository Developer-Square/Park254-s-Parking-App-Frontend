import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:park254_s_parking_app/components/helper_functions.dart';
import 'package:park254_s_parking_app/functions/auth/login.dart';
import 'package:park254_s_parking_app/functions/auth/register.dart';
import 'package:park254_s_parking_app/functions/users/createUser.dart';
import 'package:park254_s_parking_app/functions/utils/checkPermissions.dart';
import 'package:park254_s_parking_app/functions/utils/passwordGenerator.dart';
import 'package:park254_s_parking_app/pages/onboarding_page.dart';
import 'package:park254_s_parking_app/pages/vendor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/login_screen.dart';
import '../../pages/home_page.dart';
import 'package:encrypt/encrypt.dart' as encryptionPackage;

class AuthService {
  // Determine if the user is authenticated and redirect accordingly
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          // TODO: Add a method to get the token from the backend.
          return HomePage();
        } else {
          // user not authorized redirect to login page.
          return OnBoardingPage();
        }
      },
    );
  }

  Future<UserCredential> signInWithGoogle(
      {BuildContext context, Function showLoader}) async {
    showLoader(state: true);
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    // Initiate the auth procedure.
    final GoogleSignInAccount googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // fetch the auth details from the request made earlier.
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential for signing in with google.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (googleAuth.idToken != null) {
      // Decode the idToken.
      Map<String, dynamic> payload = Jwt.parseJwt(googleAuth.idToken);
      String email = payload['email'];
      String name = payload['name'];

      // Login or Create new user.
      if (email != null) {
        // Check if its a recurring user.
        var result = await getDetailsFromMemory(currentUserEmail: email);
        // If the result is a list with details then login the user.
        // else create a new user.
        if (result.length == 2) {
          // Login user, check permissions.
          loginUser(
            email: result[0],
            password: result[1],
            context: context,
            showLoader: showLoader,
          );
        } else {
          // Generate random password.
          var password = passwordGenerator(16);
          var passwordWithNumber = password + '4';

          createNewUser(
            email: email,
            name: name,
            password: passwordWithNumber,
            context: context,
            showLoader: showLoader,
          );
        }
      }
    }

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  Future<List> getDetailsFromMemory({@required String currentUserEmail}) async {
    var userDetails = [];
    await SharedPreferences.getInstance().then((prefs) async {
      var email = prefs.getString('email');
      var password = prefs.getString('password');
      // Decrypt the email.
      if (email != null && password != null) {
        var decryptedEmail =
            await encryptDecryptData('storedUserEmails', email, 'decrypt');
        var decryptedPassword =
            await encryptDecryptData('storedPasswordss', password, 'decrypt');

        // Compare the stored email with the new one.
        if (decryptedEmail != null && decryptedEmail == currentUserEmail) {
          userDetails.add(decryptedEmail);
          userDetails.add(decryptedPassword);
        }
      }
    });
    return userDetails;
  }

  // Login user.
  loginUser({
    @required String email,
    @required String password,
    @required BuildContext context,
    Function showLoader,
  }) {
    login(emailOrPhone: email, password: password).then((value) {
      // Only proceed to the HomePage when permissions are granted.
      checkPermissions().then((permissionValue) {
        if (value.user.id != null) {
          buildNotification('Logged in successfully', 'success');
          showLoader(state: false);
          // Store the refresh and access userDetails.
          storeLoginDetails(details: value);
          // Choose how to redirect the user based on the role.
          if (value.user.role == 'user') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(
                      userDetails: value.user,
                      accessToken: value.accessToken,
                      refreshToken: value.refreshToken,
                    )));
          } else if (value.user.role == 'vendor') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VendorPage(
                      userDetails: value.user,
                      accessToken: value.accessToken,
                      refreshToken: value.refreshToken,
                    )));
          }
        }
      });
    }).catchError((err) {
      showLoader(state: false);
      log("In authService.dart, loginUser function");
      log(err);
      buildNotification(err.message, 'error');
    });
  }

  // Create user.
  createNewUser({
    @required String email,
    @required String name,
    @required String password,
    @required BuildContext context,
    Function showLoader,
  }) {
    register(
      email: email,
      name: name,
      password: password,
    ).then((value) async {
      // Store the email and password.
      // NOTE: THE ENCRYPTIONKEYS HAVE TO BE 16 CHARACTERS IN LENGTH.
      // DON'T TOUCH THEM.
      var encryptedEmail =
          encryptDecryptData('storedUserEmails', email, 'encrypt');
      var encryptedPassword =
          encryptDecryptData('storedPasswordss', password, 'encrypt');
      storeDetailsInMemory('email', encryptedEmail.base64);
      storeDetailsInMemory('password', encryptedPassword.base64);
      showLoader(state: false);

      // Choose how to redirect the user based on the role.
      if (value.user.role == 'user') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(
                  userDetails: value.user,
                  accessToken: value.accessToken,
                  refreshToken: value.refreshToken,
                )));
      } else if (value.user.role == 'vendor') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VendorPage(
                  userDetails: value.user,
                  accessToken: value.accessToken,
                  refreshToken: value.refreshToken,
                )));
      }
      // Store the other user details.
      storeLoginDetails(details: value);
    }).catchError((err) {
      showLoader(state: false);
      log("In authService.dart, createNewUser function");
      log(err.toString());
      buildNotification(err.message, 'error');
    });
  }

  // log out the user.
  signOut() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleUser =
        await GoogleSignIn(scopes: <String>["email"]);
    // Sign out of firebase.
    await _firebaseAuth.signOut();

    // Sign out of google
    googleUser.signOut();
  }
}
