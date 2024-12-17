import 'package:flutter/material.dart';

class MiniScheduleModel {
  TimeOfDay time;
  double waterAmount;

  MiniScheduleModel({
    required this.time,
    required this.waterAmount,
  });

  // Konwersja MiniScheduleModel do JSON
  Map<String, dynamic> toJson() {
    return {
      'time': '${time.hour}:${time.minute}', // Konwersja TimeOfDay na String
      'waterAmount': waterAmount,
    };
  }

  // Tworzenie MiniScheduleModel z JSON
  factory MiniScheduleModel.fromJson(Map<String, dynamic> json) {
    List<String> timeParts = (json['time'] as String).split(':');
    return MiniScheduleModel(
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      waterAmount: json['waterAmount'] as double,
    );
  }
}
