import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<void> connectToBroker() async {
  final client = MqttServerClient('broker.hivemq.com', '');
  client.logging(on: true);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;

  // Funkcja wywoływana przy rozłączeniu
  client.onDisconnected = () {
    print('Rozłączono z brokerem MQTT');
  };

  // Ustawienia połączenia
  final connMessage = MqttConnectMessage()
      .withClientIdentifier('flutter_client')
      .withWillTopic('willtopic')
      .withWillMessage('Klient się rozłączył')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMessage;

  try {
    print('Łączenie...');
    await client.connect();
    print('Połączono!');
  } catch (e) {
    print('Nie udało się połączyć: $e');
    client.disconnect();
  }

  // Subskrypcja na tematy
  const topic = 'test/topic';
  client.subscribe(topic, MqttQos.atMostOnce);

  // Odbieranie wiadomości
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMessage = c![0].payload as MqttPublishMessage;
    final payload =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
    print('Otrzymano wiadomość: $payload');
  });
}

void publishMessage(MqttServerClient client, String topic, String message) {
  final builder = MqttClientPayloadBuilder();
  builder.addString(message);
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
}
