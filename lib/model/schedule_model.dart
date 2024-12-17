import 'package:hydrapet/model/mini_schedule_model.dart';

class ScheduleModel {
  DateTime? date;
  List<MiniScheduleModel> miniSchedule;

  ScheduleModel({
    this.date,
    List<MiniScheduleModel>? miniSchedule,
  }) : miniSchedule = miniSchedule ?? [];

  // Konwersja ScheduleModel do JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(), // Konwersja DateTime na String
      'miniSchedule': miniSchedule.map((ms) => ms.toJson()).toList(),
    };
  }

  // Tworzenie ScheduleModel z JSON
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      miniSchedule: (json['miniSchedule'] as List<dynamic>?)
          ?.map((item) => MiniScheduleModel.fromJson(item))
          .toList(),
    );
  }
}
