import 'package:IoT_Agric_App/drawer.dart';
import 'package:IoT_Agric_App/mqtt/mqtt_page.dart';
import 'package:flutter/material.dart';

class PumpControl extends StatefulWidget {
  PumpControl({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PumpControl> {
  final Color primaryColor = Color(0xff99cc33);
  bool _canShowButton = false;
  bool _canShowButtonon = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pump Control',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
//        elevation: 0.5,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ButtonTheme(
                  minWidth: 300.0,
                  height: 70.0,
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text(
                      _canShowButton ? 'Pump Status' : 'Pump Status',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() => _canShowButton = !_canShowButton);
                    },
                  )),
              SizedBox(
                height: 1.0,
              ),
              Column(children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                _canShowButton
                    ? ButtonTheme(
                        minWidth: 300,
                        height: 70,
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text('Automatic'),
                          onPressed: () {
                            publish('automatic');
                          },
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 50.0,
                ),
                _canShowButton
                    ? ButtonTheme(
                        minWidth: 300,
                        height: 70,
                        child: RaisedButton(
                          color: Colors.yellow,
                          child: Text(_canShowButtonon ? 'Manual' : 'Manual'),
                          onPressed: () {
                            publish('manual');
                            setState(
                                () => _canShowButtonon = !_canShowButtonon);
                          },
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 20),
                _canShowButtonon
                    ? SizedBox(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: ButtonTheme(
                                height: 70,
                                child: RaisedButton(
                                  color: Colors.green,
                                  child: Text('On'),
                                  onPressed: () {
                                    publish('on');
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ButtonTheme(
                                height: 70,
                                child: RaisedButton(
                                  color: Colors.red,
                                  child: Text('Off'),
                                  onPressed: () {
                                    publish('off');
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ]),
            ],
          ),
        ),
        drawer: Drawer(
          child: drawer,
        ));
  }

  void publish(String value) {
    Mqttwrapper().publish(value);
  }
}
