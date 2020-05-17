import 'package:IoT_Agric_App/drawer.dart';
import 'package:IoT_Agric_App/utils/database_helper.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAboutPageState createState() => _MyAboutPageState();
}
class _MyAboutPageState extends State<About> {
  final Color primaryColor = Color(0xff99cc33);
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120.0,
        child: Image.asset('assets/images/home.jpg'),
      ),
    );
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset App Data?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This will delete all the data collected so far with the app.'),
                  Text(' Are you sure?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Reset'),
                onPressed: () {
                  DatabaseHelper().deleteAll();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }


    Future<void> _aboutProjet() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Project Detail'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This is a simple app for viewing sensor readings and sending commands to Iot Device on the farm. The app also plot chart of the various readings with time.'),
                  Text(' Vist IoTDev Lab for more detail'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok! Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _aboutStudent() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Student Details'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Joshua Lartey and Samuel Ofori are both final year student of UCC. Both student are very passionate about this programming, hene the came about of this project'),
                  Text('Call Joshua on 0249643365 and samuel on 0249643365'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok! Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _contactUs() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contact Us'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('We are located on the Campus of UCC Science Block on the second floor'),
                  Text(' Call Us on 0249643365'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok! Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _aboutIoTDevLab() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('About IoT Dev Lab'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This is a well establish and well purpose lab under the Department of Computer science and Information technology for learning and development of embedded system and IoT Solutions'),
                  Text(' Vist IoTDev Lab for more detail'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok! Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }


    return Scaffold(
        appBar: AppBar(
          title: Text(
            'About',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
//        elevation: 0.5,
        ),
        body: ListView(padding: const EdgeInsets.fromLTRB(15,0,15,0),
          children: <Widget>[
            logo,
            SizedBox(height: 2.0,),
           createButton(Colors.red, _aboutProjet, 'About Project'),

            SizedBox(height: 5.0,),
           createButton(Colors.indigoAccent, _aboutIoTDevLab, 'About IoTDev Lab'),

            SizedBox(height: 5.0,),
            createButton(Colors.green, _aboutStudent, 'About Student'),

            SizedBox(height: 5.0,),
           createButton(Colors.blue, _contactUs,'Contact Us'),

            SizedBox(height: 5.0,),
            createButton(Colors.purple, _showMyDialog, 'Reset App Data', )

          ],
        ),
        drawer: Drawer(child: drawer,)
    );
  }
}

RaisedButton createButton(Color color, Future<void> Function() perform, String text,  ) {
  return RaisedButton(
    color: color,
    onPressed: () async => perform(),
    textColor: Colors.white,
    child: Center(
      child: Text(text),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}
