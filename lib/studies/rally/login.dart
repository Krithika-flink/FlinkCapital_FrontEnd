// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:gallery/api_response.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/image_placeholder.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:getwidget/getwidget.dart';
// ignore: implementation_imports
//import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery/auth_service.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/layout/image_placeholder.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:gallery/studies/rally/colors.dart';
import 'package:gallery/res/custom_colors.dart';
import 'package:gallery/studies/verifyemail.dart';
import 'package:gallery/userModel.dart';
import 'package:gallery/utils/authentication.dart';
import 'package:gallery/utils/database.dart';
import 'package:gallery/utils/google_sign_in_button.dart' as google;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/twitter_login.dart';
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

class _MainView extends StatefulWidget {
  _MainView({
    Key key,
    this.usernameController,
    this.passwordController,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  @override
  _MainViewState createState() => _MainViewState();
}

// ignore: must_be_immutable
class _MainViewState extends State<_MainView> {
//class _MainView extends StatelessWidget {
  // _MainView({
  // Key key,
  //this.usernameController,
  //this.passwordController,
  //}) : super(key: key);

  //final TextEditingController usernameController;
  //final TextEditingController passwordController;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String successMessage = '';
  // ignore: avoid_void_async
  void _login(BuildContext context) async {
    // Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
    //if (_formStateKey.currentState.validate()) {
    //_formStateKey.currentState.save();
    await signIn(widget.usernameController.text, widget.passwordController.text)
        .then((user) async {
      if (user != null) {
        if (user.emailVerified == true) {
          print('Logged in successfully.');
          setState(() {
            successMessage =
                'Logged in successfully.\nYou can now navigate to Home Page.';
          });
          Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
        } else {
          setState(() {
            successMessage = 'Email Id is not yet verified!!';
          });
          try {
            await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => VerifyScreen()));
          } catch (e) {
            print(e);
          }
        }
      } else {
        print('Error while Login.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    List<Widget> listViewChildren;
    final email = widget.usernameController.text;
    print('Email id:$email');
    if (isDesktop) {
      final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
      listViewChildren = [
        _UsernameInput(
          maxWidth: desktopMaxWidth,
          usernameController: widget.usernameController,
        ),
        const SizedBox(height: 12),
        _PasswordInput(
          maxWidth: desktopMaxWidth,
          passwordController: widget.passwordController,
        ),
        const SizedBox(height: 6),
        successMessage != ''
            ? Text(successMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center)
            : Container(),
        _LoginButton(
          maxWidth: desktopMaxWidth,
          onTap: () {
            _login(context);
          },
          onForgotPassword: () {
            resetPassword(context);
          },
        ),
      ];
    } else {
      listViewChildren = [
        const _SmallLogo(),
        _UsernameInput(
          usernameController: widget.usernameController,
        ),
        const SizedBox(height: 12),
        _PasswordInput(
          passwordController: widget.passwordController,
        ),
        const SizedBox(height: 6),
        /*  _ThumbButton(
          onTap: () {
            _login(context);
          },
        ), */
        (successMessage != ''
            ? Text(
                successMessage,
                style: const TextStyle(color: Colors.red),
              )
            : Container()),
        _LoginButton(
            //maxWidth: desktopMaxWidth,
            onTap: () {
          _login(context);
        }, onForgotPassword: () {
          resetPassword(context);
        }),
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

  Future<User> signIn(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      var usercred = (await auth.signInWithEmailAndPassword(
          email: email, password: password));

      assert(usercred.user != null);
      assert(await usercred.user.getIdToken() != null);

      // ignore: await_only_futures
      //final User currentUser = await auth.currentUser();
      // assert(user.uid == currentUser.uid);
      if (usercred.user.emailVerified == true) {
        return usercred.user;
      }
      return null;
    } catch (error) {
      print(error.code.toString());
      switch (error.code.toString()) {
        case 'user-not-found':
          setState(() {
            successMessage = 'User Not Found!!!';
          });
          break;
        case 'wrong-password':
          setState(() {
            successMessage = 'Wrong Password!!!';
          });
          break;
        case 'invalid-email':
          setState(() {
            successMessage = 'Invalid Email Id!!!';
          });
          break;
        case 'user-disabled':
          setState(() {
            successMessage = 'This User Id is disabled';
          });
          break;
      }
      return null;
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: widget.usernameController.text);
      setState(() {
        successMessage = 'Please check your email to reset your password!!';
      });
    } catch (e) {
      print(e);
      switch (e.code.toString()) {
        case 'user-not-found':
          setState(() {
            successMessage = 'User Not Found or May have been deleted!!!';
          });
          break;
      }
    }
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
                      fontSize: 30 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C7095),
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                GalleryLocalizations.of(context).rallyLoginNoAccount,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.black54),
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
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 20),
                _BorderButton(
                  text: GalleryLocalizations.of(context).rallyLoginSignUp,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 100,
                  child: ExcludeSemantics(
                    child: FadeInImagePlaceholder(
                      image: AssetImage('assets/logo.png'),
                      placeholder: SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Text(
                  GalleryLocalizations.of(context).rallyLoginLoginToRally,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 30 / reducedTextScale(context),
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
          ],
        )
        // ),
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
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
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

class _LoginButton extends StatefulWidget {
  _LoginButton({
    Key key,
    @required this.onTap,
    @required this.onForgotPassword,
    this.maxWidth,
    this.email,
  }) : super(key: key);

  final double maxWidth;
  final VoidCallback onTap;
  final VoidCallback onForgotPassword;
  final String email;

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

/* class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
    @required this.onTap,
    this.maxWidth,
  }) : super(key: key);

  final double maxWidth;
  final VoidCallback onTap; */
class _LoginButtonState extends State<_LoginButton> {
  bool _isSigningIn = false;
  String result = 'error';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.center,
        child: Container(
            constraints:
                BoxConstraints(maxWidth: widget.maxWidth ?? double.infinity),
            padding: const EdgeInsets.symmetric(vertical: 30),
            /*  decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ), */
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    TextButton(
                      onPressed: widget.onForgotPassword,
                      child: Text(
                        'Forgot Your Password?',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    const Expanded(child: SizedBox(width: 200)),
                    _FilledButton(
                      text: GalleryLocalizations.of(context)
                          .rallyLoginButtonLogin,
                      onTap: widget.onTap,
                    ),
                  ]),
                  const SizedBox(height: padding),
                  /* OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      'CONNECT WITH',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: RallyColors.cardBackground),
                    ),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      side: const BorderSide(color: RallyColors.buttonColor),
                      //padding: const EdgeInsets.symmetric(
                      //  vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ), */
                  SizedBox(
                    width: size.width * 0.8,
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Divider(color: RallyColors.cardBackground)),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('OR CONNECT WITH',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: RallyColors.buttonColor))),
                      Expanded(
                          child: Divider(color: RallyColors.cardBackground)),
                    ]),
                  ),
                  const SizedBox(height: padding),
                  // Row(children: <Widget>[
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    //future: Firebase.initializeApp(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        //return google.GoogleSignInButton();
                        //signInWithGoogle();
                        return Container(
                            child: Row(children: [
                          SignInButtonBuilder(
                              elevation: 2.0,
                              key: ValueKey('Google'),
                              text: 'Google',
                              textColor: Color.fromRGBO(0, 0, 0, 0.54),
                              image: Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/logos/google_light.png',
                                      package: 'flutter_signin_button',
                                    ),
                                    height: 36.0,
                                  ),
                                ),
                              ),
                              backgroundColor: Color(0xFFFFFFFF),
                              padding: EdgeInsets.all(0),
                              innerPadding: EdgeInsets.all(0),
                              height: 36.0,
                              width: 100,
                              onPressed: () async {
                                // setState(() {
                                // _isSigningIn = true;
                                //});

                                var userCredential =
                                    await Authentication.signInWithGoogle(
                                        context: context);
                                /* setState(() {
                  _isSigningIn = false;
                }); */
                                assert(userCredential.user != null);
                                await SignintoFlinkCapital(
                                    context, userCredential);
                              }),
                          //const SizedBox(width: 30),
                          const Expanded(child: SizedBox(width: 200)),
                          SignInButtonBuilder(
                            elevation: 2.0,
                            key: ValueKey('Facebook'),
                            mini: false,
                            text: 'Facebook',
                            icon: FontAwesomeIcons.facebookF,
                            width: 113,
                            image: const ClipRRect(
                              child: Image(
                                image: AssetImage(
                                  'assets/logos/facebook_new.png',
                                  package: 'flutter_signin_button',
                                ),
                                height: 24.0,
                              ),
                            ),
                            backgroundColor: Color(0xFF1877f2),
                            padding: const EdgeInsets.all(0),
                            innerPadding: EdgeInsets.fromLTRB(12, 0, 11, 0),
                            onPressed: () async {
                              /* setState(() {
                        _isSigningIn = true;
                      }); */
                              var usercredential =
                                  await Authentication.signInWithFacebook(
                                      context: context);
                              /* setState(() {
                        _isSigningIn = false;
                      }); */
                              if (usercredential.user != null) {
                                await SignintoFlinkCapital(
                                    context, usercredential);
                              }
                            },
                          ),

                          const Expanded(child: SizedBox(width: 200)),
                          SignInButtonBuilder(
                            elevation: 2.0,
                            key: ValueKey('Twitter'),
                            mini: false,
                            text: 'Twitter',
                            icon: FontAwesomeIcons.twitter,
                            backgroundColor: Color(0xFF1DA1F2),
                            onPressed: () async {
                              try {
                                var usercredential = await signInWithTwitter();
                              } on Exception catch (e) {
                                if (e is FirebaseAuthException) {
                                  print(e);
                                }
                              }
                            },
                            padding: const EdgeInsets.all(0),
                            width: 100,
                          ),
                          //],
                          //),
                        ]));
                      } else {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.firebaseOrange,
                          ),
                        );
                      }
                    },
                  ),
                  /* SignInButtonBuilder(
                          elevation: 2.0,
                          key: ValueKey("Google"),
                          text: 'Google',
                          textColor: Color.fromRGBO(0, 0, 0, 0.54),
                          image: Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Image(
                                image: AssetImage(
                                  'assets/logos/google_light.png',
                                  package: 'flutter_signin_button',
                                ),
                                height: 36.0,
                              ),
                            ),
                          ),
                          backgroundColor: Color(0xFFFFFFFF),
                          padding: EdgeInsets.all(0),
                          innerPadding: EdgeInsets.all(0),
                          height: 36.0,
                          width: 100,
                          onPressed: () async {
                            // setState(() {
                            // _isSigningIn = true;
                            //});

                            var userCredential =
                                await Authentication.signInWithGoogle(
                                    context: context);
                            /* setState(() {
                  _isSigningIn = false;
                }); */
                            assert(userCredential.user != null);
                            await SignintoFlinkCapital(context, userCredential);
                          }),
                      //const SizedBox(width: 30),
                      const Expanded(child: SizedBox(width: 200)),
                      SignInButtonBuilder(
                        elevation: 2.0,
                        key: ValueKey("Facebook"),
                        mini: false,
                        text: 'Facebook',
                        icon: FontAwesomeIcons.facebookF,
                        width: 120,
                        backgroundColor: Color(0xFF3B5998),
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          /* setState(() {
                        _isSigningIn = true;
                      }); */
                          var usercredential =
                              await Authentication.signInWithFacebook(
                                  context: context);
                          /* setState(() {
                        _isSigningIn = false;
                      }); */
                          if (usercredential.user != null) {
                            await SignintoFlinkCapital(context, usercredential);
                          }
                        },
                      ),
                      const Expanded(child: SizedBox(width: 200)),
                      SignInButtonBuilder(
                        elevation: 2.0,
                        key: ValueKey("Twitter"),
                        mini: false,
                        text: 'Twitter',
                        icon: FontAwesomeIcons.twitter,
                        backgroundColor: Color(0xFF1DA1F2),
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        width: 100,
                      ),
                      //],
                      //),
                    ],
                  ), */
                  // ]),
                ])));
  }
}

