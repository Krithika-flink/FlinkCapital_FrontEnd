import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:login_app/src/screens/home.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:gallery/userModel.dart';
import 'package:gallery/utils/database.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    print('user $user');
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      //var returnstring =
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'An email has been sent to ${user.email} please verify',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 12,
                color: Colors.black,
              ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    String retval = 'failure';
    if (user.emailVerified == true) {
      timer.cancel();
      //Navigator.of(context).pushReplacement(
      //  MaterialPageRoute(builder: (context) => HomeScreen()));

      // ignore: await_only_futures
      await user.reload;
      user = auth.currentUser;
      var flag = user.emailVerified;

      print('flag $flag');
      var _user = UserModel(
        uid: user.uid,
        email: user.email,
        fullName: user.displayName.toString(),
        accountCreated: Timestamp.now(),
        //notifToken: await _fcm.getToken(),
      );
      var _returnString = await Database.createUser(_user);
      if (_returnString == 'success') {
        retval = 'success';
      }
      Navigator.of(context).restorablePushNamed(RallyApp.loginRoute);
    }
    print('retvalue $retval');
    //return (retval);
  }
}
