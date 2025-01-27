import 'package:flutter/material.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ScheduleViewModel extends ChangeNotifier {
  MqttServerClient? mqttClient;

  final List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => _schedules;

  DateTime? _pickedDate = DateTime.now();
  DateTime? get pickedDate => _pickedDate;

  int _defaultWaterAmount = 200;
  int get defaultWaterAmount => _defaultWaterAmount;

  int _maxWaterAmount = 1000;
  int get maxWaterAmount => _maxWaterAmount;

  int _oneTimeWaterAmount = 50;
  int get oneTimeWaterAmount => _oneTimeWaterAmount;

  int _currentWaterAmount = 0;
  int get currentWaterAmount => _currentWaterAmount;

  int _batteryLevel = 0;
  int get batteryLevel => _batteryLevel;

  ScheduleRepository repository;
  ScheduleViewModel({required this.repository}) {
    initScheduleViewModel();
    connectAndListenToMqtt();
  }

  final ScheduleModel _defaultSchedule = ScheduleModel(
    isDefault: true,
    date: null,
    miniSchedule: [
      MiniScheduleModel(
        time: const TimeOfDay(hour: 8, minute: 0),
        waterAmount: 200,
      ),
      MiniScheduleModel(
        time: const TimeOfDay(hour: 12, minute: 0),
        waterAmount: 200,
      ),
      MiniScheduleModel(
        time: const TimeOfDay(hour: 16, minute: 0),
        waterAmount: 200,
      ),
      MiniScheduleModel(
        time: const TimeOfDay(hour: 20, minute: 0),
        waterAmount: 200,
      ),
    ],
  );

  ScheduleModel get defaultSchedule => _defaultSchedule;

  void initScheduleViewModel() {
    _schedules.add(_defaultSchedule);
  }

  void setBatteryLevel(int newBatteryLevel) {
    _batteryLevel = newBatteryLevel;
    notifyListeners();
  }

  int getBatteryLevel() {
    return _batteryLevel;
  }

  void setCurrentWaterAmount(int newWaterAmount) {
    _currentWaterAmount = newWaterAmount;
    notifyListeners();
  }

  int getCurrentWaterAmount() {
    return _currentWaterAmount;
  }

  double getWaterPercentage() {
    return _currentWaterAmount / maxWaterAmount * 100;
  }

  void setOneTimeWaterAmount(int newWaterAmount) {
    _oneTimeWaterAmount = newWaterAmount;
    notifyListeners();
  }

  int getOneTimeWaterAmount() {
    return _oneTimeWaterAmount;
  }

  void setDefaultWaterAmount(int newWaterAmount) {
    _defaultWaterAmount = newWaterAmount;
    notifyListeners();
  }

  void setMaxWaterAmount(int newMaxWaterAmount) {
    _maxWaterAmount = newMaxWaterAmount;
    notifyListeners();
  }

  int getTotalWaterAmount() {
    int totalWaterAmount = 0;
    getSchedule()?.miniSchedules.forEach((element) {
      totalWaterAmount += element.waterAmount.floor();
    });
    return totalWaterAmount;
  }

  void removeMiniSchedule(int index) {
    getSchedule()?.miniSchedules.removeAt(index);
    notifyListeners();
  }

  void setPickedDate(DateTime? date) {
    _pickedDate = date;
    debugPrint('Wybrana data: $date');
    notifyListeners();
  }

  int addNewSchedule(MiniScheduleModel newMiniSchedule) {
    if (getTotalWaterAmount() + newMiniSchedule.waterAmount > maxWaterAmount) {
      debugPrint('Przekroczono maksymalną ilość wody');
      return -1;
    }

    if (_schedules.isEmpty) {
      _schedules.add(ScheduleModel(date: _pickedDate, miniSchedule: []));
      addNewMiniSchedule(_schedules[0], newMiniSchedule);
      return 0;
    }
    for (var i = 0; i < _schedules.length;) {
      if (_schedules[i].date == _pickedDate) {
        debugPrint('Znaleziono datę: $_pickedDate, dodano nowy miniSchedule');
        addNewMiniSchedule(_schedules[i], newMiniSchedule);
        return 0;
      } else {
        i++;
        if (i == schedules.length) {
          debugPrint('Nie znaleziono daty: $_pickedDate, dodano nową');
          _schedules.add(ScheduleModel(
              date: _pickedDate, miniSchedule: [newMiniSchedule]));
          addNewMiniSchedule(_schedules[i], newMiniSchedule);
          return 0;
        }
      }
    }
    debugPrint("time in vm: $_pickedDate, schedule: ${schedules.length}");
    return 0;
  }

  ScheduleModel? getSchedule() {
    if (_pickedDate == null) {
      return _defaultSchedule;
    }
    for (var i = 0; i < _schedules.length; i++) {
      if (_schedules[i].date == _pickedDate) {
        debugPrint('Znaleziono date: ${_schedules[i].date}');
        debugPrint('Znaleziono miniSchedule: ${_schedules[i].miniSchedules}');
        debugPrint('Łączna ilość wody: ${_schedules[i].totalWaterAmount}');
        return _schedules[i];
      } else {
        _schedules.add(ScheduleModel(date: _pickedDate, miniSchedule: []));
        debugPrint('Dodano date: ${_schedules[i].date}');
      }
    }
    debugPrint('Nie znaleziono schedule dla daty: $_pickedDate');
    return null;
  }

  List<MiniScheduleModel> getMiniSchedules() {
    if (getSchedule() != null) {
      return getSchedule()!.miniSchedules;
    } else {
      return [];
    }
  }

  int editMiniSchedule(int index, MiniScheduleModel newMiniSchedule) {
    if (getTotalWaterAmount() -
            getSchedule()!.miniSchedules[index].waterAmount +
            newMiniSchedule.waterAmount >
        maxWaterAmount) {
      debugPrint('Przekroczono maksymalną ilość wody');
      return -1;
    }
    getSchedule()?.miniSchedules[index] = newMiniSchedule;

    notifyListeners();
    return 0;
  }

  int doOneTimeWatering() {
    if (getTotalWaterAmount() + oneTimeWaterAmount > maxWaterAmount) {
      debugPrint('Przekroczono maksymalną ilość wody');
      return -1;
    }
    addNewMiniSchedule(
        getSchedule()!,
        MiniScheduleModel(
          time: TimeOfDay.now(),
          waterAmount: _oneTimeWaterAmount,
        ));
    return 0;
  }

  void addNewMiniSchedule(
      ScheduleModel schedule, MiniScheduleModel newMiniSchedule) {
    schedule.miniSchedules.add(newMiniSchedule);
    notifyListeners();
  }

  String getHoursAndMinutesOfMiniSchedules() {
    _pickedDate = null;
    String hoursAndMinutes = '';
    getMiniSchedules().forEach((element) {
      // display hours and minutes in format: 'hh:mm ' with 0 in front of single digit numbers
      hoursAndMinutes +=
          '${element.time.hour.toString().padLeft(2, '0')}:${element.time.minute.toString().padLeft(2, '0')} ';
    });
    return hoursAndMinutes;
  }

  Future<void> connectAndListenToMqtt() async {
    // Adres i port brokera – dostosuj do swojego środowiska,
    // np. HiveMQ Cloud: adres, port 8883 (TLS) itp.
    final mqttClient = MqttServerClient.withPort(
      '8760b9bf0e454252820e44deb9a27fd0.s1.eu.hivemq.cloud',
      'flutter_client',
      8883,
    );

    // Włączamy szyfrowanie TLS
    mqttClient.secure = true;
    mqttClient.securityContext = SecurityContext.defaultContext;
    mqttClient.logging(on: true);
    mqttClient.keepAlivePeriod = 20;
    mqttClient.setProtocolV311();

    // Ustaw dane logowania (jeśli broker wymaga):
    // Konfiguracja wiadomości łączącej (z uwierzytelnieniem)
    final connMessage = MqttConnectMessage()
        .authenticateAs(
            'moj_uzytkownik', 'moj_uzytkownik1A') // Uzupełnij danymi
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillTopic('will_topic')
        .withWillMessage('Klient rozłączony')
        .withWillQos(MqttQos.atLeastOnce);
    mqttClient.connectionMessage = connMessage;

    // Obsługa rozłączenia:
    mqttClient.onDisconnected = () {
      debugPrint('[MQTT] Rozłączono');
    };

    try {
      debugPrint('[MQTT] Łączenie...');
      await mqttClient.connect();
      debugPrint('[MQTT] Połączono!');
    } catch (e) {
      debugPrint('[MQTT] Błąd połączenia: $e');
      mqttClient.disconnect();
      return;
    }

    // Subskrypcja tematu "water"
    const waterTopic = 'water';
    mqttClient.subscribe(waterTopic, MqttQos.atMostOnce);

    const batteryTopic = 'battery';
    mqttClient.subscribe(batteryTopic, MqttQos.atMostOnce);

    // Nasłuchiwanie wiadomości
    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMessage = c?[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMessage.payload.message,
      );

      debugPrint('[MQTT] Otrzymano: $payload z tematu: ${c?[0].topic}');

      // Spróbuj zrzutować payload na liczbę wody i zapisać w Schedule
      if (c?[0].topic == batteryTopic) {
        final parsedBattery = int.tryParse(payload);
        if (parsedBattery != null) {
          // Dodaj nowy wpis do bieżącego harmonogramu (lub jak wolisz przechowywać)
          setBatteryLevel(parsedBattery);
          notifyListeners();
        } else {
          debugPrint('[MQTT] Nie udało się przetworzyć liczby wody.');
        }
      }
      final parsedWater = int.tryParse(payload);
      if (parsedWater != null) {
        // Dodaj nowy wpis do bieżącego harmonogramu (lub jak wolisz przechowywać)
        setCurrentWaterAmount(parsedWater);
        notifyListeners();
      } else {
        debugPrint('[MQTT] Nie udało się przetworzyć liczby wody.');
      }
    });
  }
}
