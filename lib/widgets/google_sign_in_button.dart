import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:gallery/screens/user_info_screen.dart';
import 'package:gallery/utils/authentication.dart';
//import 'package:gallery/studies/rally/home.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gallery/utils/database.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart' as auth_buttons;

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : auth_buttons.GoogleSignInButton(
              /* style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                //backgroundColor: RallyColors.buttonColor,
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ), */
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User user =
                    await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  var firebaseUser = FirebaseAuth.instance.currentUser;
                  Database.userUid = firebaseUser.uid;
                  const url =
                      'https://ant.aliceblueonline.com/oauth2/auth?response_type=code&state=test_state&client_id=DkF5uRWtRB';
                  if (await canLaunch(url)) {
                    await launch(url, forceWebView: true);
                    Navigator.of(context)
                        .restorablePushNamed(RallyApp.homeRoute);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              /* child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: const AssetImage('assets/google_logo.png'),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ), */
            ),
    );
  }
}
