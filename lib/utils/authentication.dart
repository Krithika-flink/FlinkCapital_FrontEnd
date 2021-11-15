import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gallery/studies/rally/app.dart';

class Authentication {
  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    BuildContext context,
  }) async {
    var firebaseApp = await Firebase.initializeApp();

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
    }

    return firebaseApp;
  }

  static Future<UserCredential> signInWithGoogle({BuildContext context}) async {
    var auth = FirebaseAuth.instance;
    UserCredential userCredential;

    if (kIsWeb) {
      var authProvider = GoogleAuthProvider();

      try {
        userCredential = await auth.signInWithPopup(authProvider);
        //return userCredential;
        //user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final googleSignIn = GoogleSignIn();

      // ignore: omit_local_variable_types
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          userCredential = await auth.signInWithCredential(credential);

          // user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }
    return userCredential;
  }

  static Future<void> signOut({BuildContext context}) async {
    final googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<UserCredential> signInWithFacebook(
      {BuildContext context}) async {
    var auth = FirebaseAuth.instance;
    UserCredential userCredential;

    if (kIsWeb) {
      var facebookProvider = FacebookAuthProvider();

      try {
        userCredential = await auth.signInWithPopup(facebookProvider);

        // user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      //final GoogleSignIn googleSignIn = GoogleSignIn();
      final result = await FacebookAuth.instance.login();

      // ignore: omit_local_variable_types
      /* final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn(); */

      if (result != null) {
        /* final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        ); */
        final facebookAuthCredential =
            FacebookAuthProvider.credential(result.token);

        try {
          userCredential =
              await auth.signInWithCredential(facebookAuthCredential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using FaceBook Sign In. Try again.',
            ),
          );
        }
      }
    }

    return userCredential;
  }
}
