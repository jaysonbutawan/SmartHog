import 'farm_summary.dart';

class FarmSummaryResponse {
  final bool success;
  final List<FarmSummary> data;

  FarmSummaryResponse({
    required this.success,
    required this.data,
  });

  factory FarmSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return FarmSummaryResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map(
            (item) => FarmSummary.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}