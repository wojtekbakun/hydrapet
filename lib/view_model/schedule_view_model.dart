import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hydrapet/model/device.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/repository/device_repository.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;

class ScheduleViewModel extends ChangeNotifier {
  final String apiUrl = 'http://0.0.0.0:3000'; // Adres API
  MqttServerClient? mqttClient;
  String? _jwtToken;
  String? get jwtToken => _jwtToken;

  final DeviceRepository deviceRepository;
  String? _selectedDeviceId;
  List<Device> _devices = [];
  String? get selectedDeviceId => _selectedDeviceId;
  List<Device> get devices => _devices;

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
  ScheduleViewModel(
      {required this.repository, required this.deviceRepository}) {
    initScheduleViewModel();
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

  Future<void> initScheduleViewModel() async {
    _jwtToken = await repository.loadJwtToken();
    _schedules.add(_defaultSchedule);
  }

  Future<void> saveJwtToken(String token) async {
    _jwtToken = token;
    await repository.saveJwtToken(token);
    notifyListeners();
  }

  Future<void> removeJwtToken() async {
    _jwtToken = null;
    await repository.removeJwtToken();
    notifyListeners();
  }

  Future<void> refreshToken() async {
    // Tutaj można zaimplementować mechanizm odświeżania tokenu, jeśli dostępny
    // Na przykład wysłanie żądania do serwera po nowy token
    debugPrint('Odświeżanie tokenu JWT...');
  }

  bool isAuthenticated() {
    debugPrint('Czy użytkownik jest zalogowany? $_jwtToken');
    return _jwtToken != null && _jwtToken!.isNotEmpty;
  }

  Future<void> performAuthenticatedAction(
      Future<void> Function(String token) action) async {
    if (_jwtToken == null) {
      throw Exception('Nie zalogowano użytkownika');
    }
    await action(_jwtToken!);
  }

  // Przykład użycia tokenu w metodzie ViewModel
  Future<void> exampleApiCall() async {
    if (!isAuthenticated()) {
      throw Exception('Brak autoryzacji');
    }

    // Wykonaj żądanie z wykorzystaniem tokenu
    debugPrint('Token JWT: $_jwtToken');
    // Dodaj tutaj logikę, np. wywołanie metody z repozytorium
  }

  // Metoda do pobierania harmonogramu z autoryzacją
  Future<void> fetchScheduleData() async {
    await performAuthenticatedAction((token) async {
      // Przykład wywołania z tokenem
      debugPrint('Pobieranie danych harmonogramu z tokenem: $token');
      // Wywołanie odpowiedniej metody z repozytorium
    });
  }

  // Inicjalizacja tokenu podczas tworzenia ViewModel
  Future<void> authenticate(String token) async {
    await saveJwtToken(token);
    debugPrint('Zapisano token JWT: $token');
  }

  // Wylogowanie użytkownika
  Future<void> logout() async {
    await removeJwtToken();
    debugPrint('Wylogowano użytkownika');
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

  bool _devicesLoaded = false;

  Future<void> fetchDevices() async {
    if (_devicesLoaded) return; // Unikaj wielokrotnego wywoływania
    _devicesLoaded = true;

    if (_jwtToken == null) {
      debugPrint('JWT token is null, cannot fetch devices');
      throw Exception('JWT token is not available');
    }

    try {
      debugPrint('Fetching devices...');
      _devices = await deviceRepository.getDevices(_jwtToken!);
      debugPrint('Devices fetched: $_devices');
      if (_devices.isNotEmpty && _selectedDeviceId == null) {
        _selectedDeviceId =
            '${_devices.first.deviceId}'; // Ustaw domyślne urządzenie
        debugPrint('Default device selected: $_selectedDeviceId');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching devices: $e');
      rethrow;
    }
  }

  Future<void> setDeviceWaterTarget(int targetWeight) async {
    if (_jwtToken == null || _selectedDeviceId == null) {
      throw Exception('Token or selected device ID is not available');
    }

    try {
      debugPrint('Sending request to set water target...');
      await deviceRepository.setDeviceWaterTarget(
        _jwtToken!,
        int.parse(_selectedDeviceId!),
        targetWeight,
      );
      _maxWaterAmount = targetWeight;
      notifyListeners();
      debugPrint('Water target set successfully');
    } catch (e) {
      debugPrint('Failed to set device water target: $e');
      throw e;
    }
  }

  void selectDevice(String deviceId) {
    _selectedDeviceId = deviceId;
    notifyListeners();
  }

  Future<String> resetTare(int deviceId) async {
    final url = Uri.parse('$apiUrl/devices/$deviceId/set-tare');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_jwtToken', // Zamień na właściwy token
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Reset tary nie powiódł się');
    }
  }

  Future<String> deleteAlarm(int deviceId, String timestamp) async {
    final url = Uri.parse('$apiUrl/devices/$deviceId/delete-alarm');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $_jwtToken', // Zamień na właściwy token
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Usuwanie alarmu nie powiodło się');
    }
  }

  Future<String> getDeviceTime(int deviceId) async {
    final url = Uri.parse('$apiUrl/devices/$deviceId/get-time');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_jwtToken', // Zamień na właściwy token
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Pobranie czasu urządzenia nie powiodło się');
    }
  }

  Future<String> setDeviceTime(int deviceId, String timestamp) async {
    final url = Uri.parse('$apiUrl/devices/$deviceId/set-time');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_jwtToken', // Zamień na właściwy token
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'timestamp': timestamp,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Ustawienie czasu urządzenia nie powiodło się');
    }
  }
}
