class FarmSummary {
  final int id;
  final int userId;
  final String location;
  final String timezone;

  FarmSummary({
    required this.id,
    required this.userId,
    required this.location,
    required this.timezone,
  });

  factory FarmSummary.fromJson(Map<String, dynamic> json) {
    return FarmSummary(
      id: json['id'],
      userId: json['user_id'],
      location: json['location'] ?? '',
      timezone: json['timezone'] ?? '',
    );
  }
}