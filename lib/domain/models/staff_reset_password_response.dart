import 'dart:convert';

StaffResetPasswordResponse resetPasswordResponseFromJson(String str) =>
    StaffResetPasswordResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String resetPasswordResponseToJson(StaffResetPasswordResponse data) =>
    json.encode(data.toJson());

class StaffResetPasswordResponse {
  final bool status;
  final String message;

  StaffResetPasswordResponse({
    required this.status,
    required this.message,
  });

  factory StaffResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return StaffResetPasswordResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}