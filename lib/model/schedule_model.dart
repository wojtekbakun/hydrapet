import 'package:hydrapet/model/mini_schedule_model.dart';

class ScheduleModel {
  DateTime? date;
  int totalWaterAmount;
  List<MiniScheduleModel> miniSchedules;

  ScheduleModel({
    this.date,
    this.totalWaterAmount = 0,
    List<MiniScheduleModel>? miniSchedule,
  }) : miniSchedules = miniSchedule ?? [];

  // Konwersja ScheduleModel do JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(), // Konwersja DateTime na String
      'totalWaterAmount': totalWaterAmount,
      'miniSchedule': miniSchedules.map((ms) => ms.toJson()).toList(),
    };
  }

  // Tworzenie ScheduleModel z JSON
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      totalWaterAmount: json['totalWaterAmount'],
      miniSchedule: (json['miniSchedule'] as List<dynamic>?)
          ?.map((item) => MiniScheduleModel.fromJson(item))
          .toList(),
    );
  }
}
