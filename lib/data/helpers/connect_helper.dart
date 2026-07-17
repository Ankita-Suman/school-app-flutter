// coverage:ignore-file
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:school_app/data/data.dart';
import 'package:school_app/domain/domain.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:get/get.dart';

/// The helper class which will connect to the world to get the data.
class ConnectHelper {
  ConnectHelper() {
    _init();
  }

  // late Dio dio;
  late dio_package.Dio dio;

  /// Api wrapper initialization
  final apiWrapper = ApiWrapper();

  /// Device info plugin initialization
  final deviceinfo = DeviceInfoPlugin();

  /// To get android device info
  AndroidDeviceInfo? androidDeviceInfo;

  /// To get iOS device info
  IosDeviceInfo? iosDeviceInfo;

  // IosDeviceInfo? iosDeviceInfo;

  // coverage:ignore-start
  /// initialize the andorid device information
  void _init() async {
    if (GetPlatform.isAndroid) {
      androidDeviceInfo = await deviceinfo.androidInfo;
    } else {
      iosDeviceInfo = await deviceinfo.iosInfo;
    }
    dio = dio_package.Dio();
  }

  // coverage:ignore-end

  /// Device id
  String? get deviceId => GetPlatform.isAndroid
      ? androidDeviceInfo?.id
      : iosDeviceInfo?.identifierForVendor;

  /// Device make brand
  String? get deviceMake =>
      GetPlatform.isAndroid ? androidDeviceInfo?.brand : 'Apple';

  /// Device Model
  String? get deviceModel =>
      GetPlatform.isAndroid ? androidDeviceInfo?.model : iosDeviceInfo?.model;

  /// Device is a type of 1 for Android and 2 for iOS
  String get deviceTypeCode => GetPlatform.isAndroid ? '1' : '2';

  /// Device OS
  String get deviceOs => GetPlatform.isAndroid ? 'ANDROID' : 'IOS';


