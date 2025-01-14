import 'package:hydrapet/model/mqtt_server_client.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:hydrapet/repository/my_mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ScheduleRepository {
  Future<void> saveScheduleToLocalStorage(ScheduleModel schedule) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(schedule.toJson());
    await prefs.setString('scheduleModel', jsonString);
  }

  Future<ScheduleModel?> loadScheduleModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('scheduleModel');

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ScheduleModel.fromJson(jsonMap);
    }
    return null;
  }
}
