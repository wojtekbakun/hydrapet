import 'package:flutter/material.dart';
import 'package:hydrapet/model/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  void changeWaterAmount(ScheduleModel schedule, double newWaterAmount) {
    schedule.waterAmount = newWaterAmount;
    debugPrint("Zmieniono ilość wody na ${schedule.waterAmount}");
  }

  void addNewWateringTime(ScheduleModel schedule, DateTime newTime) {
    schedule.wateringTimes?.add(newTime);
    debugPrint(
        'Dodano nowy czas: ${schedule.wateringTimes} -> $newTime, a ilosc wody to :${schedule.waterAmount}');
  }

  // void changeTime(
  //     ScheduleModel schedule, PartOfTheDay partOfTheDay, TimeOfDay newTime) {
  //   switch (partOfTheDay) {
  //     case PartOfTheDay.morning:
  //       changeMorningTime(schedule, newTime);
  //       break;
  //     case PartOfTheDay.afternoon:
  //       changeAfternoonTime(schedule, newTime);
  //       break;
  //     case PartOfTheDay.evening:
  //       changeEveningTime(schedule, newTime);
  //       break;
  //   }
  // }
}
