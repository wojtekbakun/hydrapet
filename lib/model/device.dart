class Device {
  final int deviceId;
  final int ownerId;
  final String name;
  final DateTime createdAt;

  Device({
    required this.deviceId,
    required this.ownerId,
    required this.name,
    required this.createdAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['device_id'],
      ownerId: json['owner_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
