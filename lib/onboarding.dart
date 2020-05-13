import 'package:IoT_Agric_App/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'util.dart';

class Onboarding extends StatefulWidget {
  Onboarding({Key key}) : super(key: key);

  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
  }

//  @override
//  void dispose() {
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Hero(
                  tag: 'homeIcon',
                  child: Image.asset('assets/images/home.jpg'),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Text(
                      'IoT Irrigation System',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.TextHeader),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is a simple app for viewing sensor readings and sending commands to Iot Device on the farm. The app also plot chart of the various readings with time.',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: CustomColors.BlueDark,
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          CustomColors.GreenLight,
                          CustomColors.GreenDark,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.GreenShadow,
                          blurRadius: 15.0,
                          spreadRadius: 7.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
