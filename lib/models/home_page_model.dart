import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageModel {
  Future<void> saveWaterAmount(double value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('waterAmount', value);

    debugPrint('Water amount saved: $value');
  }

  Future<double> getWaterAmount() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble('waterAmount') ?? 100;
  }
}
