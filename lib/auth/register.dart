import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentinel/auth/home.dart';
import 'package:sentinel/auth/reset.dart';
import 'package:sentinel/auth/verify.dart';


class RegisterScreen extends StatefulWidget {
  static const route = "register";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          SizedBox(height: 100,),

          Container(
              height: 160,
              width: 300,
              child: Image.asset("assets/images/KeySecure.png")
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
                auth
                    .signInWithEmailAndPassword(
                    email: _email, password: _password)
                    .then((_) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
