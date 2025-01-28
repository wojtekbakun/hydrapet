import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hydrapet/model/schedule.dart';

class ScheduleRepository {
  final String baseUrl;

  ScheduleRepository(this.baseUrl);

  Future<void> addSchedule(
      String token, int deviceId, String day, String time, int amount) async {
    final url = Uri.parse('$baseUrl/schedule');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'deviceId': deviceId,
        'day': day,
        'time': time,
        'amount': amount,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add schedule');
    }
  }

  Future<List<Schedule>> getSchedules(String token, int deviceId) async {
    final url = Uri.parse('$baseUrl/schedule/$deviceId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Schedule.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch schedules');
    }
  }

  Future<void> deleteSchedule(String token, int scheduleId) async {
    final url = Uri.parse('$baseUrl/schedule/$scheduleId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete schedule');
    }
  }

  Future<void> sendScheduleToDevice(String token, int deviceId) async {
    final url = Uri.parse('$baseUrl/schedule/$deviceId/send-schedule');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send schedule to device');
    }
  }
}
