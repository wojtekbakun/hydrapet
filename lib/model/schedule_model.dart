import 'package:flutter/material.dart';

class ScheduleModel {
  TimeOfDay? morningTime = const TimeOfDay(hour: 8, minute: 00);
  TimeOfDay? afternoonTime = const TimeOfDay(hour: 12, minute: 00);
  TimeOfDay? eveningTime = const TimeOfDay(hour: 16, minute: 00);
  double? waterAmount = 100;

  ScheduleModel({
    this.morningTime,
    this.afternoonTime,
    this.eveningTime,
    this.waterAmount,
  });
}

enum PartOfTheDay {
  morning,
  afternoon,
  evening,
}
