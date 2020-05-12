import 'package:IoT_Agric_App/mqtt/mqtt_page.dart';
import 'package:IoT_Agric_App/onboarding.dart';
import 'package:flutter/material.dart';


void main() {
   Mqttwrapper().initializemqtt();
  runApp(App());}


class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Irrigation System',
      theme: ThemeData(
        primaryColor: Colors.green,
        fontFamily: 'Montserrat',
      ),
      home:
      Onboarding(),
    );
  }
}
