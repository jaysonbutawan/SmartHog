import 'user.dart';

class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: LoginData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}

class LoginData {
  final String accessToken;
  final String token;
  final String tokenType;
  final User user;

  LoginData({
    required this.accessToken,
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'] as String,
      token: json['token'] as String,
      tokenType: json['token_type'] as String,
      user: User.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }
}