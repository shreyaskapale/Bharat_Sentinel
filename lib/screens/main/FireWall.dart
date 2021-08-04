import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentinel/GLOBALS.dart';
import 'package:sentinel/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SentinelWall extends StatefulWidget {
  static const route = "SentinelWall";

  @override
  _SentinelWallState createState() => _SentinelWallState();

}



class _SentinelWallState extends State<SentinelWall> {
  static const platform = const MethodChannel('com.xerfia.sentinel/sentinel');

  showAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle, String buttonCancelTitle, Map ruleList,String iface) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(buttonCancelTitle),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text(buttonAcceptTitle),
        onPressed: () async {
          if(iface=="wifi"){
            setState(() {
              otherRuleMap.forEach((key,value){
                wifiRuleMap[key] = false;
              });
              setLocalStorage(iface,wifiRuleMap);
            });

          }
          if(iface=="other"){
            setState(() {
              otherRuleMap.forEach((key,value){
                otherRuleMap[key] = false;
              });
              setLocalStorage(iface,otherRuleMap);
            });

          }

          Navigator.pop(context);
          try{
            await platform.invokeMethod('reset_rules',{"iface":iface});


          }catch(e){
            print(e);
          }


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

  void resetWifi() {

    showAlertDialog(context, 'Are you sure you want reset all the rules for wifi?', "Warning" , "Yes", "Cancel",wifiRuleMap,"wifi");


  }
  void resetOther()async{
    showAlertDialog(context, 'Are you sure you want reset all the rules for wifi?', "Warning" , "Yes", "Cancel",otherRuleMap,"other");
  }


  void setRule(String pkgname,bool rule,String iface) async{
    if(fLaunch == null){
      setLocalStorage("wifi",wifiRuleMap);
      setLocalStorage("other", otherRuleMap);
      await setSharedString('firstLaunch','complete');
    }
    List<dynamic> pkglist = <dynamic>[];
    await setLocalStorage(iface,iface=="wifi"?wifiRuleMap:otherRuleMap);





    try{
      pkglist = await platform.invokeMethod('setRuleReload',{"rule":rule.toString(),"pkgname":pkgname,"nwktype":iface});



    }catch(e){
      print(e);
    }
    pkgs = pkglist;
    pkgs.forEach((element) {
      var x = element.split('::');
      pkgsN.add(x[0]);
      pkgsD.add(x[1]);

    });

  }
  void global_iface(String iface,bool rule) async{
    List<dynamic> pkglist = <dynamic>[];
    setLocalStorage(iface,iface=="wifi"?wifiRuleMap:otherRuleMap);

    try{
      pkglist = await platform.invokeMethod('whitelist',{"status":rule.toString(),"iface":iface});
    }catch(e){
      print(e);
    }

  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   pkgs.forEach((element) {
  //     var x = element.split('::');
  //     pkgsN.add(x[0]);
  //     pkgsD.add(x[1]);
  //
  //   });
  //
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Second Route"),
  //     ),
  //     body: ListView.builder(
  //     itemCount: pkgs.length,
  //   itemBuilder: (context, index) {
  //   return ListTile(
  //     leading: Icon(Icons.android),
  //     title: Text(pkgsN[index]),
  //     subtitle:Text(pkgsD[index]) ,
  //     );
  //     })
  //   //   body:Center(child: Image.memory(Global_ICON),)
  //   );
  // }



  TextEditingController editingController = TextEditingController();

  List<String> duplicateItems = pkgsD;
  List<bool> ruleTableWifi = List<bool>.generate(pkgs.length, (i) =>false);
  List<bool> ruleTableOther = List<bool>.generate(pkgs.length, (i) =>false);
  var items = List<String>();

  @override
  void initState() {
    setRule('com.xerfia.sentinel', false,"other");
    setRule('com.xerfia.sentinel', false,"wifi");
    items.addAll(duplicateItems);
    super.initState();
  }
  void _settingModalBottomSheet(context){
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    );
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext bc){
          return Container(


            child: new Wrap(
              children: <Widget>[
                Card(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(20)),
                  ),
                  child: ListTile(
                      leading: new Icon(Icons.lock_open),
                      title: new Text('Show only enabled apps'),
                      onTap: () =>
                      {
                        setState(() {

                          List<String> temp = [];
                          items.forEach((element) {
                            if(wifiRuleMap[element] || otherRuleMap[element]){
                              if(!temp.contains(element)) {
                                temp.add(element);
                              }
                            }
                          });
                          items.length = temp.length;
                          items.clear();
                          items.addAll(temp);
                          Navigator.pop(context);

                        })

                      }
                  ),
                ),
                Card(

                  child: Container(

                    padding: const EdgeInsets.all(2.0),
                    child:  ListTile(
                      leading: Icon(Icons.all_inclusive),
                      title:Text('Show all apps'),
                      onTap: () => {
                        {
                          setState(() {

                            duplicateItems = pkgsD;
                            items.length = pkgsD.length;
                            items.clear();
                            items.addAll(duplicateItems);
                            Navigator.pop(context);

                          })
                        }

                      },
                    ),
                  ),
                ),    Card(

                  child: Container(

                    padding: const EdgeInsets.all(2.0),
                    child:  ListTile(
                      leading: Icon(Icons.refresh),
                      title:Text('Reset all mobile data rules'),
                      onTap: () => {
                        {
                          setState(() {

                            resetOther();

                          })
                        }

                      },
                    ),
                  ),
                ),  Card(

                  child: Container(

                    padding: const EdgeInsets.all(2.0),
                    child:  ListTile(
                      leading: Icon(Icons.refresh),
                      title:Text('Reset all wifi rules'),
                      onTap: () => {
                        {
                          setState(() {
                            resetWifi();

                          })
                        }

                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        var temp = item + pkgsN[pkgsD.indexOf(item)].toLowerCase();
        if(temp.contains(query)) {
          if(!dummyListData.contains(item)) {
            dummyListData.add(item);
          }
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
  bool _getRuleWifi(String pkn){
    var rule_id = pkgsD.indexOf(pkn);
    return ruleTableWifi[rule_id];
  }
  bool _getRuleOther(String pkn){
    var rule_id = pkgsD.indexOf(pkn);
    return ruleTableOther[rule_id];
  }
  int _getRuleId(String pkn){
    return pkgsD.indexOf(pkn);
  }

  bool isWifiAll=false;
  bool isOtherAll=false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color(0xFF696969),
        onPressed: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          _settingModalBottomSheet(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: new Icon(Icons.filter_list),
      ),
      appBar: new AppBar(
        backgroundColor: Color(0xFF696969),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SentinelWall'),

            Column(
              children: [
                Text("Firewall ON/OFF",style:TextStyle(
                    fontSize: 10
                )),
                Row(
                  children: [
                    CustomSwitch(
                      icon_disable: Icon(FontAwesomeIcons.signal,size:10,color:Colors.black45),
                      icon_enable: Icon(FontAwesomeIcons.signal,size:10,color:Colors.green),
                      value: isOtherAll,
                      onChanged: (value){
                        setState(() {
                          global_iface("other", value);
                          isOtherAll= value;


                        });
                      },

                    ),
                    SizedBox(width:5),
                    CustomSwitch(
                      icon_disable: Icon(Icons.wifi,size:15,color: Colors.black45,),
                      icon_enable: Icon(Icons.wifi,size:15,color:Colors.green),
                      value: isWifiAll,
                      onChanged: (value){
                        setState(() {
                          global_iface("wifi", value);
                          isWifiAll= value;


                        });
                      },

                    ),
                  ],
                ),

              ],
            ),

          ],),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search,color:Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              ),
            ),
            Expanded(
              child: Scrollbar(child:ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(

                    child: Container(
                      padding: const EdgeInsets.all(8.0),

                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.android,color:Colors.lightGreen),
                        title:Text('${pkgsN[pkgsD.indexOf(items[index])]}'),
                        subtitle: Text('${items[index]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomSwitch(
                              icon_enable:Icon(Icons.wifi,size:15,color:Colors.black45),
                              icon_disable: Icon(Icons.wifi,size:15,color: Colors.black45,),
                              value: wifiRuleMap[items[index]],
                              onChanged: (value){
                                setState(() {
                                  wifiRuleMap[items[index]] = value;
                                  setRule(items[index],value,"wifi");

                                });
                              },
                              //activeTrackColor: Colors.lightGreenAccent,
                              //activeColor: Colors.green,
                            ),
                            SizedBox(width:5),
                            CustomSwitch(
                              icon_disable: Icon(FontAwesomeIcons.signal,size:10,color: Colors.black45),
                              icon_enable: Icon(FontAwesomeIcons.signal,size:10,color:Colors.black45),
                              value: otherRuleMap[items[index]],
                              onChanged: (value){
                                setState(() {

                                  otherRuleMap[items[index]] = value;
                                  setRule(items[index],value,"other");

                                });
                              },

                            ),
                          ],
                        ),

                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomSwitch extends StatefulWidget {
  final bool value;
  final Icon icon_enable;
  final Icon icon_disable;
  final ValueChanged<bool> onChanged;

  CustomSwitch({
    Key key,
    this.value,this.icon_enable,this.icon_disable,
    this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft :Alignment.centerRight).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 45.0,
            height: 28.0,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(24.0),
              color: widget.value
                  ? Colors.lightGreenAccent
                  : Colors.grey,),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child:  Container(
                alignment: widget.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(

                  width: 20.0,
                  height: 20.0,
                  child:widget.value?widget.icon_enable:widget.icon_disable,
                  decoration: BoxDecoration(

                      shape: BoxShape.circle,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }}