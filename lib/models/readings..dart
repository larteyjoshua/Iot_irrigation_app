//creating database class
class Datareading {
  int id;
  DateTime time;
  double temperature;
  double waterused;
  double ph;
  double moisture;
  Datareading({this.id, this.time, this.temperature, this.waterused, this.ph, this.moisture}); // creating database constructors

  //mapping data
  Datareading.fromJson(Map<String, dynamic> map) :
        temperature = double.tryParse("${map['temperature']}"),
        waterused = double.tryParse("${map['waterused']}"),
        ph =double.tryParse("${map['ph']}"),
        moisture =double.tryParse("${map['moisture']}");

  Map<String, dynamic> toJson()=> {
    'temperature':temperature,
    'waterused': waterused,
    'ph': ph,
    'moisture':moisture,
  };
}