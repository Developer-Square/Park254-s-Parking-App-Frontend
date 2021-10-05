import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:park254_s_parking_app/pages/onboarding_page.dart';
import '../../pages/login_screen.dart';
import '../../pages/home_page.dart';

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

  signInWithFacebook() async {
    final fb = FacebookLogin();

    // Log in.
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:

        // The user is successfully logged in.
        // Send aaccess token to server for validation and auth.
        final FacebookAccessToken accessToken = res.accessToken;
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(accessToken.token);
        final result =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        // Get profile data from facebook for use in the app.
        final profile = await fb.getUserProfile();
        log('Hello, ${profile.name}! Your ID: ${profile.userId}');

        // fetch user email.
        final email = await fb.getUserEmail();

        // But user can decline permission.
        if (email != null) log('And your email is $email');

        break;

      case FacebookLoginStatus.cancel:
        // In case the user cancels the login success.
        break;
      case FacebookLoginStatus.error:
        // Login procedure failed.
        log('Error while facebook log in: ${res.error}');
        break;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
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
  }

  // log out the user.
  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
