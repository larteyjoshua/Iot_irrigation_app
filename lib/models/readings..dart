//creating database class
class Datareading {
  int id;
  DateTime time;
  double temperature;
  double water_used;
  double ph;
  double moisture;
  Datareading({this.id, this.time, this.temperature, this.water_used, this.ph, this.moisture}); // creating database constructors

  //mapping data
  Datareading.fromJson(Map<String, dynamic> map) :
        temperature = double.tryParse("${map['temperature']}"),
        water_used = double.tryParse("${map['water_used']}"),
        ph =double.tryParse("${map['ph']}"),
        moisture =double.tryParse("${map['moisture']}");

  Map<String, dynamic> toJson()=> {
    'temperature':temperature,
    'water_used': water_used,
    'ph': ph,
    'moisture':moisture,
  };
}