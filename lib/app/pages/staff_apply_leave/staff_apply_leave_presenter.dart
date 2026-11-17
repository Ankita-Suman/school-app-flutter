

import 'dart:io';

import '../../../domain/models/leave_request_submit_response.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

class StaffApplyLeavePresenter {
  StaffApplyLeavePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  // ========== SUBMIT LEAVE APPLICATION ==========
  Future<LeaveRequestSubmitResponse?> submitStaffLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    required File? attachment, // ✅ File? nullable
  }) async {
    return await homeUseCases.submitStaffLeaveApplication(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      leaveType: leaveType,
      fromDate: fromDate,
      toDate: toDate,
      reason: reason,
      attachment: attachment,
    );
  }

}
