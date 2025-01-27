import 'package:hydrapet/model/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScheduleRepository {
  // Zapis harmonogramu do lokalnego magazynu
  Future<void> saveScheduleToLocalStorage(ScheduleModel schedule) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(schedule.toJson());
    await prefs.setString('scheduleModel', jsonString);
  }

  // Odczyt harmonogramu z lokalnego magazynu
  Future<ScheduleModel?> loadScheduleModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('scheduleModel');

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ScheduleModel.fromJson(jsonMap);
    }
    return null;
  }

  // Zapis tokenu JWT
  Future<void> saveJwtToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
  }

  // Pobranie tokenu JWT
  Future<String?> loadJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  // Usunięcie tokenu JWT
  Future<void> removeJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }
}
