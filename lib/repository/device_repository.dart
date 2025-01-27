import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hydrapet/model/deleted_alarm.dart';
import 'package:hydrapet/model/device.dart';
import 'package:hydrapet/model/device_status.dart';
import 'package:hydrapet/model/device_time.dart';
import 'package:hydrapet/model/water_info.dart';

class DeviceRepository {
  final String baseUrl;

  DeviceRepository(this.baseUrl);

  Future<List<Device>> getDevices(String token) async {
    final url = Uri.parse('$baseUrl/devices');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Device.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<DeviceStatus> getDeviceStatus(String token, int deviceId) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/status');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DeviceStatus.fromJson(data);
    } else {
      throw Exception('Failed to load device status');
    }
  }

  Future<void> setDeviceTime(
      String token, int deviceId, DateTime timestamp) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/set-time');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'timestamp': timestamp.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set device time');
    }
  }

  Future<DeviceTime> getDeviceTime(String token, int deviceId) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/get-time');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DeviceTime.fromJson(data);
    } else {
      throw Exception('Failed to fetch device time');
    }
  }

  Future<void> setDeviceWaterTarget(
      String token, int deviceId, int targetWeight) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/set-water');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'target_weight': targetWeight,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set target water weight');
    }
  }

  Future<WaterInfo> getWaterInfo(String token, int deviceId) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/get-water');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WaterInfo.fromJson(data);
    } else {
      throw Exception('Failed to fetch water info');
    }
  }

  Future<DeletedAlarmResponse> deleteAlarm(
      String token, int deviceId, DateTime timestamp) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/delete-alarm');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'timestamp': timestamp.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DeletedAlarmResponse.fromJson(data);
    } else {
      throw Exception('Failed to delete alarm');
    }
  }

  Future<String> pourWater(String token, int deviceId, int targetWeight) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/pour-water');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'target_weight': targetWeight,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to send pour water request');
    }
  }

  Future<String> setTare(String token, int deviceId) async {
    final url = Uri.parse('$baseUrl/device/$deviceId/set-tare');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to send tare reset request');
    }
  }
}
