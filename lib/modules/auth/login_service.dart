import 'package:dio/dio.dart';
import 'package:smarthog/modules/auth/login_response.dart';

class LoginService {
  final Dio _dio;

  LoginService(this._dio);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: const {
            "Content-Type": "application/json",
          },
        ),
      );

      return LoginResponse.fromJson(
        Map<String, dynamic>.from(res.data),
      );

    } on DioException catch (e) {
      throw Exception(
        _readServerStatus(e) ??
        _readMessage(e) ??
        'Network/Server error',
      );
    }
  }

  String? _readServerStatus(DioException e) {
    return e.response?.statusMessage;
  }

  String? _readMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      return data['message']?.toString();
    }

    return e.message;
  }
}