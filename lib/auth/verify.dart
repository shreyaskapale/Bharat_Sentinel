
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sentinel/auth/home.dart';

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
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
        child: Container(
          width: 320,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Card(child: Container(padding:EdgeInsets.all(20),child: Text("Your are taking a great step towards protecting your privacy 💐")),),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('An email has been sent to ${user.email} please verify.'),
                        Text('Please do not close the app, just open your email and click on the verification we sent to verify and switch back to the app \n\nTeam Sentinel'),
                      ],
                    ),
                  ),
                ),

                Card(child: Container(padding:EdgeInsets.all(20),width:double.infinity,child: Row(
                  children: [
                    Text("Awaiting verification  "),
                    Container(child: CircularProgressIndicator(),height: 20,width: 20,)
                  ],
                )),),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}