  Future<ResponseModel> loginApi(
      {required bool isLoading,
      required String loginName,
      required String branchCode,
      required String password,}) async {
    var data = {
      'login': loginName,
      'password': password ,
      'branch_code': branchCode,
    };
    print("Login responsedata---: $data");
    var res = await apiWrapper.makeRequest(DataConstants.login, Request.post,
        data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> forgotPasswordAPI({required bool isLoading, required String branchCode, required String login}) async {
    var data = {
      'login': login ,
      'branch_code': branchCode,
    };
    print("Forgot password response--data---: ${data!}");
    var res = await apiWrapper.makeRequest(DataConstants.forgotPassword, Request.post, data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> resendOtpAPI({required bool isLoading, required String branchCode, required String login}) async {
    var data = {
      'login': login ,
      'branch_code': branchCode,
    };
    var res = await apiWrapper.makeRequest(DataConstants.resendOtp, Request.post, data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> verifyOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async {
    var data = {
      'login': login,
      'branch_code': branchCode,
      'otp': otp,
    };

    // Add Authorization header with Bearer token
    var headers = {
      'Content-type': 'Application/json',
      //'Authorization': 'Bearer $token', // Add this line
    };

    var res = await apiWrapper.makeRequest(
        DataConstants.verifyOtp,
        Request.post,
        data,
        isLoading,
        headers
    );
    return res;
  }

  Future<ResponseModel> resetPasswordAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    var data = {
      'branch_code': branchCode,
      'login': login,
      'reset_token': token,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    };

    // Add Authorization header with Bearer token
    var headers = {
      'Content-type': 'Application/json',
    };

    var res = await apiWrapper.makeRequest(
        DataConstants.resetPassword,
        Request.post,
        data,
        isLoading,
        headers
    );
    return res;
  }

  Future<ResponseModel> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };
    String branch_id = branchId;
    String url = '${DataConstants.getProfile}/$branch_id/student/$studentId/profile';
    var res = await apiWrapper.makeRequest(url, Request.get, null, isLoading, headers);
    print("🔍 All Student List URL: $url");
    print("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }

  Future<ResponseModel> getFeesDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/fees/student/dashboard?student_id=$studentId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getTeacherDashboardAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/teacher/marks/dashboard';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ Fees Dashboard URL: $url");
    return res;
  }

Future<ResponseModel> getStaffProfileData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/profile';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getLateArrivalData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/attendance/late-arrivals?filter=$filter';

    print("🔍 Late Arrivals URL: $url");
    print("🔍 Filter: $filter");

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getLeaveStatusData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/attendance/leave?filter=$filter';

    print("🔍 Late Arrivals URL: $url");
    print("🔍 Filter: $filter");

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/student/dashboard/all-events?student_id=$studentId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ events Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getMyClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-classes';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ events Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getTermClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/classes';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ term Dashboard URL: $url");
    return res;
  }
  Future<ResponseModel> getExamGroupData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/examination-groups';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ term Dashboard URL: $url");
    return res;
  }

 Future<ResponseModel> getTermSectionData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/sections?class_id=$classId';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ term section Dashboard URL: $url");
    return res;
  }

Future<ResponseModel> getExamTermData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/examination-terms?examination_group_id=$examinationGroupId';    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ term section Dashboard URL: $url");
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
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/students?'
        'examination_group_id=$examinationGroupId'
        '&examination_term_id=$examinationTermId'
        '&class_id=$classId'
        '&section_id=$sectionId';

    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    print("✅ Term Attendance Students URL: $url");
    print("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }

  Future<ResponseModel> getInvoiceDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String invoiceId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/fees/invoice/$invoiceId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ invoice Dashboard URL: $url");
    return res;
  }
  Future<ResponseModel> getMyClassDetailsData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-classes/$classId/details?section_id=$sectionId&class_id=$classId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ invoice Dashboard URL: $url");
    return res;
  }

Future<ResponseModel> getStudentListData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/attendance/students?attendance_date=$date&class_id=$classId&section_id=$sectionId';    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ invoice Dashboard URL: $url");
    print("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }
  Future<ResponseModel> fetchClassAttendanceReport({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/class-attendance/report?class_id=$classId&section_id=$sectionId&month=$date';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ invoice Dashboard URL: $url");
    print("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }

// ConnectHelper mein ye method add karo

  Future<ResponseModel> getAllStudentList({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Add classId and sectionId to the path
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-students?class_id=$classId&section_id=$sectionId';
    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    print("🔍 All Student List URL: $url");
    print("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }

  Future<ResponseModel> saveAttendance({
  required bool isLoading,
  required String token,
  required String branchId,
  required Map<String, dynamic> payload,
  }) async {
  var headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
  };

  String url = 'https://demo.aitsolutions.in/api/$branchId/mobile/teacher/class-attendance';
  String jsonPayload = jsonEncode(payload);

  print("✅ Save Attendance URL: $url");
  print("✅ Save Attendance Payload: $jsonPayload");

  try {
  var response = await Dio().post(
  url,
  data: jsonPayload,
  options: Options(headers: headers),
  );

  print("✅ Save Attendance Response: ${response.data}");
  print("✅ Status Code: ${response.statusCode}");
  print("📤📤📤 RETURNING FROM PRESENTER - SUCCESS");

  return ResponseModel(
  data: response.data,
  hasError: false,
  errorCode: null,
  );
  } catch (e) {
  print("❌ Error: $e");
  print("📤📤📤 RETURNING FROM PRESENTER - ERROR");

  return ResponseModel(
  data: e.toString(),
  hasError: true,
  errorCode: 500,
  );
  }
  }

  Future<ResponseModel> updateAttendance({
  required bool isLoading,
  required String token,
  required String branchId,
  required Map<String, dynamic> payload,
  }) async {
  var headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
  };

  String url = 'https://demo.aitsolutions.in/api/$branchId/mobile/teacher/class-attendance';
  String jsonPayload = jsonEncode(payload);

  print("✅ Save Attendance URL: $url");
  print("✅ Save Attendance Payload: $jsonPayload");

  try {
  var response = await Dio().put(
  url,
  data: jsonPayload,
  options: Options(headers: headers),
  );

  print("✅ Save Attendance Response: ${response.data}");
  print("✅ Status Code: ${response.statusCode}");
  print("📤📤📤 RETURNING FROM PRESENTER - SUCCESS");

  return ResponseModel(
  data: response.data,
  hasError: false,
  errorCode: null,
  );
  } catch (e) {
  print("❌ Error: $e");
  print("📤📤📤 RETURNING FROM PRESENTER - ERROR");

  return ResponseModel(
  data: e.toString(),
  hasError: true,
  errorCode: 500,
  );
  }
  }

  Future<ResponseModel> getClassAttendance({
    required bool isLoading,
    required String token,
    required String attendanceDate,
    required String branchId,
    required String classId,
    required String sectionId,
    required int perPage,
    required int page,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // Method 2: Manual concatenation
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/class-attendance?attendance_date=$attendanceDate&class_id=$classId&section_id=$sectionId&per_page=$perPage&page=$page';    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers
    );

    print("✅ invoice Dashboard URL: $url");
    return res;
  }
  Future<ResponseModel> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    String url = 'https://demo.aitsolutions.in/api/$branchId/mobile/teacher/term-attendance';
    String jsonPayload = jsonEncode(payload);

    try {
      var response = await Dio().post(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );
      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      return ResponseModel(
        data: e.toString(),
        hasError: true,
        errorCode: 500,
      );
    }
  }
  Future<ResponseModel> logoutAPI({
    required bool isLoading,
    required String? token,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };
    var res = await apiWrapper.makeRequest(DataConstants.logout, Request.post, null, isLoading, headers);
    print("✅ Profile url---: ${res}");
    return res;
  }
}
