import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:school_app/data/data.dart';
import 'package:school_app/device/device.dart';
import 'package:school_app/domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Repositories that communicate with the platform e.g. GPS
class DeviceRepository extends DomainRepository {
  /// ✅ CRITICAL FIXES:
  ///   - resetOnError=false  → Keystore error पर data WIPE नहीं होगा
  ///   - encryptedSharedPreferences=true → Android पर reliable
  ///   - first_unlock accessibility → iOS पर lock screen unlock के बाद accessible
  final _flutterSecureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: false, // 🔥 THE MOST IMPORTANT FIX
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// initialize the hive box
  Future<void> init({bool isTest = false}) async {
    if (isTest) {
      Hive.init('HIVE_TEST');
      await Hive.openBox<dynamic>('appName'.tr);
    } else {
      await Hive.initFlutter();
      await Hive.openBox<dynamic>('appName'.tr);
    }
  }

  /// Returns the box in which the data is stored.
  Box _getBox() => Hive.box<dynamic>('appName'.tr);

  @override
  void clearData(dynamic key) {
    _getBox().delete(key);
  }

  /// Delete the box
  @override
  Future<void> deleteBox() async {
    await GetStorage('appData').remove(DeviceConstants.showLogin);
  }

  /// returns stored string value
  @override
  String getStringValue(String key) {
    var box = _getBox();
    var defaultValue = '';
    if (key == DeviceConstants.localLang) {
      defaultValue = DataConstants.defaultLang;
    }
    String? value = box.get(key, defaultValue: defaultValue) as String? ?? '';
    return value;
  }

  /// store the data
  @override
  void saveValue(dynamic key, dynamic value) {
    _getBox().put(key, value);
  }

  /// return bool value
  @override
  bool getBoolValue(String key) =>
      _getBox().get(key, defaultValue: false) as bool;

  /// ✅ FIXED: Exception पर भी GetStorage fallback try करेगा + self-healing
  @override
  Future<String> getSecuredValue(String key) async {
    // 1️⃣ Try secure storage
    try {
      final value = await _flutterSecureStorage.read(key: key);
      if (value != null && value.isNotEmpty) {
        debugPrint("📖 SecureStorage HIT: $key");
        return value;
      }
    } catch (e) {
      // ❗ IMPORTANT: return नहीं करना — नीचे GetStorage fallback try होगा
      debugPrint("⚠️ SecureStorage read failed for $key: $e");
    }

    // 2️⃣ ALWAYS try GetStorage as fallback (even after exception)
    try {
      final fallback = GetStorage().read(key);
      if (fallback != null && fallback.toString().isNotEmpty) {
        debugPrint("📖 GetStorage fallback HIT: $key");
        // ✅ Best effort: re-save to secure storage (self-healing)
        try {
          await _flutterSecureStorage.write(
              key: key, value: fallback.toString());
          debugPrint("♻️ Re-saved $key to SecureStorage");
        } catch (_) {}
        return fallback.toString();
      }
    } catch (e) {
      debugPrint("⚠️ GetStorage read failed for $key: $e");
    }

    debugPrint("❌ $key NOT FOUND anywhere");
    return '';
  }

  /// ✅ FIXED: दोनों जगह save की independent कोशिश
  @override
  Future<void> saveValueSecurely(String key, String value) async {
    // 1️⃣ Save to secure storage
    try {
      await _flutterSecureStorage.write(key: key, value: value);
      debugPrint("💾 SecureStorage SAVED: $key");
    } catch (e) {
      debugPrint("⚠️ SecureStorage write failed for $key: $e");
    }

    // 2️⃣ ALWAYS save to GetStorage (independent of above)
    try {
      await GetStorage().write(key, value);
      debugPrint("💾 GetStorage SAVED: $key");
    } catch (e) {
      debugPrint("⚠️ GetStorage write failed for $key: $e");
    }
  }

  /// Delete data from secure storage
  @override
  Future<void> deleteSecuredValue(String key) async {
    try {
      await _flutterSecureStorage.delete(key: key);
    } catch (e) {
      debugPrint("⚠️ SecureStorage delete failed for $key: $e");
    }
    try {
      await GetStorage().remove(key);
    } catch (e) {
      debugPrint("⚠️ GetStorage delete failed for $key: $e");
    }
  }

  /// Delete all data from secure storage
  @override
  Future<void> deleteAllSecuredValues() async {
    try {
      await _flutterSecureStorage.deleteAll();
    } catch (e) {
      debugPrint("⚠️ SecureStorage deleteAll failed: $e");
    }
    try {
      await GetStorage().erase();
    } catch (e) {
      debugPrint("⚠️ GetStorage erase failed: $e");
    }
  }

  // ==========================================================
  // ⚠️ नीचे सभी unimplemented API methods वैसे ही (कुछ नहीं बदला)
  // ==========================================================

  @override
  Future<ResponseModel> loginApi({
    required bool isLoading,
    required String loginName,
    required String branchCode,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  Future<ResponseModel> forgotPasswordAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> verifyOtpAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
    required String otp,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> resetPasswordAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getStaffAnnouncementDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String tab,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> sendDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> verifyDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
    required String otp,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> changePasswordAPI({
    required bool isLoading,
    required String branchId,
    required String token,
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getStaffAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String month,
  }) {
    throw UnimplementedError();
  }
  // ✅ NEW: Classmates API
  Future<ResponseModel> getClassmatesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> resetStaffPassword({
    required bool isLoading,
    required String currentPassword,
    required String branchId,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> submitLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason, File? attachment, required String studentId,
  }) {
    throw UnimplementedError();
  }
Future<ResponseModel> submitStaffLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason, File? attachment,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> resendOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getStudentDocumentsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getFeesDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required String month,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getAnnouncementDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getTeacherDashboardAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getLeaveApprovalStatusAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getStaffProfileData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getLateArrivalData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getLeaveBalanceAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getSchoolInfo({
    required bool isLoading, required String branchCode,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getBranchInfo({
    required bool isLoading, required String branchCode,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getLeaveStatusData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getLeaveHistory({
    required bool isLoading,
    required String token,
    required String branchId,
    required String staffId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getInvoiceDetailsAPI({
    required bool isLoading,
    required String token,
    required String invoiceId,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getMyClassDetailsData({
    required bool isLoading,
    required String token,
    required String classId,
    required String sectionId,
    required String branchId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> getStudentListData({
    required bool isLoading,
    required String token,
    required String classId,
    required String sectionId,
    required String branchId,
    required String date,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> createPaymentOrder({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required List<String> invoiceIds,
    required double amount,
    required String sessionId,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> saveCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) {
    throw UnimplementedError();
  }
  Future<ResponseModel> fetchClassAttendanceReport({
    required bool isLoading,
    required String token,
    required String classId,
    required String sectionId,
    required String branchId,
    required String date,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getAllStudentList({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> saveAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> updateAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getClassAttendance({
    required bool isLoading,
    required String token,
    required String attendanceDate,
    required String branchId,
    required String classId,
    required String sectionId, required int perPage,required int page
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getMyClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getTermClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getExamGroupData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getTermAttendanceStudents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> saveExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> saveInternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getExamSchedule({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getTermSectionData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getSubjectData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getStudentFeeList({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> getExamTermData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
  }) {
    throw UnimplementedError();
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
  }) {
    throw UnimplementedError();
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
  }) {
    throw UnimplementedError();
  }

  Future<ResponseModel> logout({
    required bool isLoading,
    required String token,
  }) {
    throw UnimplementedError();
  }
}