// lib/domain/models/branch_verify_response.dart
import 'dart:convert';

BranchVerifyResponse branchInfoResponseFromJson(String str) =>
    BranchVerifyResponse.fromJson(json.decode(str) as Map<String, dynamic>);

class BranchVerifyResponse {
  final bool status;
  final String message;
  final BranchData? data;

  BranchVerifyResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BranchVerifyResponse.fromJson(Map<String, dynamic> json) {
    return BranchVerifyResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? BranchData.fromJson(json['data'] as Map<String, dynamic>)
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
}

class BranchData {
  final String branchId;
  final String branchCode;
  final String branchName;
  final String address;  // ✅ नया फील्ड जोड़ा गया
  final String mapUrl;   // ✅ नया फील्ड जोड़ा गया
  final String logoUrl;

  BranchData({
    required this.branchId,
    required this.branchCode,
    required this.branchName,
    required this.address,
    required this.mapUrl,
    required this.logoUrl,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      branchId: json['branch_id'] as String? ?? '',
      branchCode: json['branch_code'] as String? ?? '',
      branchName: json['branch_name'] as String? ?? '',
      address: json['address'] as String? ?? '',       // ✅ यहाँ से डेटा उठेगा
      mapUrl: json['map_url'] as String? ?? '',        // ✅ यहाँ से डेटा उठेगा
      logoUrl: json['logo_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'branch_code': branchCode,
      'branch_name': branchName,
      'address': address,
      'map_url': mapUrl,
      'logo_url': logoUrl,
    };
  }
}