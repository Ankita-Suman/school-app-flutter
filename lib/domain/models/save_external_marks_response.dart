import 'dart:convert';

SaveExternalMarksResponse saveExternalMarksResponseFromJson(String str) =>
    SaveExternalMarksResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String saveExternalMarksResponseToJson(SaveExternalMarksResponse data) =>
    json.encode(data.toJson());

class SaveExternalMarksResponse {
  final bool status;
  final String message;

  SaveExternalMarksResponse({
    required this.status,
    required this.message,
  });

  factory SaveExternalMarksResponse.fromJson(Map<String, dynamic> json) {
    return SaveExternalMarksResponse(
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

  // ========== Helpers ==========
  bool get isSuccess => status == true;
}