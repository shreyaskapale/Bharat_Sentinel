
import 'package:sentinel/screens/intro/configure.dart';
import 'package:sentinel/screens/intro/introduction.dart';
import 'package:sentinel/screens/intro/welcome.dart';
import 'package:sentinel/screens/intro/getFilePermission.dart';
import 'package:sentinel/screens/intro/getFireWallPermission.dart';
import 'package:sentinel/screens/main/home.dart';
import 'package:sentinel/screens/main/VirusScanner.dart';
import 'package:sentinel/screens/main/BannedScanner.dart';
import 'package:sentinel/screens/main/FireWall.dart';
import 'package:sentinel/main.dart';

final routes = {
  Welcome.route: (context) => Welcome(),
  GetFilePermission.route: (context) => GetFilePermission(),
  GetFireWallPermission.route: (context) => GetFireWallPermission(),
  Introduction.route: (context) => Introduction(),
  VirusScanner.route: (context) => VirusScanner(),
  BannedAppScanner.route: (context) => BannedAppScanner(),
  SentinelWall.route: (context) => SentinelWall(),
  Configure.route: (context) => Configure(),
  AppConsole.route:(context)=>AppConsole(),


};