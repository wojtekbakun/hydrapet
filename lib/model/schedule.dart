class Schedule {
  final int scheduleId;
  final int deviceId;
  final String day; // Format 'YYYY-MM-DD'
  final String time; // Format 'HH:mm:ss'
  final int amount;

  Schedule({
    required this.scheduleId,
    required this.deviceId,
    required this.day,
    required this.time,
    required this.amount,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['schedule_id'],
      deviceId: json['device_id'],
      day: json['day'] ?? "2025-01-28",
      time: json['time'],
      amount: json['amount_ml'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'day': day,
      'time': time,
      'amount': amount,
    };
  }
}
