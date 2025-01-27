class DeviceTime {
  final DateTime currentTime;

  DeviceTime({required this.currentTime});

  factory DeviceTime.fromJson(Map<String, dynamic> json) {
    return DeviceTime(
      currentTime: DateTime.parse(json['current_time']),
    );
  }
}
