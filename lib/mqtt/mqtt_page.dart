/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

import 'dart:async';
import 'dart:io';
import 'package:IoT_Agric_App/models/readings..dart';
import 'package:IoT_Agric_App/utils/database_helper.dart';
import 'package:mqtt_client/mqtt_client.dart';
import'dart:convert';

//creating mqtt class
class Mqttwrapper {

  StreamController<Map<String, dynamic>> mqttController = StreamController
      .broadcast();
  static final Mqttwrapper instance = Mqttwrapper._internal();

  factory Mqttwrapper () => instance;

  Mqttwrapper._internal();

  var value = 'Hello MQTT';

  DatabaseHelper databaseHelper = DatabaseHelper();

  /// An annotated simple subscribe/publish usage example for mqtt_client. Please read in with reference
  /// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
  /// files for separate subscribe/publish tests.
  MqttClient client;
  String clientIdentifier = 'android';

  Future<MqttClient> initializemqtt() async {
    final MqttClient client = MqttClient("mqtt.dioty.co", "");
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 30;
    client.onConnected = _onConnect;
    client.onDisconnected = _onDisconnect;
    client.onSubscribed = onSubscribed;
    final MqttConnectMessage connMess = new MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .keepAliveFor(60);
    print("EXAMPLE::MQTT client connecting....");
    client.connectionMessage = connMess;
    try {
      await client.connect("larteyjoshua@gmail.com", "7f8a9110");
    } catch (e) {
      print("EXAMPLE::client exception - $e");
      client.disconnect();
      return client;
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print("EXAMPLE::MQTT client connected");
      /// Ok, lets try a subscription
      final String topic = "/larteyjoshua@gmail.com/test"; // Not a wildcard topic
      client.subscribe(topic, MqttQos.atMostOnce);
      final String topictwo = "/larteyjoshua@gmail.com/SensorData"; // Not a wildcard topic
      client.subscribe(topictwo, MqttQos.atMostOnce);

      /// The client has a change notifier object(see the Observable class) which we then listen to to get
      /// notifications of published updates to each subscribed topic.
      client.updates.listen((List<MqttReceivedMessage> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print(
            "EXAMPLE::Change notification:: topic is <${c[0]
                .topic}>, payload is <-- $pt -->");
        print("");
        final String topicSensor = "/larteyjoshua@gmail.com/SensorData";
        if (("${c[0].topic}") == (topicSensor)) {
          final datasensor = json.decode(pt);
          mqttController.add(datasensor);
          print(datasensor['temperature']);
          databaseHelper.InsertDatareading(Datareading.fromJson(datasensor));
        }
      });
    } else {
      print(
          "EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client
              .connectionStatus.state}");
      client.disconnect();
      exit(-1);
    }
    return client;
  }

  Future<bool> _connectToClient() async {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
    } else {
      client = await initializemqtt();
      if (client == null) {
        return false;
      }
    }
    return true;
  }
    Future<void> publish(String value) async {
      if (await _connectToClient() == true) {
        print("EXAMPLE::Publishing our topic");
        final String pubTopic = "/larteyjoshua@gmail.com/test";
        final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
        builder.addString(value);
        client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload);
        client.subscribe(pubTopic, MqttQos.atMostOnce);
      }
    }
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print("EXAMPLE::Subscription confirmed for topic $topic");
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print("EXAMPLE::OnDisconnected client callback - Client disconnection");
    exit(-1);
  }

  _onConnect() {
    print("mqtt connected");
  }

  _onDisconnect() {
    print("mqtt disconnected");
  }

@override
void dispose(){
  Mqttwrapper().mqttController.close();
}


