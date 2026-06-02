import 'package:dio/dio.dart';
import 'farm_summary_response.dart';

class FarmSummaryService {
  final Dio _dio;

  FarmSummaryService(this._dio);

  Future<FarmSummaryResponse> getFarms() async {
    try {
      final res = await _dio.get(
        'https://smarthogapiv2-lq3o.onrender.com/api/v1/farms-summary',
      );

      print('✅ Farms loaded successfully');
      print('📦 Raw response: ${res.data}');

      final response = FarmSummaryResponse.fromJson(
        Map<String, dynamic>.from(res.data),
      );

      print('🌾 Total farms loaded: ${response.data.length}');

      return response;
    } on DioException catch (e) {
      print('❌ Failed to load farms');

      print('--- FULL DEBUG ---');
      print('🔢 Status Code: ${e.response?.statusCode}');
      print('📦 Response Data: ${e.response?.data}');
      print('⚠️ Dio Type: ${e.type}');
      print('💬 Message: ${e.message}');
      print('🌐 Request URL: ${e.requestOptions.uri}');
      print('🔐 Headers: ${e.requestOptions.headers}');
      print('------------------');

      // IMPORTANT: more accurate error detection
      final message = _getErrorMessage(e);

      print('⚠️ Error details: $message');

      throw Exception(message);
    }
  }

  String _getErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'];
    }

    if (e.message != null) {
      return e.message!;
    }

    return 'Network/Server error';
  }
}
