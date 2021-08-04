import 'package:flutter/material.dart';
import 'package:sentinel/screens/intro/getFilePermission.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sentinel/auth/login.dart';
class Introduction extends StatefulWidget {
  static const route = "Introduction";




  @override
  _IntroductionState createState() => _IntroductionState();

}

class _IntroductionState extends State<Introduction> {
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
              child: ListView(
                children: [
                  Column(
                      children: [
                        SizedBox(
                          height: 300,
                        ),

                        AnimatedOpacity(
                          opacity: showCompany ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),

                          child: Text(
                            'Welcome to Sentinel', style: TextStyle(fontSize: 20),),),
                        AnimatedOpacity(
                          opacity: showTitle ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 1000),

                          child: Column(
                            children: [
                              Text("Introduction",style: TextStyle(fontSize: 18),),
                              Container(height: 150,
                                  width: 300  ,
                                  child: Text("Thank you for choosing Sentinel. Our only motto is to make our world more secure and safer place to live. Privacy,"
                                      " Integrity and Security are the core beliefs of Sentinel"
                                      " and that is the reason why Xerfia does not collect any personal information from you except those by Google Services.",textAlign: TextAlign.center,)),
                              Container(height: 100,
                                  width: 300  ,
                                  child: Text("Unlike most apps we believe in transparency so we will educate you with the permissions we require to protect your device. Please press ok to continue",textAlign: TextAlign.center,)),
                              SizedBox(height: 10,),
                              OutlineButton(
                                  child: Text("Ok"),
                                  onPressed: (){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  }),

SizedBox(height: 60,),
                              GestureDetector(child: Text("Privacy Policy",style: TextStyle(color: Colors.blueAccent)),onTap: (){
                                _launchURL("http://sentinel.xerfia.com/privacy-policy-free.html");

                              },),
                              GestureDetector(child: Text("Terms & Conditions",style: TextStyle(color: Colors.blueAccent)),onTap: (){
                                _launchURL("http://sentinel.xerfia.com/terms-and-Conditions-free.html");

                              },),

                              Container(width:350,child: Text("By clicking Ok, you agree to our terms, conditions and privacy policy",textAlign: TextAlign.center)),


                            ],
                          ),),


                      ]

                  ),
                ],
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