// otp_verify_response_model.dart

import 'dart:convert';

class OtpVerifyResponse {
  bool? status;
  String? message;
  OtpVerifyData? data;

  OtpVerifyResponse({this.status, this.message, this.data});

  OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? OtpVerifyData.fromJson(json['data']) : null;
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

class OtpVerifyData {
  String? resetToken;
  String? userId;
  String? username;
  String? email;
  int? tokenExpiresInMinutes;

  OtpVerifyData({
    this.resetToken,
    this.userId,
    this.username,
    this.email,
    this.tokenExpiresInMinutes,
  });

  OtpVerifyData.fromJson(Map<String, dynamic> json) {
    resetToken = json['reset_token'];
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    tokenExpiresInMinutes = json['token_expires_in_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reset_token'] = resetToken;
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['token_expires_in_minutes'] = tokenExpiresInMinutes;
    return data;
  }
}
OtpVerifyResponse otpVerifyResponseFromJson(String str) =>
    OtpVerifyResponse.fromJson(json.decode(str) as Map<String, dynamic>);
