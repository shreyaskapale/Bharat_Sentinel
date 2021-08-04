import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sentinel/GLOBALS.dart';
import 'package:sentinel/screens/intro/introduction.dart';
import 'package:sentinel/screens/main/home.dart';
import 'package:sentinel/core/platformCaller.dart';
import 'package:wakelock/wakelock.dart';

class Welcome extends StatefulWidget {
  static const route = "welcome";




  @override
  _WelcomeState createState() => _WelcomeState();

}

class _WelcomeState extends State<Welcome> {
  bool showCompany = false;
  bool showTitle = false;


  @protected
  @mustCallSuper
  // ignore: must_call_super
  void initState() {
    initFirewall();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showCompany = true;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {

        setState(() {
          showTitle = true;
          showCompany = false;
        });

        Future.delayed(const Duration(milliseconds: 2300), () {
          if(setupComplete=="yes"){
            firewallPermission();
            Navigator.pushReplacementNamed(context, AppConsole.route);

          }else Navigator.pushReplacementNamed(context, Introduction.route);
        });

      });

    }

    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,


        home: Container(
        color: Color(0XFFFAFAFA),
          height: double.infinity,
          width: double.infinity,
          child: Container(
          decoration:new BoxDecoration(
          image:  new DecorationImage(
          image: new AssetImage("assets/images/wc_bg.gif"),
    )
    ),
      child: Scaffold(
backgroundColor: Colors.transparent,

          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                ),

            AnimatedOpacity(
            opacity:  showCompany ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),

                child:Text('X E R F I A',style: TextStyle(fontSize: 20),),),
                AnimatedOpacity(
                  opacity:  showTitle ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1000),

                  child:Column(
                    children: [
                      Text('S E N T I N E L',style: TextStyle(fontSize: 30),

                      ),
                      Text('Android Security'),



                    ],
                  ),),



              ]

            ),
          ),
      ),
    ),
        ));
  }
}