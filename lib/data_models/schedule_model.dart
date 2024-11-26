class ScheduleModel {
  String? time = '00:00';
  String? waterAmount = '100';

  ScheduleModel({
    this.time,
    this.waterAmount,
  });

  void updateSchedule(newTime, newWaterAmount) {
    time = newTime;
    waterAmount = newWaterAmount;
  }
}
