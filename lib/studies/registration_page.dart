import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/image_placeholder.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/studies/rally/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/studies/rally/colors.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = '';
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');
  //final double maxWidth;
  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      final double desktopMaxWidth =
          400.0 + 100.0 * (cappedTextScale(context) - 1);
    }
    //final double maxWidth= desktopMaxWidth != null?0;
    final spacing = const SizedBox(height: 40);
    return Scaffold(
        /* appBar: AppBar(
          title: Text('SignUp - Flink\'s Bigg Bott'),
        ), */
        body: Column(children: [
      spacing,
      if (isDesktop) const _TopBar(),
      spacing,
      Align(
        alignment: Alignment.center,
        child: Container(
          //width: desktopMaxWidth,
          constraints: BoxConstraints(
              //maxWidth: desktopMaxWidth ?? double.infinity),
              maxWidth: 400.0 + 100.0 * (cappedTextScale(context) - 1)),
          //height: 500,
          color: RallyColors.cardBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                //margin: EdgeInsetsGeometry.lerp(375, , 100),
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formStateKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validateEmail,
                                onSaved: (value) {
                                  _emailId = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailIdController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: RallyColors.buttonColor,
                                        width: 2,
                                        style: BorderStyle.solid),
                                  ),
                                  // hintText: "Company Name",
                                  labelText: GalleryLocalizations.of(context)
                                      .demoTextFieldEmail,
                                  icon: Icon(
                                    Icons.email,
                                    color: RallyColors.buttonColor,
                                  ),
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validatePassword,
                                onSaved: (value) {
                                  _password = value;
                                },
                                controller: _passwordController,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: RallyColors.buttonColor,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  // hintText: "Company Name",
                                  labelText: GalleryLocalizations.of(context)
                                      .rallyLoginPassword,
                                  icon: Icon(
                                    Icons.lock,
                                    color: RallyColors.buttonColor,
                                  ),
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validateConfirmPassword,
                                controller: _confirmPasswordController,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: RallyColors.buttonColor,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  // hintText: "Company Name",
                                  labelText: "Confirm Password",
                                  icon: Icon(
                                    Icons.lock,
                                    color: RallyColors.buttonColor,
                                  ),
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (errorMessage != ''
                          ? Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container()),
                      // make buttons use the appropriate styles for cards
                      ButtonBar(
                        children: <Widget>[
                          /* FlatButton(
                          child: text:GalleryLocalizations.of(context).rallyLoginSignUp,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ), */
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.black,
                              side: const BorderSide(
                                  color: RallyColors.buttonColor),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (_formStateKey.currentState.validate()) {
                                _formStateKey.currentState.save();
                                signUp(_emailId, _password).then((user) {
                                  if (user != null) {
                                    print('Registered Successfully.');
                                    showAlertDialog(context);
                                    setState(() {
                                      successMessage =
                                          'Registered Successfully.\nYou can now navigate to Login Page.';
                                    });
                                  } else {
                                    print('Error while Login.');
                                  }
                                });
                              }
                            },
                            child: Text(
                                GalleryLocalizations.of(context)
                                    .rallyLoginSignUp,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          // ignore: deprecated_memer_use
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              side: const BorderSide(
                                  color: RallyColors.buttonColor),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                                GalleryLocalizations.of(context)
                                    .rallyLoginButtonLogin,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              (successMessage != ''
                  ? Text(
                      successMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24, color: RallyColors.buttonColor),
                    )
                  : Container()),
            ],
          ),
        ),
      )
    ]));
  }

  Future<User> signUp(email, password) async {
    try {
      // ignore: omit_local_variable_types
      UserCredential usercred = (await auth.createUserWithEmailAndPassword(
          email: email.toString(), password: password.toString()));

      assert(usercred.user != null);
      assert(await usercred.user.getIdToken() != null);
      return usercred.user;
    } catch (error) {
      print(error);
      switch (error.code.toString()) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          setState(() {
            errorMessage = 'Email Id already Exist!!!';
          });
          break;
        default:
      }
      return null;
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        setState(() {
          errorMessage = 'Email Id already Exist!!!';
        });
        break;
      default:
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // ignore: omit_local_variable_types
    // ignore: unnecessary_new
    // ignore: omit_local_variable_types
    RegExp regex = RegExp(pattern.toString());
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.trim() != _passwordController.text.trim()) {
      return 'Password Mismatch!!!';
    }
    return null;
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
                'SignUp at Flink\'s Bigg Bott',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 35 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("Continue"),
    onPressed: () {
      Navigator.of(context).restorablePushNamed(RallyApp.loginRoute);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text(
        "Registered succesfully to Flink's Bot.Click on Continue to Login Page.",
        style: TextStyle(color: Colors.black)),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