class _BorderButton extends StatelessWidget {
  const _BorderButton({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.black,
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
          MaterialPageRoute(
            builder: (context) => RegistrationPage(),
          ),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.person_add_alt, size: 15),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: Colors.black54))
        ],
      ),
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
          const Icon(Icons.login),
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Theme(
          data: ThemeData(
              primaryColor: RallyColors.cardBackground,
              primaryColorDark: RallyColors.cardBackground),
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: RallyColors.cardBackground)),
              labelText: GalleryLocalizations.of(context).demoTextFieldEmail,
              labelStyle: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w600),
              prefixIcon:
                  const Icon(Icons.email, color: RallyColors.buttonColor),
              //fillColor: Colors.blueGrey.shade100,
              //focusColor: RallyColors.cardBackground,
              //border: const InputBorder(borderSide:  BorderSide.merge(color: RallyColors.buttonColor)),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _PasswordInput extends StatefulWidget {
  _PasswordInput({
    Key key,
    this.maxWidth,
    this.passwordController,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController passwordController;
  @override
  __PasswordInputState createState() => __PasswordInputState();
}

// Toggles the password show status
/*void initState() {
    _passwordVisible = false;
  } */
/* void _toggle() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  } */
class __PasswordInputState extends State<_PasswordInput> {
  bool _passwordVisible = true;
  /*  @override
  void initState() {
    _passwordVisible = false;
  } */

  void _togglePasswordView() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: widget.maxWidth ?? double.infinity),
        child: Theme(
          data: ThemeData(primaryColor: RallyColors.cardBackground),
          child: TextFormField(
            obscureText: _passwordVisible,
            controller: widget.passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: RallyColors.cardBackground)),
              labelText: GalleryLocalizations.of(context).rallyLoginPassword,
              labelStyle: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w600),
              prefixIcon:
                  const Icon(Icons.lock, color: RallyColors.buttonColor),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: RallyColors.buttonColor,
                ),
                onPressed: _togglePasswordView,
              ),
              /* suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  child: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ), */
              /* suffix: InkWell(
                  onTap: _togglePasswordView,
                  child: Icon(Icons.visibility),
                ), */
            ),
            keyboardType: TextInputType.visiblePassword,
            //fillColor: Colors.blueGrey.shade100,
          ),
          //obscureText: true,
        ),
      ),
    );
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

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters long';
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}

