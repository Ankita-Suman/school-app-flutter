import 'dart:convert';

import 'leave_request_status_response.dart';

LeaveRequestSubmitResponse leaveRequestSubmitResponseFromJson(String str) =>
    LeaveRequestSubmitResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String leaveRequestSubmitResponseToJson(LeaveRequestSubmitResponse data) =>
    json.encode(data.toJson());

class LeaveRequestSubmitResponse {
  final bool status;
  final String message;
  final LeaveRequest? data;

  LeaveRequestSubmitResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LeaveRequestSubmitResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestSubmitResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LeaveRequest.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  // ---------- Helpers ----------
  bool get isSuccess => status == true;
  bool get hasData => data != null;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
}