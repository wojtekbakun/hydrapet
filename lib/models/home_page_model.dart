import 'package:flutter/material.dart';
import 'package:hydrapet/data/data_models/schedule_model.dart';
import 'package:hydrapet/data/repository/schedule_model_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class HomePageModel {
//   Future<void> updateWaterAmount(double value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('waterAmount', value);

//     debugPrint('[model] Water amount saved: $value');
//   }

//   Future<double> getWaterAmount() async {
//     final prefs = await SharedPreferences.getInstance();

//     return prefs.getDouble('waterAmount') ?? 100;
//   }

//   Future<void> saveSchedule(ScheduleModel schedule) async {
//     //ScheduleRepository().saveScheduleToLocalStorage();
//     debugPrint("Passed schedule to repo.");
//   }
// }
