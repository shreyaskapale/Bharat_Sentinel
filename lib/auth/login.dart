import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sentinel/auth/home.dart';
import 'package:sentinel/auth/reset.dart';
import 'package:sentinel/auth/verify.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
class LoginScreen extends StatefulWidget {
  static const route = "login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,

      backgroundColor: Theme.of(context).primaryColor,

      body: Column(
        children: [
          SizedBox(height: 100,),

          Container(
            height: 160,
            width: 300,
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hey there",style:TextStyle(
                  fontSize: 30
                ),),
                SizedBox(height: 10,),
                Text("let's setup your account",style:TextStyle(
                    fontSize: 15
                ),),
              ],
            ))
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
            child: TextField(

              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Email",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
            child: TextField(
              obscureText: true,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    hintText: "Password",
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
          ),
          RaisedButton(


            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.lightGreenAccent)
            ),
            color: Colors.lightGreenAccent,
            child: Padding(
              padding: EdgeInsets.fromLTRB(98, 10, 98, 10),
              child: Text('Signup',style: TextStyle(color: Colors.black),),
            ),
            onPressed: () async {
              var  snackText=".";


              // Find the Scaffold in the widget tree and use
              // it to show a SnackBar.

              final emailRegex = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
              final passRegex = new RegExp(r"^(?=.*?[a-z])(?=.*?[0-9])");
              print(_email);
              print(emailRegex.hasMatch(_email.toString()));
              if(emailRegex.hasMatch(_email))

                {

                  if(passRegex.hasMatch(_password)) {
                    try {

                     await auth
                          .createUserWithEmailAndPassword(
                          email: _email, password: _password)
                          .then((_) {

                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => VerifyScreen()));
                      });


                    } on FirebaseAuthException catch  (e) {
                      print(e);
                      snackText=e.message;

                    }
                  } else {

                    snackText = "password should have minimum 6 characters, at least one letter and one number";


                  }

                } else {
                snackText = "Incorrect or empty email address field";

              }


            new Future.delayed(const Duration(seconds: 1), () {
              final snackBar = SnackBar(
                content: Text(snackText),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {

                    // Some code to undo the change.
                  },
                ),
              );

              _scaffoldKey.currentState.showSnackBar(snackBar);


            });



            },
          ),
          OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)
              ),
              color: Theme.of(context).accentColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(98, 10, 98, 10),
                child: Text('Signin'),
              ),
              onPressed: () {
                var snackText;

             try {
               auth
                   .signInWithEmailAndPassword(
                   email: _email, password: _password)
                   .then((_) {
                 Navigator.of(context).pushReplacement(
                     MaterialPageRoute(builder: (context) => HomeScreen()));
               });
             }   on FirebaseAuthException catch  (e) {
               print(e);
               snackText=e.message;

             }


                new Future.delayed(const Duration(seconds: 1), () {
                  final snackBar = SnackBar(
                    content: Text(snackText),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {

                        // Some code to undo the change.
                      },
                    ),
                  );

                  _scaffoldKey.currentState.showSnackBar(snackBar);


                });

              }),

          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [


          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('Forgot Password?'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResetScreen()),
                ),
              )
            ],
          )
        ],

      ),
    );
  }
}