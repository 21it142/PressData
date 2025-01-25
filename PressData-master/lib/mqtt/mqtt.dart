import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class MqttService {
  MqttServerClient? client;
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  final StreamController<String> _messageController_para1 =
      StreamController<String>.broadcast();
  String topic1Payload = '';
  String topic2Payload = '';
  Stream<String> get messageStream => _messageController.stream;
  Stream<String> get messageStream_para1 => _messageController_para1.stream;

  Future<bool> connect(BuildContext context) async {
    client = await _connect();
    if (client != null &&
        client!.connectionStatus?.state == MqttConnectionState.connected) {
      print('Connected to MQTT');
      subscribeToTopic1("PDA10240105", context);
      return true;
    } else {
      print('Failed to connect to MQTT');
      return false;
    }
  }

  Future<MqttServerClient> _connect() async {
    MqttServerClient mqttClient = MqttServerClient.withPort(
      'jmq.jcntechnology.in',
      'flutter_client1',
      8883,
    );

    mqttClient.logging(on: true);
    mqttClient.onConnected = () {
      print('Connected');
    };
    mqttClient.onDisconnected = () {
      print('Disconnected');
    };

    // Load certificates for TLS connection
    SecurityContext context = SecurityContext();
    List<int> caBytes = await loadBytes('assets/JCNTECHNOLOGY-CA.pem');
    List<int> clientCertBytes = await loadBytes('assets/jw.crt');
    List<int> clientKeyBytes = await loadBytes('assets/jw.key');

    context.setTrustedCertificatesBytes(caBytes);
    context.useCertificateChainBytes(clientCertBytes);
    context.usePrivateKeyBytes(clientKeyBytes);

    mqttClient.secure = true;
    mqttClient.securityContext = context;
    mqttClient.onBadCertificate = (Object cert) {
      return true;
    };

    final connMess = MqttConnectMessage()
        .withClientIdentifier("flutter_client")
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    mqttClient.connectionMessage = connMess;

    try {
      await mqttClient.connect();
    } catch (e) {
      print('Exception: $e');
      mqttClient.disconnect();
    }

    return mqttClient;
  }

  void subscribeToTopic1(String serialNo, BuildContext context) {
    String topic1 = '$serialNo/t_jw_dou_1s';

    if (client == null ||
        client?.connectionStatus?.state != MqttConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Not connected to MQTT broker.'),
          backgroundColor: Colors.red,
        ),
      );
      print("Not connected to MQTT broker.");
      return;
    }

    client?.subscribe(topic1, MqttQos.atLeastOnce);

    client?.onSubscribeFail = (String topic) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to subscribe to the topic: $topic'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to subscribe to the topic: $topic");
    };

    print("Subscribed to topic: $topic1");

    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      if (c[0].topic == topic1) {
        print('Received message for topic 1: $payload');

        if (_isValidPayload(payload)) {
          topic1Payload = payload;
          _messageController.add(payload);
          print('Updated topic1Payload: $topic1Payload');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Invalid or wrong serial number.'),
              backgroundColor: Colors.red,
            ),
          );
          print('Serial number is wrong or invalid.');
        }
      }
    });
  }

  void subscribeTotoppic2(String serialNo, BuildContext context) {
    String topic2 = '$serialNo/t_jw_dou_para_1';

    if (client == null ||
        client?.connectionStatus?.state != MqttConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Not connected to MQTT broker.'),
          backgroundColor: Colors.red,
        ),
      );
      print("Not connected to MQTT broker.");
      return;
    }

    client?.subscribe(topic2, MqttQos.atLeastOnce);

    client?.onSubscribeFail = (String topic) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to subscribe to the topic: $topic'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to subscribe to the topic: $topic");
    };

    print("Subscribed to topic: $topic2");

    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      if (c[0].topic == topic2) {
        print('Received message for topic 2: $payload');

        if (_isValidPayload(payload)) {
          topic2Payload = payload;
          _messageController_para1.add(payload);
          print('Updated topic2 Payload: $topic2Payload');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Invalid or wrong serial number.'),
              backgroundColor: Colors.red,
            ),
          );
          print('Serial number is wrong or invalid.');
        }
      }
    });
  }

  bool _isValidPayload(String payload) {
    return payload.isNotEmpty &&
        !payload.contains('error') &&
        payload != 'INVALID_SERIAL';
  }

  Future<List<int>> loadBytes(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  void dispose() {
    _messageController.close();
    _messageController_para1.close();
  }
}
