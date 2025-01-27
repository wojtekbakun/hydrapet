class DeviceStatus {
  final int weight;
  final String buttonState;
  final String ledState;
  final String motorState;
  final DateTime updatedAt;

  DeviceStatus({
    required this.weight,
    required this.buttonState,
    required this.ledState,
    required this.motorState,
    required this.updatedAt,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      weight: json['weight'],
      buttonState: json['button_state'],
      ledState: json['led_state'],
      motorState: json['motor_state'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
