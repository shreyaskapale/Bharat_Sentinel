import 'package:sentinel/core/platformCaller.dart';
import 'package:sentinel/main.dart';
import 'package:sentinel/screens/main/BannedScanner.dart';
import 'package:sentinel/screens/main/FireWall.dart';
import 'package:sentinel/screens/main/VirusScanner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sentinel/GLOBALS.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:wakelock/wakelock.dart';
import 'package:sentinel/screens/intro/getFireWallPermission.dart';

class AppConsole extends StatefulWidget {
  static const route = "AppConsole";



  @override
  _AppConsoleState createState() => _AppConsoleState();
}

class _AppConsoleState extends State<AppConsole>  with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double _platformVersion = 0;



  @override
  void initState() {

    initFirewall();
    initFirewall();

    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    Wakelock.enable();
  }

  static String sentiButton="S E N T I N E L";
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
        appBar: AppBar(
          title:Center(child:Text("Bharat Sentinel")),



          backgroundColor: Color(0xFF505050),
        ),
        body: Stack(
          children: [
            Column(


              children: [


                Card(
                  child: Container(


                    padding:EdgeInsets.all(2),
                    width:double.infinity,
                    child: Column(

                      children: [

                        AvatarGlow(

                          glowColor: Colors.white,
                          endRadius: 100.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: GestureDetector(
                              onTap: (){
                                sentiButton = "S E N T I N E L";
                                Navigator.pushNamed(context, VirusScanner.route);
                              },
                              child: CircleAvatar(

                                backgroundColor: Colors.grey[100],
                                child: Text(sentiButton,style: TextStyle(color:Colors.black),),
                                radius: 80.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Card(

                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(5),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, SentinelWall.route);
                          },
                          child: Card(
                            elevation: 2,
                            child: ClipPath(
                              child: Container(

                                child:  Column(

                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(FontAwesomeIcons.fire,size: 50,color: Colors.grey[100]),
                                    Text("Firewall"),



                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.lightGreen, width: 3))),
                              ),
                              clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                            ),

                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, VirusScanner.route);
                          },
                          child: Card(
                            elevation: 2,
                            child: ClipPath(
                              child: Container(
                                child:  Column(

                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(FontAwesomeIcons.bug,size: 50,color: Colors.grey[100]),
                                    Text("Virus scanner"),

                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.lightGreen, width: 3))),
                              ),
                              clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                            ),

                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, BannedAppScanner.route);
                          },
                          child: Card(
                            elevation: 2,
                            child: ClipPath(
                              child: Container(
                                child:  Column(

                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(FontAwesomeIcons.ban,size: 50,color:Colors.grey[100]),
                                    Text("Banned App Scanner"),

                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.lightGreen, width: 3))),
                              ),
                              clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                            ),

                          ),
                        ),
                        Card(
                          elevation: 2,
                          child: ClipPath(
                            child: GestureDetector(
                              onTap: (){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GetFireWallPermission()));

                              },
                              child: Container(
                                child:  Column(

                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(FontAwesomeIcons.trashAlt,size: 50,color:Color(0xFF505050)),
                                    Text("Coming Soon"),

                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.blueGrey, width: 3))),
                              ),
                            ),
                            clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3))),
                          ),

                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}

