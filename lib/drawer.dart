import 'package:IoT_Agric_App/pages/about.dart';
import 'package:IoT_Agric_App/pages/dashboard.dart';
import 'package:IoT_Agric_App/pages/moisgraph.dart';
import 'package:IoT_Agric_App/pages/phgraph.dart';
import 'package:IoT_Agric_App/pages/pumpcontrol.dart';
import 'package:IoT_Agric_App/pages/tempgraph.dart';
import 'package:IoT_Agric_App/pages/waterused.dart';
import 'package:flutter/material.dart';

final drawer = Drawer(child: drawerItems);
final drawerHeader = UserAccountsDrawerHeader(
  accountName: Text('Admin'),
  accountEmail: Text('larteyjoshua@gmail.com'),
  currentAccountPicture: CircleAvatar(
    child: FlutterLogo(size: 42.0),
    backgroundColor: Colors.white,
  ),
);
final drawerItems = Builder(builder: (context) {
  return ListView(
    children: <Widget>[
      drawerHeader,
      ListTile(
        title: Text('Dashboard'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashBoard()),
          );
        },
      ),
      ListTile(
        title: Text('Pump Control'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PumpControl()),
          );
        },
      ),
      ListTile(
        title: Text('Temperature Graph'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TempGraph()),
          );
        },
      ),
      ListTile(
        title: Text('Moisture Graph'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MoistGraph()),
          );
        },
      ),
      ListTile(
        title: Text('PH Graph'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PhGraph()),
          );
        },
      ),
      ListTile(
        title: Text('Water Used Graph'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WaterGraph()),
          );
        },
      ),
      ListTile(
        title: Text('About'),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => About()),
          );
        },
      )
    ],
  );
});
