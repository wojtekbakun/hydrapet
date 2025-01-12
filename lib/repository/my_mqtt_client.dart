import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<void> connectToBroker() async {
  // Tworzymy klienta z podanym adresem i portem (8883 jest portem TLS)
  final client = MqttServerClient.withPort(
    '8760b9bf0e454252820e44deb9a27fd0.s1.eu.hivemq.cloud',
    'flutter_client',
    8883,
  );

  // Włączamy szyfrowanie TLS
  client.secure = true;
  client.securityContext = SecurityContext.defaultContext;

  // Ustawienia MQTT
  client.logging(on: true);
  client.keepAlivePeriod = 20;
  client.setProtocolV311();

  // Funkcja wywoływana przy rozłączeniu
  client.onDisconnected = () {
    print('Rozłączono z brokerem HiveMQ');
  };

  // Konfiguracja wiadomości łączącej (z uwierzytelnieniem)
  final connMessage = MqttConnectMessage()
      .authenticateAs('moj_uzytkownik', 'moj_uzytkownik1A') // Uzupełnij danymi
      .withClientIdentifier('flutter_client')
      .startClean()
      .withWillTopic('will_topic')
      .withWillMessage('Klient rozłączony')
      .withWillQos(MqttQos.atLeastOnce);

  client.connectionMessage = connMessage;

  try {
    print('Łączenie do HiveMQ...');
    await client.connect();
    print('Połączono!');
  } catch (e) {
    print('Błąd połączenia: $e');
    client.disconnect();
    return;
  }

  // Subskrypcja przykładowego tematu
  const topic = 'woda';
  client.subscribe(topic, MqttQos.atMostOnce);

  // Odbiór wiadomości
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
