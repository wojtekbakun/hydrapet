class DeletedAlarm {
  final int alarmId;
  final int deviceId;
  final DateTime timestamp;
  final int targetWeight;

  DeletedAlarm({
    required this.alarmId,
    required this.deviceId,
    required this.timestamp,
    required this.targetWeight,
  });

  factory DeletedAlarm.fromJson(Map<String, dynamic> json) {
    return DeletedAlarm(
      alarmId: json['alarm_id'],
      deviceId: json['device_id'],
      timestamp: DateTime.parse(json['timestamp']),
      targetWeight: json['target_weight'],
    );
  }
}

class DeletedAlarmResponse {
  final String message;
  final DeletedAlarm deletedAlarm;

  DeletedAlarmResponse({
    required this.message,
    required this.deletedAlarm,
  });

  factory DeletedAlarmResponse.fromJson(Map<String, dynamic> json) {
    return DeletedAlarmResponse(
      message: json['message'],
      deletedAlarm: DeletedAlarm.fromJson(json['deletedAlarm']),
    );
  }
}
