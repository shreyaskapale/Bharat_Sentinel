import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentinel/screens/intro/configure.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sentinel/screens/main/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/core/platformCaller.dart';

import '../../GLOBALS.dart';
import '../../main.dart';
class GetFireWallPermission extends StatefulWidget {
  static const route = "GetFireWallPermission";




  @override
  _GetFireWallPermissionState createState() => _GetFireWallPermissionState();

}

class _GetFireWallPermissionState extends State<GetFireWallPermission> {


  void global_iface(String iface,bool rule) async{
    List<dynamic> pkglist = <dynamic>[];
    setLocalStorage(iface,iface=="wifi"?wifiRuleMap:otherRuleMap);

    try{
      pkglist = await platform.invokeMethod('whitelist',{"status":rule.toString(),"iface":iface});
    }catch(e){
      print(e);
    }

  }




  bool showCompany = false;
  bool showTitle = false;


  @protected
  @mustCallSuper
  // ignore: must_call_super
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showTitle = true;
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
                      opacity: showTitle ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),

                      child: Column(
                        children: [
                          Image(image: AssetImage("assets/images/vpnPermission.png"),width: 100,),

                          Text("VPN Permission",style: TextStyle(fontSize: 18),),
                          Container(height: 120,
                              width: 340  ,
                              child: Text("We need VPN permission to run our firewall technology to protect your private data from analytics and spywares. Note this vpn doesn't connect your mobile to any external server it connects to a local server which sentinel runs locally on your device. To permit please press the allow button",textAlign: TextAlign.center,)),

                          OutlineButton(
                              child: Text("Allow"),
                              onPressed: () async {
                                firewallPermission();
                                 global_iface("other",true);
                                 global_iface("wifi",true);

                                Navigator.pushReplacementNamed(context, Configure.route);

                              }),



                        ],
                      ),),


                  ]

              ),
            ),
          ),
        ));


  }
  _launchURL(String URL) async {
    var url = URL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}