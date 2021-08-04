import 'package:flutter/services.dart';
import 'package:sentinel/GLOBALS.dart';

const platform = const MethodChannel('com.xerfia.sentinel/sentinel');
void initFirewall() async{
  List<dynamic> pkglist = <dynamic>[];

  try{
    pkglist = await platform.invokeMethod('blockBrowser');

  }catch(e){
    print(e);
  }
  pkgs = pkglist;
  pkgs.forEach((element) {
    var x = element.split('::');
    pkgsN.add(x[0]);
    pkgsD.add(x[1]);

    if(fLaunch==null) {
      wifiRuleMap[x[1]] = false;
      otherRuleMap[x[1]] = false;
    }
  });
}
void firewallPermission() async{
  String value;
  try{
    value = await platform.invokeMethod('connectVPN');

  }catch(e){
    print(e);
  }
  print(value);

}