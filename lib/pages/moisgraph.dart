import 'package:IoT_Agric_App/drawer.dart';
import 'package:IoT_Agric_App/mqtt/mqtt_page.dart';
import 'package:IoT_Agric_App/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class MoistGraph extends StatefulWidget {
  MoistGraph({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyMoistGraphPageState createState() => _MyMoistGraphPageState();
}

class SubscriberSeries {
  final String time;
  final double moisture;

  SubscriberSeries(
      {@required this.time,
        @required this.moisture,});
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
                        " Soil PH",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Expanded(
                          child:
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                  labelRotation: 90,
                                  labelPlacement: LabelPlacement.onTicks,
                                  title: AxisTitle(
                                      text: 'TIME',
                                      textStyle: ChartTextStyle(
                                        color: Colors.deepOrange,
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300,
                                      )
                                  )
                              ),

                              series: <ChartSeries>[
                                // Renders line chart
                                AreaSeries<SubscriberSeries, String>(
                                    dataSource: data,
                                    color: Colors.green,
                                    borderColor: Colors.green,
                                    xValueMapper: (SubscriberSeries sales, _) => sales.time,
                                    yValueMapper: (SubscriberSeries sales, _) => sales.moisture

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

class _MyMoistGraphPageState extends State<MoistGraph> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final Color primaryColor = Color(0xff99cc33);
  bool _isLoading = false;
  double _moist = 0.0;
  List<SubscriberSeries> moistpoints = [];

  @override
  void initState() {
    super.initState();
    Mqttwrapper().mqttController.stream.listen(listenToClient);
    fetchValues();
  }

  fetchValues() {
    DatabaseHelper().getReadingMoistureList().then((data) {
      for (Map map in data) {
        moistpoints.add(SubscriberSeries(
          time:map['time'],
          moisture: double.tryParse('${map['moisture']}'),
        ));
        print('time: ${map['time']}\tMoisture: ${double.tryParse('${map['moisture']}')}');
      }
      setState((){});
    });
  }
  Future myTypedFuture() async {
    await Future.delayed(Duration(seconds: 4));
    fetchValues();

  }

  void listenToClient(final data) {
    if (this.mounted) {
      setState(() {
        print("I am coming from the iot device $data");
//      databaseHelper.InsertDatareading(Datareading.fromJson(data));
        double m = double.parse(data["moisture"].toString());
        _isLoading = true;
        _moist = m;
        moistpoints.clear();
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
            'Moisture Graph',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
//        elevation: 0.5,
        ),
        body: ListView(children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          _createListTile(
            "Moisture",
            _moist.toString(),
            "%",
          ),
          SizedBox(
            height: 5.0,
          ),
          SubscriberChart(
            data: moistpoints,
          )
        ]),
        drawer: Drawer(
          child: drawer,
        ));
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
              child: Text(
                initials,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: !_isLoading
                ? Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48.0,
                  color: Colors.black),
            )
                : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                )),
          ),
        ),
      ),
    );
  }
  void dispose() {
    super.dispose();
  }
}
