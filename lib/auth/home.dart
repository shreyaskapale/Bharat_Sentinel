import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sentinel/auth/login.dart';
import 'package:sentinel/screens/intro/getFilePermission.dart';
import 'package:sentinel/screens/intro/getFireWallPermission.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    new Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GetFilePermission()));

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Row(children: [
        Text("Loading"),
        CircularProgressIndicator()
      ],),),
    );
  }
}