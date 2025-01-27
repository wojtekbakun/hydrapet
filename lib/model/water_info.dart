class WaterInfo {
  final int weight;
  final DateTime updatedAt;

  WaterInfo({required this.weight, required this.updatedAt});

  factory WaterInfo.fromJson(Map<String, dynamic> json) {
    return WaterInfo(
      weight: json['weight'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
