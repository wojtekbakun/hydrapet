import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hydrapet/model/device.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/model/schedule.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/model/water_info.dart';
import 'package:hydrapet/repository/device_repository.dart';
import 'package:hydrapet/repository/auth_repository.dart';
import 'package:hydrapet/repository/schedule_repository.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;

class ScheduleViewModel extends ChangeNotifier {
  final String apiUrl = 'http://0.0.0.0:3000'; // Adres API
  MqttServerClient? mqttClient;
  String? _jwtToken;
  String? get jwtToken => _jwtToken;
  WaterInfo? _currentWaterInfo;

  final DeviceRepository deviceRepository;
  String? _selectedDeviceId = '5';
  List<Device> _devices = [];
  String? get selectedDeviceId => _selectedDeviceId;
  List<Device> get devices => _devices;

  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

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

  AuthRepository authRepository;
  final ScheduleRepository repository;

  ScheduleViewModel(
      {required this.authRepository,
      required this.repository,
      required this.deviceRepository}) {
    initScheduleViewModel();
  }

  Future<void> initScheduleViewModel() async {
    _jwtToken = await authRepository.loadJwtToken();
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

  Future<void> saveJwtToken(String token) async {
    _jwtToken = token;
    await authRepository.saveJwtToken(token);
    notifyListeners();
  }

  Future<void> removeJwtToken() async {
    _jwtToken = null;
    await authRepository.removeJwtToken();
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

  Future<void> fetchWaterInfo() async {
    if (_jwtToken == null || _selectedDeviceId == null) {
      throw Exception('Token or selected device ID is not available');
    }

    try {
      _currentWaterInfo = await deviceRepository.getWaterInfo(
        _jwtToken!,
        int.parse(_selectedDeviceId!),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to fetch water info: $e');
      throw e;
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

  Future<void> fetchSchedules() async {
    if (_jwtToken == null || _selectedDeviceId == null) {
      throw Exception('Token or Device ID is not set');
    }

    try {
      _schedules = await repository.getSchedules(
          _jwtToken!, int.parse(_selectedDeviceId!));
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to fetch schedules: $e');
      rethrow;
    }
  }

  Future<void> addSchedule(String day, String time, int amount) async {
    if (_jwtToken == null || _selectedDeviceId == null) {
      throw Exception('Token or Device ID is not set');
    }

    try {
      await repository.addSchedule(
          _jwtToken!, int.parse(_selectedDeviceId!), day, time, amount);
      await fetchSchedules(); // Odśwież listę harmonogramów
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to add schedule: $e');
      throw e;
    }
  }

  Future<void> deleteSchedule(int scheduleId) async {
    if (_jwtToken == null) {
      throw Exception('Token is not set');
    }

    try {
      await repository.deleteSchedule(_jwtToken!, scheduleId);
      await fetchSchedules(); // Odśwież listę harmonogramów
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to delete schedule: $e');
      throw e;
    }
  }

  Future<void> sendScheduleToDevice() async {
    if (_jwtToken == null || _selectedDeviceId == null) {
      throw Exception('Token or Device ID is not set');
    }

    try {
      await repository.sendScheduleToDevice(
          _jwtToken!, int.parse(_selectedDeviceId!));
    } catch (e) {
      debugPrint('Failed to send schedule to device: $e');
      throw e;
    }
  }
}
