import 'dart:io';
import 'package:school_app/data/data.dart';
import 'package:school_app/device/device.dart';
import 'package:school_app/domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Repositories that communicate with the platform e.g. GPS
class DeviceRepository extends DomainRepository {
  /// initialize flutter secure storage
  final _flutterSecureStorage = const FlutterSecureStorage();

  /// initialize the hive box
  Future<void> init({bool isTest = false}) async {
    if (isTest) {
      Hive.init('HIVE_TEST');
      await Hive.openBox<dynamic>('appName'.tr);
    } else {
      await Hive.initFlutter();
      await Hive.openBox<dynamic>(
        'appName'.tr,
      );
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

  /// ✅ FIXED: Get data from secure storage - Returns null if not found
  @override
  Future<String> getSecuredValue(String key) async {
    try {
      String? value = await _flutterSecureStorage.read(key: key);

      if (value == null || value.isEmpty) {
        value = GetStorage().read(key);
        print("📖 Read from GetStorage: $key = ${value != null ? 'FOUND' : 'NULL'}");
        if (value == null) return '';
      } else {
        print("📖 Read from SecureStorage: $key = FOUND");
      }

      return value ?? '';  // ✅ Return empty string if null
    } catch (e) {
      print("❌ Error reading $key: $e");
      return '';
    }
  }  /// ✅ FIXED: Save data in secure storage (also save in GetStorage as backup)
  @override
  Future<void> saveValueSecurely(String key, String value) async {
    try {
      print("🔐 Saving: $key = $value");
      await _flutterSecureStorage.write(key: key, value: value);

      // ✅ Also save in GetStorage as backup
      await GetStorage().write(key, value);

      print("✅ Saved successfully: $key");
    } catch (e) {
      print("❌ Error saving $key: $e");
    }
  }
  IOSOptions _getIOSOption() => const IOSOptions(accountName: 'ePod');

  /// Delete data from secure storage
  @override
  Future<void> deleteSecuredValue(String key) async {
    try {
      await _flutterSecureStorage.delete(key: key);
      final GetStorage box = GetStorage();
      await box.remove(key);
      print("🗑️ Deleted: $key");
    } catch (error) {
      print("❌ Error deleting $key: $error");
    }
  }

  /// Delete all data from secure storage
  @override
  Future<void> deleteAllSecuredValues() async {
    try {
      await _flutterSecureStorage.deleteAll();
      final GetStorage box = GetStorage();
      await box.erase();
      print("🗑️ Deleted all secured values");
    } catch (error) {
      print("❌ Error deleting all: $error");
    }
  }

  @override
  Future<ResponseModel> loginApi({
    required bool isLoading,
    required String loginName,
    required String branchCode,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> forgotPasswordAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> verifyOtpAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
    required String otp,
  }) {
    throw UnimplementedError();
  }

  @override
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

  @override
  Future<ResponseModel> resendOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getFeesDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) {
    throw UnimplementedError();
  }
  @override
  Future<ResponseModel> getTeacherDashboardAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }
  @override
  Future<ResponseModel> getStaffProfileData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getLateArrivalData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getLeaveStatusData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getInvoiceDetailsAPI({
    required bool isLoading,
    required String token,
    required String invoiceId,
    required String branchId,
  }) {
    throw UnimplementedError();
  }
  @override
  Future<ResponseModel> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getMyClassDetailsData({
    required bool isLoading,
    required String token,
    required String classId,
    required String sectionId,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  @override
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
  @override
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

  @override
  Future<ResponseModel> getAllStudentList({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> saveAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload
  }) {
    throw UnimplementedError();
  }
@override
  Future<ResponseModel> updateAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload
  }) {
    throw UnimplementedError();
  }

  @override
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

  @override
  Future<ResponseModel> getMyClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }
  @override
  Future<ResponseModel> getTermClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getExamGroupData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) {
    throw UnimplementedError();
  }
  @override
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
  @override
  Future<ResponseModel> getTermSectionData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
  }) {
    throw UnimplementedError();
  }

@override
  Future<ResponseModel> getExamTermData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> logout({
    required bool isLoading,
    required String token,
  }) {
    throw UnimplementedError();
  }
}