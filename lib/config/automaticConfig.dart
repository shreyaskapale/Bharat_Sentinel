import 'package:sentinel/core/platformCaller.dart';

import '../GLOBALS.dart';
import '../main.dart';

void global_iface(String iface,bool rule) async{
  List<dynamic> pkglist = <dynamic>[];
  setLocalStorage(iface,iface=="wifi"?wifiRuleMap:otherRuleMap);

  try{
    pkglist = await platform.invokeMethod('whitelist',{"status":rule.toString(),"iface":iface});
  }catch(e){
    print(e);
  }

}