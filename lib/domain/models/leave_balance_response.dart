import 'dart:convert';

LeaveBalanceResponse leaveBalanceResponseFromJson(String str) =>
    LeaveBalanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String leaveBalanceResponseToJson(LeaveBalanceResponse data) =>
    json.encode(data.toJson());

// ============================================================
// MAIN RESPONSE
// ============================================================
class LeaveBalanceResponse {
  final bool status;
  final String message;
  final LeaveBalanceData? data;

  LeaveBalanceResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LeaveBalanceData.fromJson(json['data'] as Map<String, dynamic>)
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

// ============================================================
// DATA
// ============================================================
class LeaveBalanceData {
  final int totalQuota;
  final int totalUsed;
  final int totalRemaining;
  final List<LeaveBreakdown> breakdown;

  LeaveBalanceData({
    required this.totalQuota,
    required this.totalUsed,
    required this.totalRemaining,
    required this.breakdown,
  });

  factory LeaveBalanceData.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceData(
      totalQuota: json['total_quota'] as int? ?? 0,
      totalUsed: json['total_used'] as int? ?? 0,
      totalRemaining: json['total_remaining'] as int? ?? 0,
      breakdown: (json['breakdown'] as List<dynamic>?)
          ?.map((e) => LeaveBreakdown.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_quota': totalQuota,
      'total_used': totalUsed,
      'total_remaining': totalRemaining,
      'breakdown': breakdown.map((e) => e.toJson()).toList(),
    };
  }
}

// ============================================================
// BREAKDOWN ITEM
// ============================================================
class LeaveBreakdown {
  final String leaveType;
  final int quota;
  final int used;
  final int remaining;

  LeaveBreakdown({
    required this.leaveType,
    required this.quota,
    required this.used,
    required this.remaining,
  });

  factory LeaveBreakdown.fromJson(Map<String, dynamic> json) {
    return LeaveBreakdown(
      leaveType: json['leave_type'] as String? ?? '',
      quota: json['quota'] as int? ?? 0,
      used: json['used'] as int? ?? 0,
      remaining: json['remaining'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type': leaveType,
      'quota': quota,
      'used': used,
      'remaining': remaining,
    };
  }

  // ---------- Helpers ----------
  bool get hasQuota => quota > 0;
  bool get isFullyUsed => remaining == 0;
  double get usedPercentage => quota > 0 ? (used / quota) * 100 : 0.0;
  double get remainingPercentage => quota > 0 ? (remaining / quota) * 100 : 0.0;
  String get leaveTypeDisplay => leaveType.isNotEmpty ? leaveType.toUpperCase() : '--';
}