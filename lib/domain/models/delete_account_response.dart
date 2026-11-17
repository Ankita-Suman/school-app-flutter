// domain/models/delete_account_response.dart

class DeleteAccountResponse {
  bool? status;
  String? message;
  DeleteAccountData? data;

  DeleteAccountResponse({this.status, this.message, this.data});

  DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DeleteAccountData.fromJson(json['data']) : null;
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
  // ==========================================
  // ✅ Send OTP API के लिए फील्ड्स
  // ==========================================
  int? expiresInMinutes;
  int? resendAfterSeconds;
  String? otp;

  // ==========================================
  // ✅ Verify OTP API के लिए फील्ड्स
  // ==========================================
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

  DeleteAccountData.fromJson(Map<String, dynamic> json) {
    // Send OTP Fields
    expiresInMinutes = json['expires_in_minutes'];
    resendAfterSeconds = json['resend_after_seconds'];
    otp = json['otp'];

    // Verify OTP Fields
    requestId = json['request_id'];
    status = json['status'];
    requestedAt = json['requested_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Send OTP Fields
    data['expires_in_minutes'] = expiresInMinutes;
    data['resend_after_seconds'] = resendAfterSeconds;
    data['otp'] = otp;

    // Verify OTP Fields
    data['request_id'] = requestId;
    data['status'] = status;
    data['requested_at'] = requestedAt;

    return data;
  }
}