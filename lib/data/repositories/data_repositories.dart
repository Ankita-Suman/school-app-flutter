import 'dart:io';

import 'package:school_app/data/data.dart';
import 'package:school_app/domain/domain.dart';

/// Repositories (retrieve data, heavy processing etc..)
class DataRepository extends DomainRepository {
  /// [connectHelper] : A connection helper which will connect to the
  /// remote to get the data.
  DataRepository(this.connectHelper);

  final ConnectHelper connectHelper;

  @override
  void clearData(dynamic key) {
    throw UnimplementedError();
  }

  /// Delete the box
  @override
  void deleteBox() {
    throw UnimplementedError();
  }

  /// returns stored string value
  @override
  String getStringValue(String key) {
    throw UnimplementedError();
  }

  /// store the data
  @override
  void saveValue(dynamic key, dynamic value) {
    throw UnimplementedError();
  }

  /// return bool value
  @override
  bool getBoolValue(String key) => throw UnimplementedError();

  /// Get data from secure storage
  @override
  Future<String> getSecuredValue(String key) async {
    throw UnimplementedError();
  }

  /// Save data in secure storage
  @override
  void saveValueSecurely(String key, String value) {
    throw UnimplementedError();
  }

  /// Delete data from secure storage
  @override
  void deleteSecuredValue(String key) {
    throw UnimplementedError();
  }

  /// Delete all data from secure storage
  @override
  Future<void> deleteAllSecuredValues() async {
    throw UnimplementedError();
  }

  Future<ResponseModel> logoutAPI(
      {required bool isLoading,
      required String? token}) async {
    var res = await connectHelper.logoutAPI(
        isLoading: isLoading, token: token);
    return res;
  }  @override


  @override
  Future<ResponseModel> loginApi(
      {required bool isLoading,
      required String password,
        required String loginName,
        required String branchCode}) async {
    var res = await connectHelper.loginApi(
        isLoading: isLoading,
        loginName: loginName,
        branchCode: branchCode,
        password: password);
    return res;
  }
  Future<ResponseModel> forgotPasswordAPI({required bool isLoading, required String login,
    required String branchCode}) async {
    var res = await connectHelper.forgotPasswordAPI(
      isLoading: isLoading,
      branchCode: branchCode,
      login: login,
    );
    return res;
  }

  Future<ResponseModel> resendOtpAPI({required bool isLoading, required String login,
    required String branchCode}) async {
    var res = await connectHelper.resendOtpAPI(
      isLoading: isLoading,
      branchCode: branchCode,
      login: login,
    );
    return res;
  }

