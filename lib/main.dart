import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sentinel/config/routes.dart';
import 'package:sentinel/screens/intro/welcome.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/extra.dart' as android_extra;
import 'package:intent/typedExtra.dart' as android_typedExtra;
import 'package:intent/action.dart' as android_action;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_package_manager/flutter_package_manager.dart';
import 'package:sentinel/screens/main/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:foreground_service/foreground_service.dart';
import 'package:flutter/services.dart';
import 'package:sentinel/core/platformCaller.dart';
//import 'package:background_fetch/background_fetch.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'GLOBALS.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sentinel/config/routes.dart';
import 'package:sentinel/screens/intro/welcome.dart';
final LocalStorage store = new LocalStorage('r-schema.com.xerfia.sentinel');
bool _enabled = true;
int _status = 0;
List<DateTime> _events = [];




setLocalStorage(String mKey,Map m) async {
  await store.ready;       // Make sure store is ready
  store.setItem(mKey, m);
}

 Future<Map> getLocalStorage(String mKey) async {
  await store.ready;       // Make sure store is ready
  return store.getItem(mKey);
}


//
// void backgroundFetchHeadlessTask(String taskId) async {
//   print('[BackgroundFetch] Headless event received.');
//   BackgroundFetch.finish(taskId);
//
// }
//
//
// Future<void> initPlatformState() async {
//   // Configure BackgroundFetch.
//   BackgroundFetch.configure(BackgroundFetchConfig(
//       minimumFetchInterval: 15,
//       stopOnTerminate: false,
//       enableHeadless: true,
//       requiresBatteryNotLow: false,
//       requiresCharging: false,
//       requiresStorageNotLow: false,
//       requiresDeviceIdle: false,
//       requiredNetworkType: NetworkType.ANY
//   ), (String taskId) async {
//     // This is the fetch-event callback.
//     print("[BackgroundFetch] Event received $taskId");
//     StartForegroudService();
//     initFirewall();
//     _events.insert(0, new DateTime.now());
//     BackgroundFetch.finish(taskId);
//   }).then((int status) {
//     print('[BackgroundFetch] configure success: $status');
//     _status = status;
//   }).catchError((e) {
//     print('[BackgroundFetch] configure ERROR: $e');
//     _status = e;
//   });
// }

void main() async{


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

  );



  setupComplete = await getSharedString('setupComplete');
  fLaunch = await getSharedString('firstLaunch');
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  // initPlatformState();

  if(fLaunch=="complete") {
    getLocalStorage('database').then((data){
      virusDataBaseMap = data;
    });
    getLocalStorage('wifi').then((data) {
      wifiRuleMap = data;
    });
    getLocalStorage('other').then((data) {
      otherRuleMap = data;
    });
  } else{
    // String URL = "https://sentix16.xerfia.com/dataset.json";
    // var req = await http.get(URL);
    // var parsedData = json.decode(req.body);
    // setLocalStorage("database", parsedData);
    // virusDataBaseMap = parsedData;

  }

  // Directory docDirectory = await getApplicationDocumentsDirectory();
  //
  // final dir = Directory(docDirectory.path + "/assets");
  //
  //
  // print(infos);
  runApp(MyApp());



}



//
// void StartForegroudService() async {
//   ///if the app was killed+relaunched, this function will be executed again
//   ///but if the foreground service stayed alive,
//   ///this does not need to be re-done
//   if (!(await ForegroundService.foregroundServiceIsStarted())) {
//     await ForegroundService.setServiceIntervalSeconds(840);
//
//     //necessity of editMode is dubious (see function comments)
//     await ForegroundService.notification.startEditMode();
//
//     await ForegroundService.notification
//         .setTitle("Sentinel");
//     await ForegroundService.notification
//         .setText("Sentinel is scan complete");
//
//     await ForegroundService.notification.finishEditMode();
//
//     await ForegroundService.startForegroundService(foregroundServiceFunction);
//     await ForegroundService.getWakeLock();
//   }
//
//   ///this exists solely in the main app/isolate,
//   ///so needs to be redone after every app kill+relaunch
//   await ForegroundService.setupIsolateCommunication((data) {
//     debugPrint("main received: $data");
//   });
// }

// void foregroundServiceFunction() {
//   debugPrint("The current time is: ${DateTime.now()}");
//   ForegroundService.notification.setText("Protecting you device");
//
//   if (!ForegroundService.isIsolateCommunicationSetup) {
//     ForegroundService.setupIsolateCommunication((data) {
//       debugPrint("bg isolate received: $data");
//     });
//   }
//
//   ForegroundService.sendToPort("message from bg isolate");
// }














Future<List> getInstalledPackages() async {
  Uint8List _bytes;
  FlutterPackageManager.getInstalledPackages().then((packages){
    var i =0;
 while(i<packages.length) {
   FlutterPackageManager.getPackageInfo(packages[i]).then((val) {
     _bytes = base64.decode(val.appIconByteArray);
     Global_ICON.add(_bytes);
     i++;
   });
 }



  });
}
// getPackageInfo(String pkgn) async {
//   final PackageInfo info = await FlutterPackageManager.getPackageInfo(pkgn);
//   Uint8List _bytes = base64.decode(info.appIconByteArray);
//   return _bytes;
// }

setSharedString(String s,String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(s, k);
}

getSharedString(String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String stringValue = prefs.getString(k);
  return stringValue;
}

setSharedBool(String s,bool k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(s, k);
}
getSharedBool(String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(k);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(


        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Sentinel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void reload() async{
    String value;
    try{
      value = await platform.invokeMethod('reload');

    }catch(e){
      print(e);
    }
    print(value);

  }
  // @override
  // void initState() {
  //   super.initState();
  //   // getInstalledPackages().then((x){
  //   //   print(Global_ICON);
  //   // });
  //
  //
  // }


  @override
  Widget build(BuildContext context) {



    if(setupComplete.toString()=="yes")
      {
        return MaterialApp(
          theme: ThemeData.dark(),
          initialRoute:  AppConsole.route,
          routes: routes,
        );

      }
    else {
      return MaterialApp(
        theme: ThemeData.dark(),

        initialRoute: Welcome.route,
        routes: routes,
      );
    }
  }
  void Printy() async{
    String value;
    try{
      value = await platform.invokeMethod('connectVPN');

    }catch(e){
      print(e);
    }
    print(value);

  }
  void Search() async{
    String value;
    try{
      value = await platform.invokeMethod('search');

    }catch(e){
      print(e);
    }
    print(value);

  }


  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/dataset.json');}

    Future<void> uninstaller(String pkgName) async {
      android_intent.Intent()
        ..setAction(android_action.Action.ACTION_DELETE)
        ..setData(Uri.parse("package:$pkgName"))
        ..startActivity().catchError((e) => print(e));
      {
        return;
      }
    }
Future<void> basicVirusPackageScan(String flag) async {

    var db = await loadAsset();
    if(flag == "nml"){
    var virus_pkgs = json.decode(db.toString())['viruspkgs']['pkglist'];
    virus_pkgs.forEach((element) {
      if(pkgsD.contains(element)){
        print(element);
        uninstaller(element);
      }
    });}
    if(flag == "res"){
      var virus_pkgs = json.decode(db.toString())['restrictedapps']['india'];
      virus_pkgs.forEach((element) {
        if(pkgsD.contains(element)){
          print(element);
          uninstaller(element);
        }
      });}

}



}











