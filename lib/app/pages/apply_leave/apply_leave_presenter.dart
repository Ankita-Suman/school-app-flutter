import 'dart:io';
import 'package:school_app/domain/domain.dart';

class ApplyLeavePresenter {
  ApplyLeavePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  // ========== SUBMIT LEAVE APPLICATION ==========
  Future<LeaveRequestSubmitResponse?> submitLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    required File? attachment, // ✅ File? nullable
  }) async {
    return await homeUseCases.submitLeaveApplication(
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
