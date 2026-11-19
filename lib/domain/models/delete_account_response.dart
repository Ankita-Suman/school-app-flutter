// domain/models/delete_account_response.dart

import 'dart:convert';

class DeleteAccountResponse {
  bool? status;
  String? message;
  DeleteAccountData? data;

  DeleteAccountResponse({this.status, this.message, this.data});

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    // ✅ status बool, int, string, null — सब handle
    bool? parsedStatus;
    final rawStatus = json['status'];
    if (rawStatus is bool) {
      parsedStatus = rawStatus;
    } else if (rawStatus is int) {
      parsedStatus = rawStatus == 1;
    } else if (rawStatus is String) {
      final s = rawStatus.toLowerCase();
      parsedStatus = (s == 'true' || s == '1' || s == 'success');
    }

    // ✅ data केवल Map हो तभी parse करो
    DeleteAccountData? parsedData;
    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      parsedData = DeleteAccountData.fromJson(rawData);
    } else if (rawData is String && rawData.isNotEmpty) {
      // कभी-कभी backend string में JSON देता है
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) {
          parsedData = DeleteAccountData.fromJson(decoded);
        }
      } catch (_) {}
    }

    return DeleteAccountResponse(
      status: parsedStatus,
      message: json['message']?.toString(),
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeleteAccountData {
  // Send OTP fields
  int? expiresInMinutes;
  int? resendAfterSeconds;
  String? otp;

  // Verify OTP fields
  String? requestId;
  String? status;
  String? requestedAt;

  DeleteAccountData({
    this.expiresInMinutes,
    this.resendAfterSeconds,
    this.otp,
    this.requestId,
    this.status,
    this.requestedAt,
  });

  factory DeleteAccountData.fromJson(Map<String, dynamic> json) {
    return DeleteAccountData(
      // ✅ सबको safe से parse करो (int/bool/String/null कुछ भी आए)
      expiresInMinutes: _toInt(json['expires_in_minutes']),
      resendAfterSeconds: _toInt(json['resend_after_seconds']),
      otp: json['otp']?.toString(),
      requestId: json['request_id']?.toString(),
      status: json['status']?.toString(),
      requestedAt: json['requested_at']?.toString(),
    );
  }

  // ✅ Helper: किसी भी type को safe int में बदलो
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expires_in_minutes'] = expiresInMinutes;
    data['resend_after_seconds'] = resendAfterSeconds;
    data['otp'] = otp;
    data['request_id'] = requestId;
    data['status'] = status;
    data['requested_at'] = requestedAt;
    return data;
  }
}