Future<void> SignintoFlinkCapital(
    BuildContext context, UserCredential usercred) async {
  try {
    final user = usercred.user;
    if (user != null) {
      if (usercred.additionalUserInfo.isNewUser) {
        var _user = UserModel(
          uid: usercred.user.uid,
          email: usercred.user.email,
          fullName: usercred.user.displayName,
          accountCreated: Timestamp.now(),
          //notifToken: await _fcm.getToken(),
        );
        var _returnString = await Database.createUser(_user);
        if (_returnString == 'success') {
          var retVal = 'success';
        }
      } else {
        const url =
            'https://ant.aliceblueonline.com/oauth2/auth?response_type=code&state=test_state&client_id=DkF5uRWtRB';
        if (await canLaunch(url)) {
          await launch(url, forceWebView: true);
          Navigator.of(context).restorablePushNamed(RallyApp.homeRoute);
        } else {
          throw 'Could not launch $url';
        }
      }
    }
  } catch (e) {
    // TODO: Show alert here
    print(e);
  }
}

Future<UserCredential> signInWithTwitter() async {
  final _auth = FirebaseAuth.instance;
  final twitterLogin = TwitterLogin(
    apiKey: '0kil3qCRXKDTQ9eSfWMfPBq8I',
    apiSecretKey: 'mGnacPIHZW634C7A0AzwSCS36kdiY2VtkwtpECfjtniP5RaRDj',
    redirectURI: 'flinkcapital://',
  );
  final authResult = await twitterLogin.login();
  String result = authResult.errorMessage;
  print('auth result ${result}');
  switch (authResult.status) {
    case TwitterLoginStatus.loggedIn:
      final AuthCredential twitterAuthCredential =
          TwitterAuthProvider.credential(
              accessToken: authResult.authToken,
              secret: authResult.authTokenSecret);

      final userCredential =
          await _auth.signInWithCredential(twitterAuthCredential);
      return userCredential;
    case TwitterLoginStatus.cancelledByUser:
      print('success');
      break;
    case TwitterLoginStatus.error:
      print('login status error');
      break;
    default:
      break;
  }
}
