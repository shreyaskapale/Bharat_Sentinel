import 'package:flutter/material.dart';
import 'package:sentinel/screens/intro/getFireWallPermission.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class GetFilePermission extends StatefulWidget {
  static const route = "GetFilePermission";




  @override
  _GetFilePermissionState createState() => _GetFilePermissionState();

}

class _GetFilePermissionState extends State<GetFilePermission> {
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
                        'Getting Started', style: TextStyle(fontSize: 20),),),
                    AnimatedOpacity(
                      opacity: showTitle ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),

                      child: Column(
                        children: [
                          Image(image: AssetImage("assets/images/filePermission.png"),width: 100,),

                          Text("File Permission",style: TextStyle(fontSize: 18),),
                          Container(height: 80,
                              width: 300  ,
                              child: Text("We need file permission so that we can scan your files for viruses and keep you safe. To permit please press the allow button.",textAlign: TextAlign.center,)),

                          OutlineButton(
                              child: Text("Allow"),
                              onPressed: () async {
                                if (await Permission.storage.request ()
                                    .isGranted) {
                                  await Permission.storage.request();

                                  Navigator.pushReplacementNamed(context, GetFireWallPermission.route);

                                }


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