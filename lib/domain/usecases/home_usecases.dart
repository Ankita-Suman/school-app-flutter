import 'package:school_app/domain/domain.dart';

import '../models/attendance_response.dart';
import '../models/branch_verify_response.dart';
import '../models/delete_account_response.dart';
import '../models/document_response.dart';
import '../models/events_response.dart';
import '../models/payment_order_response.dart';
import '../models/profile_response.dart';
import '../models/staff_attendance_response.dart';
import '../models/student_notice_response.dart';

/// Use case for getting the data from the API
class HomeUseCases {
  HomeUseCases(this.repository);

  final Repository repository;

  Future<ProfileResponse?> getProfileDetailsAPI(
          {required bool isLoading,
            required String token,
            required String branchId, required String studentId,
          }) async =>
      await repository.getProfileDetailsAPI(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
        studentId: studentId,
      );
  Future<DocumentsResponse?> getStudentDocumentsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async =>
      await repository.getStudentDocumentsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
  Future<StaffAttendanceResponse?> getStaffAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String month,
  }) async =>
      await repository.getStaffAttendanceRecordAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        month: month,
      );

  /// ✅ NEW: Create Payment Order
  Future<PaymentOrderResponse?> createPaymentOrder({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required List<String> invoiceIds,
    required double amount,
    required String sessionId,
  }) async =>
      await repository.createPaymentOrder(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        invoiceIds: invoiceIds,
        amount: amount,
        sessionId: sessionId,
      );
  Future<FeeResponseModel?> getFeesDetailsAPI(
          {required bool isLoading,
            required String token,
            required String branchId, required String studentId,
          }) async =>
      await repository.getFeesDetailsAPI(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
        studentId: studentId,
      );
  Future<AttendanceResponse?> getAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required String month,
  }) async =>
      await repository.getAttendanceRecordAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        month: month,
      );
  Future<StudentNoticeResponse?> getStudentNoticesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async =>
      await repository.getStudentNoticesAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
  Future<EventsResponseModel?> getAllEvents(
          {required bool isLoading,
            required String token,
            required String branchId, required String studentId,
          }) async =>
      await repository.getAllEvents(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
        studentId: studentId,
      );

  Future<ResponseModel?> logoutAPI(
          {required bool isLoading, required String token,
          }) async =>
      await repository.logoutAPI(
          isLoading: isLoading,
        token: token,
      );

  Future<DeleteAccountResponse?> sendDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
  }) async =>
      await repository.sendDeleteAccountOtp(
        isLoading: isLoading,
        branchCode: branchCode,
        username: username,
      );

  Future<DeleteAccountResponse?> verifyDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
    required String otp,
  }) async =>
      await repository.verifyDeleteAccountOtp(
        isLoading: isLoading,
        branchCode: branchCode,
        username: username,
        otp: otp,
      );

  Future<BranchVerifyResponse?> getSchoolInfo({
    required bool isLoading,
    required String branchCode,

  }) async =>
      await repository.getBranchInfo(
        isLoading: isLoading,
        branchCode: branchCode,
      );
}
