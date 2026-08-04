import 'dart:convert';

import 'package:flutter/material.dart';

LeaveRequestsResponse leaveRequestsResponseFromJson(String str) =>
    LeaveRequestsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String leaveRequestsResponseToJson(LeaveRequestsResponse data) =>
    json.encode(data.toJson());

// ============================================================
// MAIN RESPONSE
// ============================================================
class LeaveRequestsResponse {
  final bool status;
  final String message;
  final LeaveRequestsData? data;

  LeaveRequestsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LeaveRequestsResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LeaveRequestsData.fromJson(json['data'] as Map<String, dynamic>)
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
  bool get hasData => data != null && data!.items.isNotEmpty;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
}

// ============================================================
// DATA (Pagination wrapper)
// ============================================================
class LeaveRequestsData {
  final List<LeaveRequest> items;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  LeaveRequestsData({
    required this.items,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory LeaveRequestsData.fromJson(Map<String, dynamic> json) {
    return LeaveRequestsData(
      items: (json['data'] as List<dynamic>?)
          ?.map((e) => LeaveRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 15,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': items.map((e) => e.toJson()).toList(),
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }

  // ---------- Helpers ----------
  bool get hasItems => items.isNotEmpty;
  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
}

// ============================================================
// LEAVE REQUEST ITEM
// ============================================================
class LeaveRequest {
  final String id;
  final String leaveType;
  final String leaveReason;
  final String fromDate;
  final String toDate;
  final int durationDays;
  final String appliedDate;
  final String status;
  final String? attachment;
  final String? approvalRemarks;
  final String? approvedBy;
  final String? approvedAt;
  final String? createdAt;

  LeaveRequest({
    required this.id,
    required this.leaveType,
    required this.leaveReason,
    required this.fromDate,
    required this.toDate,
    required this.durationDays,
    required this.appliedDate,
    required this.status,
    this.attachment,
    this.approvalRemarks,
    this.approvedBy,
    this.approvedAt,
    this.createdAt,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as String? ?? '',
      leaveType: json['leave_type'] as String? ?? '',
      leaveReason: json['leave_reason'] as String? ?? '',
      fromDate: json['from_date'] as String? ?? '',
      toDate: json['to_date'] as String? ?? '',
      durationDays: json['duration_days'] as int? ?? 0,
      appliedDate: json['applied_date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      attachment: json['attachment'] as String?,
      approvalRemarks: json['approval_remarks'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leave_type': leaveType,
      'leave_reason': leaveReason,
      'from_date': fromDate,
      'to_date': toDate,
      'duration_days': durationDays,
      'applied_date': appliedDate,
      'status': status,
      'attachment': attachment,
      'approval_remarks': approvalRemarks,
      'approved_by': approvedBy,
      'approved_at': approvedAt,
      'created_at': createdAt,
    };
  }

  // ========== HELPER METHODS ==========

  /// Get status color for UI
  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Get status background color for UI
  Color get statusBgColor {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange.shade50;
      case 'APPROVED':
        return Colors.green.shade50;
      case 'REJECTED':
        return Colors.red.shade50;
      case 'CANCELLED':
        return Colors.grey.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  /// Get formatted status with emoji
  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return '🕒 Pending';
      case 'APPROVED':
        return '✅ Approved';
      case 'REJECTED':
        return '❌ Rejected';
      case 'CANCELLED':
        return '🚫 Cancelled';
      default:
        return status;
    }
  }

  /// Check if request is pending
  bool get isPending => status.toUpperCase() == 'PENDING';

  /// Check if request is approved
  bool get isApproved => status.toUpperCase() == 'APPROVED';

  /// Check if request is rejected
  bool get isRejected => status.toUpperCase() == 'REJECTED';

  /// Check if request is cancelled
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  /// Get leave type with emoji
  String get leaveTypeDisplay {
    switch (leaveType.toUpperCase()) {
      case 'CASUAL':
        return '🏖️ Casual Leave';
      case 'SICK':
        return '🤒 Sick Leave';
      case 'EARNED':
        return '📈 Earned Leave';
      default:
        return leaveType;
    }
  }

  /// Format date for display (YYYY-MM-DD → DD/MM/YYYY)
  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '--';
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  String get formattedFromDate => _formatDate(fromDate);
  String get formattedToDate => _formatDate(toDate);
  String get formattedAppliedDate => _formatDate(appliedDate);

  /// Get date range display
  String get dateRangeDisplay {
    if (fromDate.isEmpty || toDate.isEmpty) return '--';
    return '$formattedFromDate - $formattedToDate';
  }

  /// Get leave duration display
  String get durationDisplay {
    if (durationDays == 0) return '--';
    return '$durationDays day${durationDays > 1 ? 's' : ''}';
  }

  /// Check if attachment exists
  bool get hasAttachment => attachment != null && attachment!.isNotEmpty;

  /// Check if approval remarks exist
  bool get hasApprovalRemarks => approvalRemarks != null && approvalRemarks!.isNotEmpty;
}