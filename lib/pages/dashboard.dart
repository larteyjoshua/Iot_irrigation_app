import 'package:IoT_Agric_App/drawer.dart';
import 'package:IoT_Agric_App/mqtt/mqtt_page.dart';
import 'package:IoT_Agric_App/utils/database_helper.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DashBoard> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final Color primaryColor = Color(0xff99cc33);
  bool _isLoading = false;
  double _temp = 0.0;
  double _moist = 0.0;
  double _ph = 0.0;
  double _waterused = 0.0;

  @override
  void initState(){
    super.initState();
    Mqttwrapper().mqttController.stream.listen(listenToClient);
  }

//  @override
//  void dispose() {
//
//  }

  void listenToClient(Map data){
    if (this.mounted) {
      setState(() {
        print("I am coming from the iot device $data");
//     databaseHelper.InsertDatareading(Datareading.fromJson(data));

        double m = double.parse(data["moisture"].toString());
        double t = double.parse(data["temperature"].toString());
        double p = double.parse(data["ph"].toString());
        double w = double.parse(data["waterused"].toString());

        _isLoading = true;
        _moist = m;
        _temp = t;
        _waterused = w;
        _ph = p;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
//        elevation: 0.5,
      ),
      body:
      ListView(
        children: <Widget>[
          SizedBox(height: 10.0,),
          _createListTile("Temperature",  _temp.toString(), "C",),
          SizedBox(height: 5.0,),
          _createListTile("Moisture", _moist.toString(), "%", ),
          SizedBox(height: 5.0,),
          _createListTile("PH",  _ph.toString(), "",),
          SizedBox(height: 10.0,),
          _createListTile("Amount of Water Used",  _waterused .toString(), "mL",),
        ],
      ),
      drawer: drawer,
    );
  }

  _createListTile(String title, String value, String initials) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, bottom: 5.0, right: 5.0),
      child: Card(
        elevation: 0.5,
        child: Container(
          height: 150.0,
          child: ListTile(
            trailing: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: 30.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(initials, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ),),
            ),

            title:  Text(title, style: TextStyle(
                color: Colors.black87,
                fontSize: 30.0,
                fontWeight: FontWeight.bold
            ),) ,
            subtitle: !_isLoading ? Text(value, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48.0, color: Colors.black),) : Center(child:CircularProgressIndicator(strokeWidth: 1.0,)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}
