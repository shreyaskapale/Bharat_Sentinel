import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentinel/config/automaticConfig.dart';
import 'package:sentinel/main.dart';
import 'package:sentinel/screens/intro/getFireWallPermission.dart';
import 'package:sentinel/screens/main/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/GLOBALS.dart';
class Configure extends StatefulWidget {
  static const route = "Configure";
  static const platform = const MethodChannel('com.xerfia.sentinel/sentinel');
  void global_iface(String iface,bool rule) async{
    List<dynamic> pkglist = <dynamic>[];
    setLocalStorage(iface,iface=="wifi"?wifiRuleMap:otherRuleMap);

    try{
      pkglist = await platform.invokeMethod('whitelist',{"status":rule.toString(),"iface":iface});
    }catch(e){
      print(e);
    }

  }



  @override
  _ConfigureState createState() => _ConfigureState();

}

class _ConfigureState extends State<Configure> {
  bool showCompany = false;
  bool showTitle = false;


  @protected
  @mustCallSuper
  // ignore: must_call_super
  void initState() {
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
          //Navigator.pushReplacementNamed(context, fbRegister.route);
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

          child: Scaffold(
            backgroundColor:Color(0XFFFAFAFA),

            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    AnimatedOpacity(
                      opacity: showCompany ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),

                      child: Text(
                        'Configuring Services', style: TextStyle(fontSize: 20),),),
                    AnimatedOpacity(
                      opacity: showTitle ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),

                      child: Column(
                        children: [
                          Text("Choose a setup option"),
                         SizedBox(height: 10,),
                         Card(
                           child: Container(
                             width: 300,
                             height: 200,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [


                                 Text("Auto Setup Coming Soon",textAlign: TextAlign.center),
                                 RaisedButton(
                                   child:Text("Automatic"),

                                 ),
                               ],
                             ),
                           ),
                         ),
                          Card(
                            child: Container(
                              width: 300,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Manual Setup is not automatic, you have to on everything your self",textAlign: TextAlign.center,),
                                  RaisedButton(
                                    child:Text("Manual Setup"),
                                    onPressed: () async {

                                      await setSharedString("setupComplete", "yes");

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => AppConsole()),
                                            (Route<dynamic> route) => false,
                                      );

                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),),


                  ]

              ),
            ),
          ),
        ));


  }

}