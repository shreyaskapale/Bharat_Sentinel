import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/extra.dart' as android_extra;
import 'package:intent/typedExtra.dart' as android_typedExtra;
import 'package:intent/action.dart' as android_action;
import 'package:localstorage/localstorage.dart';
import 'package:sentinel/GLOBALS.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_package_manager/flutter_package_manager.dart';
List selectedForDelete =  [];
List foundIssues = [];
List pkgsF;
class VirusScanner extends StatefulWidget {
  static const route = "VirusScanner";


  @override
  _VirusScannerState createState() => _VirusScannerState();
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

deleteFile(String p){
  File selected = File(p);
  selected.delete();
}

class _VirusScannerState extends State<VirusScanner> {

  @override
  void initState() {
    super.initState();
    // getInstalledPackages().then((x){
    //   print(Global_ICON);
    // });


  }

void deleteSelected(){
    selectedForDelete.forEach((item) {
      if(item[0]=="/") {
        deleteFile(item);
      }else{
        uninstaller(item);
      }
    });
}

  showAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle, String buttonCancelTitle) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(buttonCancelTitle),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text(buttonAcceptTitle),
        onPressed: () {
          setState(() {

            deleteSelected();
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  Future<void> basicVirusPackageScan(String flag) async {

    blockB();

    await new Future.delayed(const Duration(seconds : 3));
    List found= [];
    List _ffound;
    if(flag == "nml"){
      var virus_pkgs = virusDataBaseMap['viruspkgs']['pkglist'];
      virus_pkgs.forEach((element) {
        if(pkgsF.contains(element)){
          // uninstaller(element);
        found.add(element);
        foundIssues.add(element);
        }




      });
      _ffound = await basicFileScan(virus_pkgs);


    }
    if(flag == "res"){
      var virus_pkgs = virusDataBaseMap['restrictedapps']['india'];
      virus_pkgs.forEach((element) {
        if(pkgsF.contains(element)){
          print(element);
          // uninstaller(element);
          found.add(element);

        }
      });}


    return found+_ffound;

  }

  static const platform = const MethodChannel('com.xerfia.bharatsentinel/bharatsentinel');
  void blockB() async{
    List<dynamic> pkglist = <dynamic>[];


    try{
   pkgsF = await FlutterPackageManager.getInstalledPackages();




    }catch(e){
      print(e);
    }




  }


  ListTile VirusFileTile(item) {

    return ListTile(
      leading: Column(
        children: [
          Icon(Icons.insert_drive_file,size: 35,color: Colors.orange,),
          Container(child: Text("File"))
        ],
      ),
      title: Text(item.path,style: TextStyle(fontSize: 12),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            alignment: Alignment.topLeft,
            child: Card(
              color: Colors.orangeAccent,

              child: Container(padding: EdgeInsets.all(0.5),child: Text("Suspicious")),),
          ),
          Checkbox(
            activeColor: Colors.grey,
            value: selectedForDelete.contains(item.path),
            onChanged: (newValue) {
              setState(() {
                if(selectedForDelete.contains(item.path)) {
                  selectedForDelete.remove(item.path);
                }else{
                  selectedForDelete.add(item.path);
                }
              });
            }, //  <-- leading Checkbox
          )
        ],
      ),
    );
  }

  ListTile VirusPkgTile(item) {
    return ListTile(

      leading: Column(
        children: [

          Icon(Icons.bug_report,size: 40,color: Color(0xFFE54C4C),),

          Text("App")
        ],
      ),
      title: Text('${pkgsN[pkgsF.indexOf(item)]}'),
      subtitle: Text(item),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            alignment: Alignment.topLeft,
            child: Card(
              color: Colors.redAccent,

              child: Container(padding: EdgeInsets.all(0.5),child: Text("Dangerous")),),
          ),
          Checkbox(
            activeColor: Colors.blueGrey,
            value: selectedForDelete.contains(item),
            onChanged: (newValue) {
              setState(() {
                if(selectedForDelete.contains(item)) {
                  selectedForDelete.remove(item);
                }else{
                  selectedForDelete.add(item);
                }
              });
            }, //  <-- leading Checkbox
          )
        ],
      ),
    );
  }


  Future<List> basicFileScan(List v) async {
    if (await Permission.storage.request ()
    .isGranted) {
      await Permission.storage.request();


      Directory dir = Directory('/storage/emulated/0/');
    String pathF = dir.toString();
    print(pathF);
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _foundFiles = [];
    List _ffound =[];
    _files = dir.listSync(recursive: true, followLinks: false);
    for(FileSystemEntity entity in _files) {
    String path = entity.path;
    if(path.endsWith('.apk'))



        _foundFiles.add(entity);




    }
 _foundFiles.forEach((element) {
   String tmp = element.toString();
   v.forEach((m) {
     print(tmp);
     if(tmp.contains(m)){
    _ffound.add(element);
    foundIssues.add(element.path);
     }
   });

 });
    return _ffound;

    }
  }
  bool selectAll=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Virus Scanner",style: TextStyle(color: Color(0xFFF2F3F1)),),
        backgroundColor: Color(0xFF505050),
      ),
      body: Center(
        child: FutureBuilder(
          future: basicVirusPackageScan("nml"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Center(child: Column(

                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(child: Icon(FontAwesomeIcons.shieldAlt,size: 50,color: Colors.grey,),
                              onTap:(){ },

                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text("Total Issues  Found "),
                            Container(
                              height: 25,
                              width: 25,
                              child: Center(child: Text(snapshot.data.length.toString(),style: TextStyle(color:Colors.white),)),
                              decoration: new BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),)
                          ],
                        ),
                      ],
                    )),

                  ),),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index];
                        return Card(
                          child: item.runtimeType!=String?VirusFileTile(item):VirusPkgTile(item)

                        );
                      },
                    ),
                  ),
                  Card(
                    color: Color(0xFF505050),
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child:Row(children: [
                              Text("Select All",style: TextStyle(color: Color(0xFFF2F3F1)),),
                              Checkbox(
                                activeColor: Colors.grey,
                                value: selectAll,
                                onChanged: (newValue) {
                                  setState(() {
                                    print(newValue);
                                   selectAll = newValue;
                                   if(newValue==true)
                                     {
                                       print(selectedForDelete);
                                       selectedForDelete = foundIssues.toList();


                                     }else{
                                     selectedForDelete.clear();
                                   }
                                  });
                                }, //  <-- leading Checkbox
                              )
                            ],),

                          ),
                          Container(height: double.infinity,color:Colors.grey,width:2),
                          GestureDetector(
                            onTap: (){

                                showAlertDialog(context, "Deleting selected files", "Warning", "Ok", "Cancel");


                            },
                            child: Container(

                                child: FaIcon(FontAwesomeIcons.trashAlt,color:Color(0xFFF2F3F1),)

                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                    children: [

                   SizedBox(
                      height: 200.0,
                      width: 200.0,
                      child:
                      CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFF505050)),
                          strokeWidth: 10.0)
                  ),
                      Text("S C A N N I N G")
                ]
                )
              ]
            );
          },
        ),
      ),
    );


  }


}

