// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:gallery/auth_service.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/image_placeholder.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gallery/res/custom_colors.dart';
import 'package:gallery/utils/authentication.dart';
import 'package:gallery/widgets/google_sign_in_button.dart' as google;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../registration_page.dart';
// import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

const padding = 30.0;

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RestorationMixin {
  final RestorableTextEditingController _usernameController =
      RestorableTextEditingController();
  final RestorableTextEditingController _passwordController =
      RestorableTextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  //FirebaseAuth auth = FirebaseAuth.instance;

  @override
  String get restorationId => 'login_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_usernameController, restorationId);
    registerForRestoration(_passwordController, restorationId);
  }

  @override
  Widget build(BuildContext context) {
    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: SafeArea(
          child: _MainView(
            usernameController: _usernameController.value,
            passwordController: _passwordController.value,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class _MainView extends StatelessWidget {
  _MainView({
    Key key,
    this.usernameController,
    this.passwordController,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String successMessage = '';
  void _login(BuildContext context) {
    // Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    List<Widget> listViewChildren;

    if (isDesktop) {
      final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
      listViewChildren = [
        _UsernameInput(
          maxWidth: desktopMaxWidth,
          usernameController: usernameController,
        ),
        const SizedBox(height: 12),
        _PasswordInput(
          maxWidth: desktopMaxWidth,
          passwordController: passwordController,
        ),
        _LoginButton(
            maxWidth: desktopMaxWidth,
            onTap: () {
              //_login(context);
              // if (_formStateKey.currentState.validate()) {
              // _formStateKey.currentState.save();
              signIn(usernameController.text, passwordController.text)
                  .then((user) {
                if (user != null) {
                  print('Logged in successfully.');
                  // setState(() {
                  // successMessage =
                  //   'Logged in successfully.\nYou can now navigate to Home Page.';
                  // });
                  Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
                } else {
                  print('Error while Login.');
                }
              });
            }
            //}
            ),
      ];
    } else {
      listViewChildren = [
        const _SmallLogo(),
        _UsernameInput(
          usernameController: usernameController,
        ),
        const SizedBox(height: 12),
        _PasswordInput(
          passwordController: passwordController,
        ),
        /*  _ThumbButton(
          onTap: () {
            _login(context);
          },
        ), */
        _LoginButton(
          //maxWidth: desktopMaxWidth,
          onTap: () {
            //_login(context);
            //    if (_formStateKey.currentState.validate()) {
            //    _formStateKey.currentState.save();
            signIn(usernameController.text, passwordController.text)
                .then((user) {
              if (user != null) {
                print('Logged in successfully.');
                // setState(() {
                // successMessage =
                //   'Logged in successfully.\nYou can now navigate to Home Page.';
                // });
                Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
              } else {
                print('Error while Login.');
              }
            });
            //}
          },
        ),
      ];
    }

    return Column(
      children: [
        if (isDesktop) const _TopBar(),
        Expanded(
          child: Align(
            alignment: isDesktop ? Alignment.center : Alignment.topCenter,
            child: ListView(
              restorationId: 'login_list_view',
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: listViewChildren,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(width: 30);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: SizedBox(
                  height: 80,
                  child: FadeInImagePlaceholder(
                    image: const AssetImage('assets/logo.png'),
                    placeholder: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxHeight,
                        height: constraints.maxHeight,
                      );
                    }),
                  ),
                ),
              ),
              spacing,
              Text(
                GalleryLocalizations.of(context).rallyLoginLoginToRally,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 35 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                GalleryLocalizations.of(context).rallyLoginNoAccount,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              spacing,
              _BorderButton(
                text: GalleryLocalizations.of(context).rallyLoginSignUp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallLogo extends StatelessWidget {
  const _SmallLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: SizedBox(
        height: 160,
        child: ExcludeSemantics(
          child: FadeInImagePlaceholder(
            image: AssetImage('assets/logo.png'),
            placeholder: SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _ThumbButton extends StatefulWidget {
  _ThumbButton({
    @required this.onTap,
  });

  final VoidCallback onTap;

  @override
  _ThumbButtonState createState() => _ThumbButtonState();
}

class _ThumbButtonState extends State<_ThumbButton> {
  BoxDecoration borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: GalleryLocalizations.of(context).rallyLoginLabelLogin,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Focus(
          onKey: (node, event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) {
                widget.onTap();
                return true;
              }
            }
            return false;
          },
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                borderDecoration = BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                );
              });
            } else {
              setState(() {
                borderDecoration = null;
              });
            }
          },
          child: Container(
            decoration: borderDecoration,
            height: 120,
            child: ExcludeSemantics(
              child: Image.asset(
                'thumb.png',
                package: 'rally_assets',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
    @required this.onTap,
    this.maxWidth,
  }) : super(key: key);

  final double maxWidth;
  final VoidCallback onTap;
  final bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
            padding: const EdgeInsets.symmetric(vertical: 30),
            /* decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ), */
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //const Icon(Icons.check_circle_outline,
                  //  color: RallyColors.buttonColor),
                  //const SizedBox(width: 200),
                  //Text(GalleryLocalizations.of(context).rallyLoginRememberMe),
                  //const Expanded(child: SizedBox.),
                  _FilledButton(
                    text:
                        GalleryLocalizations.of(context).rallyLoginButtonLogin,
                    onTap: onTap,
                  ),
                ]),
                const SizedBox(height: padding),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("or",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20 / reducedTextScale(context),
                          fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: padding),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FutureBuilder(
                            future: Authentication.initializeFirebase(
                                context: context),
                            //future: Firebase.initializeApp(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error initializing Firebase');
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return google.GoogleSignInButton();
                                //signInWithGoogle();
                              }
                              return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.firebaseOrange,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          AppleSignInButton(
                              onPressed: () {
                                _signInWithApple(context);
                              },
                              style: AppleButtonStyle.whiteOutline),
                          /* const SizedBox(height: padding),
                    GoogleSignInButton(
                      onPressed: () async {
                        /* setState(() {
                        _isSigningIn = true;
                      }); */
                        User user = await Authentication.signInWithGoogle(
                            context: context);

                        /* setState(() {
                        _isSigningIn = false;
                      }); */

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
                      borderRadius: 20,
                      splashColor: Colors.white,
                      //text: 'Login with Google',
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Roboto",
                          color: Colors.white),
                      darkMode: true,
                    ), */
                          /* const SizedBox(height: padding),
                    Text("Or",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 20 / reducedTextScale(context),
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: padding),
                    FacebookSignInButton(
                        onPressed: () async {
                          /* setState(() {
                        _isSigningIn = true;
                      }); */
                          User user1 = await Authentication.signInWithFacebook(
                              context: context); */
                          /* setState(() {
                        _isSigningIn = false;
                      }); */
                          /* if (user1 != null) {
                            var firebaseUser =
                                FirebaseAuth.instance.currentUser;
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
                        borderRadius: 20,
                        text: 'Sign in with Facebook',
                        splashColor: Colors.white,
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto",
                            color: Colors.white),
                        centered: true),
                    const SizedBox(height: padding),
                    Text("Or",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 20 / reducedTextScale(context),
                            fontWeight: FontWeight.w600)), */
                          /* const SizedBox(height: padding),
                    TwitterSignInButton(
                        onPressed: () {},
                        borderRadius: 20,
                        // text: 'Login with Facebook',
                        splashColor: Colors.white,
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                        centered: true), */
                          /* const SizedBox(height: padding),
                MicrosoftSignInButton(onPressed: () {}, darkMode: true), */
                        ],
                      ),
                    ],
                  ),
                ])
              ],
            )));
  }
}

/* Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  var googleProvider = GoogleAuthProvider();

  //googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  //googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
} */
class _BorderButton extends StatelessWidget {
  const _BorderButton({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        side: const BorderSide(color: RallyColors.buttonColor),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        //Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => RegistrationPage(),
          ),
        );
      },
      child: Text(text),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: RallyColors.buttonColor,
        primary: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          const Icon(Icons.lock),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    Key key,
    this.maxWidth,
    this.usernameController,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextField(
          textInputAction: TextInputAction.next,
          controller: usernameController,
          decoration: InputDecoration(
            labelText: GalleryLocalizations.of(context).rallyLoginUsername,
          ),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key key,
    this.maxWidth,
    this.passwordController,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: GalleryLocalizations.of(context).rallyLoginPassword,
          ),
          obscureText: true,
        ),
      ),
    );
  }
}

Future<User> signIn(String email, String password) async {
  try {
    final auth = FirebaseAuth.instance;
    UserCredential usercred = (await auth.signInWithEmailAndPassword(
        email: email, password: password));

    assert(usercred.user != null);
    assert(await usercred.user.getIdToken() != null);

    // ignore: await_only_futures
    //final User currentUser = await auth.currentUser();
    // assert(user.uid == currentUser.uid);
    return usercred.user;
  } catch (error) {
    print(error);
    switch (error.toString()) {
      case 'ERROR_USER_NOT_FOUND':
        //setState(() {
        print('User Not Found!!!');
        // });
        break;
      case 'ERROR_WRONG_PASSWORD':
        //setState(() {
        print('Wrong Password!!!');
        //});
        break;
    }
    return null;
  }
}

Future<void> _signInWithApple(BuildContext context) async {
  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.signInWithApple();
    print('uid: ${user.uid}');
  } catch (e) {
    // TODO: Show alert here
    print(e);
  }
}