  Future<ResponseModel> verifyOtpAPI({required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async {
    var res = await connectHelper.verifyOtpAPI(
      isLoading: isLoading,
      login: login,
      branchCode: branchCode,
      otp: otp,
    );
    return res;
  }

  Future<ResponseModel> resetPasswordAPI({required bool isLoading,
    required String login,
    required String branchCode,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    var res = await connectHelper.resetPasswordAPI(
      isLoading: isLoading,
      login: login,
      branchCode: branchCode,
      token: token,
      newPassword: newPassword,
      passwordConfirmation: passwordConfirmation,
    );
    return res;
  }
  Future<ResponseModel> submitLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason, File? attachment,
  }) async {
    var res = await connectHelper.submitLeaveApplication(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      leaveType: leaveType,
      fromDate: fromDate,
      toDate: toDate,
      reason: reason,
      attachment: attachment,
    );
    return res;
  }
  Future<ResponseModel?> resetStaffPassword({required bool isLoading,
    required String currentPassword,
    required String branchId,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    var res = await connectHelper.resetStaffPassword(
      isLoading: isLoading,
      currentPassword: currentPassword,
      branchId: branchId,
      token: token,
      newPassword: newPassword,
      passwordConfirmation: passwordConfirmation,
    );
    return res;
  }

  Future<ResponseModel> getProfileDetailsAPI({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var res = await connectHelper.getProfileDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
    return res;
  }

  Future<ResponseModel> getFeesDetailsAPI({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var res = await connectHelper.getFeesDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
    return res;
  }

  Future<ResponseModel> getTeacherDashboardAPI({required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var res = await connectHelper.getTeacherDashboardAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

  Future<ResponseModel> getLeaveApprovalStatusAPI({required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var res = await connectHelper.getLeaveApprovalStatusAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }


  Future<ResponseModel> getStaffProfileData({required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var res = await connectHelper.getStaffProfileData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

  Future<ResponseModel> getLateArrivalData({required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    var res = await connectHelper.getLateArrivalData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      filter: filter,
    );
    return res;
  }

  Future<ResponseModel> getLeaveBalanceAPI({required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var res = await connectHelper.getLeaveBalanceAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }
  Future<ResponseModel> getSchoolInfo({required bool isLoading,
    required String branchCode,

  }) async {
    var res = await connectHelper.getSchoolInfo(
      isLoading: isLoading,
      branchCode: branchCode,
    );
    return res;
  }

  Future<ResponseModel> getLeaveStatusData({required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    var res = await connectHelper.getLeaveStatusData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      filter: filter,
    );
    return res;
  }

  Future<ResponseModel> getLeaveHistory({required bool isLoading,
    required String token,
    required String branchId,
    required String staffId,
  }) async {
    var res = await connectHelper.getLeaveHistory(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      staffId: staffId,
    );
    return res;
  }

  Future<ResponseModel> getAllEvents({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var res = await connectHelper.getAllEvents(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
    return res;
  }

  Future<ResponseModel> getMyClassData({required bool isLoading,
    required String token,
    required String branchId
  }) async {
    var res = await connectHelper.getMyClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

  Future<ResponseModel> getTermClassData({required bool isLoading,
    required String token,
    required String branchId
  }) async {
    var res = await connectHelper.getTermClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

  Future<ResponseModel> saveExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var res = await connectHelper.saveExternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }

  Future<ResponseModel> saveInternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var res = await connectHelper.saveInternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }

  Future<ResponseModel> getTermAttendanceStudents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getTermAttendanceStudents(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }

  Future<ResponseModel> getExamSchedule({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getExamSchedule(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }

  Future<ResponseModel> getExamGroupData({required bool isLoading,
    required String token,
    required String branchId
  }) async {
    var res = await connectHelper.getExamGroupData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

  Future<ResponseModel> getTermSectionData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId
  }) async {
    var res = await connectHelper.getTermSectionData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
    );
    return res;
  }

  Future<ResponseModel> getSubjectData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getSubjectData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }
  Future<ResponseModel> getStudentFeeList({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getStudentFeeList(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }

  Future<ResponseModel> getExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
    required String subjectId,
    required String markType,
    required String internalCount,
  }) async {
    var res = await connectHelper.getExternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
      subjectId: subjectId,
      markType: markType,
      internalCount: internalCount,
    );
    return res;
  }

  Future<ResponseModel> getInternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
    required String subjectId,
    required String markType,
  }) async {
    var res = await connectHelper.getInternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
      subjectId: subjectId,
      markType: markType,
    );
    return res;
  }

  Future<ResponseModel> getExamTermData({required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId
  }) async {
    var res = await connectHelper.getExamTermData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
    );
    return res;
  }


  Future<ResponseModel> getMyClassDetailsData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getMyClassDetailsData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }


  Future<ResponseModel> getStudentListData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    var res = await connectHelper.getStudentListData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
      date: date,
    );
    return res;
  }


  Future<ResponseModel> fetchClassAttendanceReport({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    var res = await connectHelper.fetchClassAttendanceReport(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
      date: date,
    );
    return res;
  }

  Future<ResponseModel> getAllStudentList({required bool isLoading,
    required String token,
    required String branchId,
  required String classId,
  required String sectionId,
  }) async {
    var res = await connectHelper.getAllStudentList(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }


  Future<ResponseModel> saveAttendance({required bool isLoading,
   required String token,
   required String branchId,
   required Map<String, dynamic> payload
  }) async {
    var res = await connectHelper.saveAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }

  Future<ResponseModel> updateAttendance({required bool isLoading,
   required String token,
   required String branchId,
   required Map<String, dynamic> payload
  }) async {
    var res = await connectHelper.updateAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }

  Future<ResponseModel> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var res = await connectHelper.saveTermAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }


  Future<ResponseModel> getClassAttendance({required bool isLoading,
    required String token,
    required String attendanceDate,
    required String branchId,
    required String classId,
    required String sectionId, required int perPage,required int page
  }) async {
    var res = await connectHelper.getClassAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      attendanceDate: attendanceDate,
      classId: classId,
      sectionId: sectionId,
      perPage: perPage,
      page: page,
    );
    return res;
  }


  Future<ResponseModel> getInvoiceDetailsAPI({required bool isLoading,
    required String token,
    required String invoiceId, required String branchId,
  }) async {
    var res = await connectHelper.getInvoiceDetailsAPI(
      isLoading: isLoading,
      token: token,
      invoiceId: invoiceId,
      branchId: branchId,
    );
    return res;
  }

}
