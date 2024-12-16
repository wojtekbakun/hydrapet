class ScheduleModel {
  List<DateTime>? wateringTimes;
  double? waterAmount;

  ScheduleModel({
    List<DateTime>? wateringTimes,
    this.waterAmount = 100,
  }) : wateringTimes = wateringTimes ?? [];

  // Konwersja do JSON
  Map<String, dynamic> toJson() {
    return {
      'wateringTimes':
          wateringTimes?.map((dateTime) => dateTime.toIso8601String()).toList(),
      'waterAmount': waterAmount,
    };
  }

  // Tworzenie obiektu z JSON
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      wateringTimes: (json['wateringTimes'] as List<dynamic>?)
          ?.map((timestamp) => DateTime.parse(timestamp))
          .toList(),
      waterAmount: json['waterAmount'] as double?,
    );
  }
}
