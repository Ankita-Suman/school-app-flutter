import 'dart:convert';

class ForgotPasswordResponse {
  final bool status;
  final String message;
  final OTPData? data;

  ForgotPasswordResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OTPData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class OTPData {
  final String? otp;
  final String? email;
  final String? login;
  final String? branchCode;
  final int? expiresInMinutes;

  OTPData({
    this.otp,
    this.email,
    this.login,
    this.branchCode,
    this.expiresInMinutes,
  });

  factory OTPData.fromJson(Map<String, dynamic> json) {
    return OTPData(
      otp: json['otp']?.toString(),
      email: json['email']?.toString(),
      login: json['login']?.toString(),
      branchCode: json['branch_code']?.toString(),
      expiresInMinutes: json['expires_in_minutes'] is int
          ? json['expires_in_minutes']
          : int.tryParse(json['expires_in_minutes']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'otp': otp,
    'email': email,
    'login': login,
    'branch_code': branchCode,
    'expires_in_minutes': expiresInMinutes,
  };
}
ForgotPasswordResponse forgotPasswordResponseFromJson(String str) =>
    ForgotPasswordResponse.fromJson(json.decode(str) as Map<String, dynamic>);