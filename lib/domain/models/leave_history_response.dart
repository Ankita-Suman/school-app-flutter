import 'dart:convert';

LeaveHistoryResponse leaveHistoryResponseFromJson(String str) =>
    LeaveHistoryResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String leaveHistoryResponseToJson(LeaveHistoryResponse data) =>
    json.encode(data.toJson());

// ============================================================
// MAIN RESPONSE
// ============================================================
class LeaveHistoryResponse {
  final bool status;
  final String message;
  final List<LeaveHistoryItem>? data;

  LeaveHistoryResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LeaveHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  bool get isSuccess => status == true;
  bool get hasData => data != null && data!.isNotEmpty;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
}

// ============================================================
// LEAVE HISTORY ITEM
// ============================================================
class LeaveHistoryItem {
  final String id;
  final StaffInfo staff;
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
  final List<TimelineItem>? timeline;

  LeaveHistoryItem({
    required this.id,
    required this.staff,
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
    this.timeline,
  });

  factory LeaveHistoryItem.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryItem(
      id: json['id'] as String? ?? '',
      staff: StaffInfo.fromJson(json['staff'] as Map<String, dynamic>),
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
      timeline: (json['timeline'] as List<dynamic>?)
          ?.map((e) => TimelineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff': staff.toJson(),
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
      'timeline': timeline?.map((e) => e.toJson()).toList(),
    };
  }

  // ========== HELPERS ==========
  bool get hasAttachment => attachment != null && attachment!.isNotEmpty;
  bool get hasApprovalRemarks => approvalRemarks != null && approvalRemarks!.isNotEmpty;
  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isApproved => status.toUpperCase() == 'APPROVED';
  bool get isRejected => status.toUpperCase() == 'REJECTED';

  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }

  String get leaveTypeDisplay {
    switch (leaveType.toUpperCase()) {
      case 'CASUAL':
        return 'Casual Leave';
      case 'SICK':
        return 'Sick Leave';
      case 'EARNED':
        return 'Earned Leave';
      default:
        return leaveType;
    }
  }

  String get formattedFromDate => _formatDate(fromDate);
  String get formattedToDate => _formatDate(toDate);
  String get formattedAppliedDate => _formatDate(appliedDate);

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

  String get dateRangeDisplay => '$formattedFromDate - $formattedToDate';
  String get durationDisplay => '$durationDays day${durationDays > 1 ? 's' : ''}';
}

// STAFF INFO
// ============================================================
class StaffInfo {
  final String id;
  final String staffId;
  final String fullName;
  final String? photo;

  StaffInfo({
    required this.id,
    required this.staffId,
    required this.fullName,
    this.photo,
  });

  factory StaffInfo.fromJson(Map<String, dynamic> json) {
    return StaffInfo(
      id: json['id'] as String? ?? '',
      staffId: json['staff_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'full_name': fullName,
      'photo': photo,
    };
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

// ============================================================
// TIMELINE ITEM
// ============================================================
class TimelineItem {
  final String action;
  final String actionBy;
  final String? remarks;
  final String? actionDate;

  TimelineItem({
    required this.action,
    required this.actionBy,
    this.remarks,
    this.actionDate,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      action: json['action'] as String? ?? '',
      actionBy: json['action_by'] as String? ?? '',
      remarks: json['remarks'] as String?,
      actionDate: json['action_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'action_by': actionBy,
      'remarks': remarks,
      'action_date': actionDate,
    };
  }
}