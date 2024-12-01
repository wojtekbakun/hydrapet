import 'package:flutter/material.dart';
import 'package:hydrapet/data/data_models/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleRepository {
  Future<void> saveScheduleToLocalStorage(ScheduleModel schedule) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('water_amount', schedule.waterAmount ?? 100);
    prefs.setString('morningTime', schedule.morningTime.toString());
    prefs.setString('afternoonTime', schedule.morningTime.toString());
    prefs.setString('eveningTime', schedule.morningTime.toString());
    debugPrint(
        "Repo zapisało dane: \n--- water:${schedule.waterAmount}, \n--- morning: ${schedule.morningTime}");
  }

  Future<ScheduleModel> getScheduleFromLocalStorage() async {
    ScheduleModel schedule = ScheduleModel();
    final prefs = await SharedPreferences.getInstance();
    schedule.waterAmount = prefs.getDouble('water_amount');
    schedule.morningTime =
        fromStringToTimeOfDay(prefs.getString('morningTime') ?? '');
    schedule.afternoonTime =
        fromStringToTimeOfDay(prefs.getString('afternoonTime') ?? '');
    schedule.eveningTime =
        fromStringToTimeOfDay(prefs.getString('eveningTime') ?? '');

    debugPrint(
        'Odczytano czasy z pamieci: ${schedule.morningTime} ${schedule.afternoonTime} ${schedule.eveningTime} ${schedule.waterAmount}');
    return schedule;
  }

  TimeOfDay fromStringToTimeOfDay(String timeString) {
    final RegExp regExp = RegExp(r"TimeOfDay\((\d+):(\d+)\)");
    final match = regExp.firstMatch(timeString);

    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      return TimeOfDay(hour: hour, minute: minute);
    } else {
      throw const FormatException("Invalid TimeOfDay format");
    }
  }

  void changeWaterAmount(ScheduleModel schedule, double newWaterAmount) {
    schedule.waterAmount = newWaterAmount;
    debugPrint("Zmieniono ilość wody na ${schedule.waterAmount}");
  }

  void changeMorningTime(ScheduleModel schedule, TimeOfDay newTime) {
    schedule.morningTime = newTime;
    debugPrint('Zmieniono czas na: ${schedule.morningTime}');
  }

  void changeAfternoonTime(ScheduleModel schedule, TimeOfDay newTime) {
    schedule.afternoonTime = newTime;
    debugPrint('Zmieniono czas na: ${schedule.afternoonTime}');
  }

  void changeEveningTime(ScheduleModel schedule, TimeOfDay newTime) {
    schedule.eveningTime = newTime;
    debugPrint('Zmieniono czas na: ${schedule.eveningTime}');
  }
}
