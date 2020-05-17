
import 'package:IoT_Agric_App/drawer.dart';
import 'package:IoT_Agric_App/mqtt/mqtt_page.dart';
import 'package:IoT_Agric_App/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WaterGraph extends StatefulWidget {
  WaterGraph({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyWaterGraphPageState createState() => _MyWaterGraphPageState();
}

class SubscriberSeries {
  final String time;
  final double waterused;

  SubscriberSeries(
      {@required this.time,
        @required this.waterused,});
}

class SubscriberChart extends StatelessWidget {
  final List<SubscriberSeries> data;
  SubscriberChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        padding: EdgeInsets.all(20),
        child:
        Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:Column(
                    children: <Widget>[
                      Text(
                        "Amount of Water Used",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Expanded(
                          child:
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                  labelRotation: 90,
                                  title: AxisTitle(
                                      text: 'TIME',
                                      textStyle: ChartTextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300,
                                      )
                                  )
                              ),

                              series: <ChartSeries>[
                                // Renders line chart
                                ColumnSeries<SubscriberSeries, String>(
                                  dataSource: data,
                                  color: Colors.green   ,
//                                    borderMode: AreaBorderMode.excludeBottom,
//                                    borderColor: Colors.green,
                                  xValueMapper: (SubscriberSeries sales, _) => sales.time,
                                  yValueMapper: (SubscriberSeries sales, _) => sales.waterused,
                                )
                              ]
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}

class _MyWaterGraphPageState extends State<WaterGraph> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final Color primaryColor = Color(0xff99cc33);
  bool _isLoading = false;
  double _waterused = 0.0;
  List<SubscriberSeries> waterpoints = [];

  @override
  void initState() {
    super.initState();
    Mqttwrapper().mqttController.stream.listen(listenToClient);
    fetchValues();
  }

  fetchValues() {
    DatabaseHelper().getReadingwaterusedList().then((data) {
      for (Map map in data) {
        waterpoints.add(SubscriberSeries(
          time: map['time'],
          waterused: double.tryParse('${map['waterused']}'),
        ));
        print('Second: ${map['time']}\tWater: ${double.tryParse(
            '${map['waterused']}')}');
      }
      setState(() {});
    });
  }

  Future myTypedFuture() async {
    await Future.delayed(Duration(seconds: 3));
    fetchValues();
  }

  void listenToClient(final data) {
    if (this.mounted) {
      setState(() {
        print("I am coming from the iot device $data");
//      databaseHelper.InsertDatareading(Datareading.fromJson(data));
        double w = double.parse(data["waterused"].toString());

        _isLoading = true;
        _waterused = w;
        waterpoints.clear();
        print('List removed');
        myTypedFuture();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Water Used Graph',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
//        elevation: 0.5,
        ),
        body: ListView(children: <Widget>[
          SizedBox(height: 10.0,),
          _createListTile("Amount of Water Used", _waterused.toString(), "mL",),
          SizedBox(height: 5.0,),
          SubscriberChart(
            data: waterpoints,
          )
        ]),
        drawer: Drawer(child: drawer,)
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
              child: Text(initials, style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),),
            ),

            title: Text(title, style: TextStyle(
                color: Colors.black87,
                fontSize: 30.0,
                fontWeight: FontWeight.bold
            ),),
            subtitle: !_isLoading ? Text(value, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48.0, color: Colors.black),) : Center(
                child: CircularProgressIndicator(strokeWidth: 1.0,)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
