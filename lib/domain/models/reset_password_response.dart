import 'dart:convert';

class ResetPasswordResponse {
  final bool status;
  final String message;

  ResetPasswordResponse({
    required this.status,
    required this.message,
  });

  // Factory constructor to create from JSON
  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  // Copy with method for updating values
  ResetPasswordResponse copyWith({
    bool? status,
    String? message,
  }) {
    return ResetPasswordResponse(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ResetPasswordResponse(status: $status, message: $message)';
  }
}
ResetPasswordResponse resetResponseFromJson(String str) =>
    ResetPasswordResponse.fromJson(json.decode(str) as Map<String, dynamic>);