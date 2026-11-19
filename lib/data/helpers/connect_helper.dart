// coverage:ignore-file
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
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
        required String password}) async {
    var data = {
      'login': loginName,
      'password': password,
      'branch_code': branchCode,
    };
    debugPrint("Login responsedata---: $data");
    var res = await apiWrapper.makeRequest(DataConstants.login, Request.post,
        data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> forgotPasswordAPI(
      {required bool isLoading,
        required String branchCode,
        required String login}) async {
    var data = {
      'login': login,
      'branch_code': branchCode,
    };
    debugPrint("Forgot password response--data---: $data");
    var res = await apiWrapper.makeRequest(DataConstants.forgotPassword,
        Request.post, data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }
  Future<ResponseModel> getClassmatesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/student/$studentId/classmates';

    var res = await apiWrapper.makeRequest(url, Request.get, null, isLoading, headers);

    // ✅ यह लाइन जोड़ें ताकि टर्मिनल में रिस्पॉन्स दिखे
    debugPrint("📦 CLASSMATES RAW RESPONSE: ${res.data}");

    return res;
  }
  Future<ResponseModel> getStudentNoticesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // ✅ नई Student Notices API
    String url = '${DataConstants.getProfile}/$branchId/student/$studentId/notices';

    var res = await apiWrapper.makeRequest(url, Request.get, null, isLoading, headers);

    debugPrint("✅ Student Notices URL: $url");
    debugPrint("📦 RAW RESPONSE: ${res.data}");
    return res;
  }

  Future<ResponseModel> sendDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
    required String branchId,
    required String token,
  }) async {
    var data = {
      'branch_code': branchCode,
      'username': username,
    };
    String url = '${DataConstants.getProfile}/$branchId/delete-account/send-otp';


    var res = await apiWrapper.makeRequest(
      url,
      Request.post,
      data,
      isLoading,
      {
        'Content-type': 'Application/json',
        'Authorization': 'Bearer $token',   // ✅ TOKEN HEADER
      },
    );

    debugPrint("════════ SEND OTP API ════════");
    debugPrint("BODY      : $data");
    debugPrint("TOKEN     : ${token.isNotEmpty ? '${token.substring(0, 20)}...' : 'EMPTY'}");
    debugPrint("RAW DATA  : ${res.data}");
    debugPrint("HAS ERROR : ${res.hasError}");
    debugPrint("ERR CODE  : ${res.errorCode}");
    debugPrint("DATA TYPE : ${res.data.runtimeType}");
    debugPrint("══════════════════════════════");

    return res;
  }

  Future<ResponseModel> verifyDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
    required String otp,
    required String branchId,
    required String token,
  }) async {
    var data = {
      'branch_code': branchCode,
      'username': username,
      'otp': otp,
    };

    var res = await apiWrapper.makeRequest(
      '/api/$branchId/delete-account/verify-otp',
      Request.post,
      data,
      isLoading,
      {
        'Content-type': 'Application/json',
        'Authorization': 'Bearer $token',   // ✅ TOKEN HEADER
      },
    );

    debugPrint("════════ VERIFY OTP API ════════");
    debugPrint("URL       : /api/$branchId/delete-account/verify-otp");
    debugPrint("BODY      : $data");
    debugPrint("TOKEN     : ${token.isNotEmpty ? '${token.substring(0, 20)}...' : 'EMPTY'}");
    debugPrint("RAW DATA  : ${res.data}");
    debugPrint("HAS ERROR : ${res.hasError}");
    debugPrint("ERR CODE  : ${res.errorCode}");
    debugPrint("════════════════════════════════");

    return res;
  }

  Future<ResponseModel> resendOtpAPI(
      {required bool isLoading,
        required String branchCode,
        required String login}) async {
    var data = {
      'login': login,
      'branch_code': branchCode,
    };
    var res = await apiWrapper.makeRequest(DataConstants.resendOtp, Request.post,
        data, isLoading, {'Content-type': 'Application/json'});
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

    var headers = {
      'Content-type': 'Application/json',
    };

    var res = await apiWrapper.makeRequest(
        DataConstants.verifyOtp,
        Request.post,
        data,
        isLoading,
        headers);
    return res;
  }

  // ========== SUBMIT LEAVE APPLICATION (FIXED) ==========
  Future<ResponseModel> submitLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    required File? attachment, required String studentId,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };

    // ✅ FULL URL with host
    String url = 'https://decentgroupofschools.com/api/$branchId/student/$studentId/leaves';

    var formData = dio_package.FormData.fromMap({
      'leave_type': leaveType,
      'from_date': fromDate,
      'to_date': toDate,
      'leave_reason': reason,
      if (attachment != null)
        'attachment': await dio_package.MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        ),
    });

    try {
      var response = await dio.post(
        url,
        data: formData,
        options: dio_package.Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );
      print("✅ Submit Leave Response Status: ${response.statusCode}");
      print("✅ Submit Leave Response Data: ${response.data}");
      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      print("❌ Submit Leave Error: $e");
      // ✅ Handle DioException with structured response (e.g., 409)
      if (e is DioException && e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;
        // If the server returned a JSON response with 'status' and 'message',
        // treat it as a valid response (not a network error)
        if (responseData is Map<String, dynamic>) {
          print("📦 Server error response: $responseData");
          return ResponseModel(
            data: responseData,
            hasError: false, // Important: treat as a valid response
            errorCode: e.response?.statusCode,
          );
        }
      }
      // Real network error (no response from server)
      return ResponseModel(
        data: e.toString(),
        hasError: true,
        errorCode: 500,
      );
    }
  }
// ========== SUBMIT LEAVE APPLICATION (FIXED) ==========
  Future<ResponseModel> submitStaffLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    required File? attachment,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };

    // ✅ FULL URL with host

    String url = 'https://decentgroupofschools.com/api/$branchId/mobile/teacher/staff-leaves';
    var formData = dio_package.FormData.fromMap({
      'leave_type': leaveType,
      'from_date': fromDate,
      'to_date': toDate,
      'leave_reason': reason,
      if (attachment != null)
        'attachment': await dio_package.MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        ),
    });

    try {
      var response = await dio.post(
        url,
        data: formData,
        options: dio_package.Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );
      print("✅ Submit Staff Leave Response Status: ${response.statusCode}");
      print("✅ Submit Staff Leave Response Data: ${response.data}");
      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      print("❌ Submit Staff Leave Error: $e");
      // ✅ Handle DioException with structured response (e.g., 409)
      if (e is DioException && e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;
        // If the server returned a JSON response with 'status' and 'message',
        // treat it as a valid response (not a network error)
        if (responseData is Map<String, dynamic>) {
          print("📦 Server error response: $responseData");
          return ResponseModel(
            data: responseData,
            hasError: false, // Important: treat as a valid response
            errorCode: e.response?.statusCode,
          );
        }
      }
      // Real network error (no response from server)
      return ResponseModel(
        data: e.toString(),
        hasError: true,
        errorCode: 500,
      );
    }
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

    var headers = {
      'Content-type': 'Application/json',
    };

    var res = await apiWrapper.makeRequest(
        DataConstants.resetPassword,
        Request.post,
        data,
        isLoading,
        headers);
    return res;
  }

  Future<ResponseModel> changePasswordAPI({
    required bool isLoading,
    required String branchId,
    required String token,
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {

    final String url = '${DataConstants.getProfile}/$branchId/change-password';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      'current_password': oldPassword,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    };

    var res = await apiWrapper.makeRequest(
      url,
      Request.post,
      body,
      isLoading,
      headers,
    );
    return res;
  }

  Future<ResponseModel?> resetStaffPassword({
    required bool isLoading,
    required String currentPassword,
    required String branchId,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final String url = '${DataConstants.getProfile}/$branchId/mobile/reset-password';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': passwordConfirmation,
    };

    var res = await apiWrapper.makeRequest(
      url,
      Request.post,
      body,
      isLoading,
      headers,
    );
    return res;
  }
  Future<ResponseModel> getStaffAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String month,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // ✅ आपके द्वारा दी गई नई Teacher API URL
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-attendance?month=$month';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Staff Attendance Record URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }
  Future<ResponseModel> getStudentDocumentsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };
    String url = '${DataConstants.getProfile}/$branchId/student/$studentId/profile/documents';
    var res = await apiWrapper.makeRequest(url, Request.get, null, isLoading, headers);
    debugPrint("✅ Student Documents URL: $url");
    return res;
  }
  Future<ResponseModel> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };
    String branch_id = branchId;
    String url = '${DataConstants.getProfile}/$branch_id/student/$studentId/profile';
    var res = await apiWrapper.makeRequest(url, Request.get, null, isLoading, headers);
    debugPrint("🔍 All Student List URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }
  Future<ResponseModel> getAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required String month,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // ✅ आपके द्वारा दी गई API के अनुसार URL
    String url = '${DataConstants.getProfile}/$branchId/student/$studentId/attendance?month=$month';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Student Attendance Record URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
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

    String url = '${DataConstants.getProfile}/$branchId/fees/student/dashboard?student_id=$studentId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getStaffAnnouncementDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String tab,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    // ✅ URL बनाना
    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/notices?tab=$tab';

    // =========================================================
    // ✅ 1. API हिट होने से पहले का लॉग
    // =========================================================
    debugPrint("════════════════════════════════════════════════");
    debugPrint("🚀 STAFF ANNOUNCEMENT API CALL STARTED");
    debugPrint("🔗 URL: $url");
    debugPrint("🎫 TOKEN: ${token.length > 20 ? token.substring(0, 20) + '...' : token}");
    debugPrint("════════════════════════════════════════════════");

    try {
      // ✅ 2. API कॉल
      var res = await apiWrapper.makeRequest(url, Request.get, null, isLoading, headers);

      // =========================================================
      // ✅ 3. API से रिस्पॉन्स आने के बाद का लॉग
      // =========================================================
      debugPrint("════════════════════════════════════════════════");
      debugPrint("✅ STAFF ANNOUNCEMENT API RESPONSE RECEIVED");
      debugPrint("📥 RAW DATA: ${res.data}");
      debugPrint("❌ HAS ERROR: ${res.hasError}");
      debugPrint("🔢 ERROR CODE: ${res.errorCode}");
      debugPrint("════════════════════════════════════════════════");

      return res;

    } catch (e, stackTrace) {
      // =========================================================
      // ✅ 4. अगर कोई एक्सेप्शन (Error) आता है तो उसका लॉग
      // =========================================================
      debugPrint("════════════════════════════════════════════════");
      debugPrint("💥 EXCEPTION OCCURRED IN API CALL");
      debugPrint("⚠️ ERROR: $e");
      debugPrint("📍 STACKTRACE: $stackTrace");
      debugPrint("════════════════════════════════════════════════");

      // Fallback Return (ताकि ऐप क्रैश न हो)
      return ResponseModel(
        data: {'message': 'Something went wrong: $e'},
        hasError: true,
        errorCode: 500,
      );
    }
  }

  Future<ResponseModel> getAnnouncementDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/student/dashboard/announcements';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/teacher/marks/dashboard';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getLeaveApprovalStatusAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/staff-leaves';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);
    debugPrint("✅ Fees Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/profile';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/attendance/late-arrivals?filter=$filter';

    debugPrint("🔍 Late Arrivals URL: $url");
    debugPrint("🔍 Filter: $filter");

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getLeaveBalanceAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/staff-leaves/balance';

    debugPrint("🔍 Late Arrivals URL: $url");

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getSchoolInfo({
    required bool isLoading,
    required String branchCode, // new parameter
  }) async {
    var headers = {
      'Content-type': 'Application/json',
    };

    // Append branch_code as query parameter
    String url = '${DataConstants.getProfile}/branch/school-info?branch_code=$branchCode';

    debugPrint("🔍 School Info URL: $url");

    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    debugPrint("✅ School Dashboard URL: $url");
    debugPrint("✅ School Dashboard URL: $res");
    return res;
  }

  Future<ResponseModel> getBranchInfo({
    required bool isLoading,
    required String branchCode,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
    };

    // ✅ 1. URL change kiya (school-info -> verify-code, aur query param hataya)
    String url = '${DataConstants.getProfile}/branch/verify-code';

    // ✅ 2. POST body create ki (branch_code ko JSON me bhejne ke liye)
    var data = {
      'branch_code': branchCode,
    };

    debugPrint("🔍 Verify Branch Code URL: $url");
    debugPrint("📦 Verify Branch Code Body: $data");

    // ✅ 3. Body (data) ko null ki jagah pass kiya
    var res = await apiWrapper.makeRequest(
      url,
      Request.post,
      data,
      isLoading,
      headers,
    );

    debugPrint("✅ Verify Branch Code Response: ${res.data}");
    return res;
  }
  // ============================================================
  // ✅ NEW: Co-Curricular Marks API
  // ============================================================
  Future<ResponseModel> getCoCurricularMarks({
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

    String url = '${DataConstants.getProfile}/$branchId/examination/cocurricular-marks?'
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

    debugPrint("✅ CoCurricular Marks URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/attendance/leave?filter=$filter';

    debugPrint("🔍 Late Arrivals URL: $url");
    debugPrint("🔍 Filter: $filter");

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ Fees Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getLeaveHistory({
    required bool isLoading,
    required String token,
    required String branchId,
    required String staffId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/staff-leaves/$staffId/history';

    debugPrint("🔍 Leave History URL: $url");

    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    debugPrint("✅ Leave History Response: ${res.data}");
    return res;
  }

  // Future<ResponseModel> getAllEvents({
  //   required bool isLoading,
  //   required String token,
  //   required String branchId,
  //   required String studentId,
  // }) async {
  //   var headers = {
  //     'Content-type': 'Application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  //
  //   String url = '${DataConstants.getProfile}/$branchId/student/dashboard/all-events?student_id=$studentId';
  //
  //   var res = await apiWrapper.makeRequest(
  //       url,
  //       Request.get,
  //       null,
  //       isLoading,
  //       headers);
  //
  //   debugPrint("✅ events Dashboard URL: $url");
  //   return res;
  // }

  Future<ResponseModel> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',   // ← check karo Authorization header
    };

    final endpoint = '/api/$branchId/student/dashboard/all-events?student_id=$studentId';

    // ✅ Log before API call
    debugPrint("════════════════════════════════════════════════");
    debugPrint("🌐 API CALL getAllEvents");
    debugPrint("   endpoint: $endpoint");
    debugPrint("   headers: $headers");
    debugPrint("════════════════════════════════════════════════");

    var res = await apiWrapper.makeRequest(
      endpoint,
      Request.get,
      null,
      isLoading,
      headers,
    );

    // ✅ Log after API call
    debugPrint("════════════════════════════════════════════════");
    debugPrint("🌐 API RESPONSE getAllEvents");
    debugPrint("   data: ${res.data}");
    debugPrint("   hasError: ${res.hasError}");
    debugPrint("════════════════════════════════════════════════");

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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-classes';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ events Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/classes';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ term Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/examination-groups';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ term Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/sections?class_id=$classId';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ term section Dashboard URL: $url");
    return res;
  }

  Future<ResponseModel> getSubjectData({
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

    final url = '${DataConstants.getProfile}/$branchId/mobile/teacher/examination/subjects?class_id=$classId&section_id=$sectionId';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ term section Dashboard URL: $url");
    return res;
  }

 Future<ResponseModel> getStudentFeeList({
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

    final url = '${DataConstants.getProfile}/$branchId/fees/students?class_id=$classId&section_id=$sectionId';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ student fee section Dashboard URL: $url");
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
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/teacher/marks?'
        'examination_group_id=$examinationGroupId'
        '&examination_term_id=$examinationTermId'
        '&class_id=$classId'
        '&section_id=$sectionId'
        '&subject_id=$subjectId'
        '&mark_type=$markType'
        '&internal_count=$internalCount';

    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    debugPrint("✅ External Marks URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
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
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/teacher/marks?'
        'examination_group_id=$examinationGroupId'
        '&examination_term_id=$examinationTermId'
        '&class_id=$classId'
        '&section_id=$sectionId'
        '&subject_id=$subjectId'
        '&mark_type=$markType';

    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    debugPrint("✅ Internal Marks URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }
  // ============================================================
  Future<ResponseModel> saveCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String url =
        'https://decentgroupofschools.com/api/$branchId/examination/cocurricular-marks';
    String jsonPayload = jsonEncode(payload);

    debugPrint("✅ Save CoCurricular Marks URL: $url");
    debugPrint("✅ Save CoCurricular Marks Payload: $jsonPayload");

    try {
      var response = await Dio().post(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );

      debugPrint("✅ Save CoCurricular Response: ${response.data}");
      debugPrint("✅ Status Code: ${response.statusCode}");

      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      debugPrint("❌ Error saving co-curricular marks: $e");

      if (e is DioException && e.response != null && e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          return ResponseModel(
            data: responseData,
            hasError: false,
            errorCode: e.response?.statusCode,
          );
        }
      }

      return ResponseModel(
        data: <String, dynamic>{
          'status': false,
          'message': e.toString(),
        },
        hasError: true,
        errorCode: 500,
      );
    }
  }
  Future<ResponseModel> saveExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String url = 'https://decentgroupofschools.com/api/$branchId/teacher/marks';
    String jsonPayload = jsonEncode(payload);

    debugPrint("✅ Save External Marks URL: $url");
    debugPrint("✅ Save External Marks Payload: $jsonPayload");

    try {
      var response = await Dio().post(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );

      debugPrint("✅ Save External Marks Response: ${response.data}");
      debugPrint("✅ Status Code: ${response.statusCode}");

      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      debugPrint("❌ Error saving external marks: $e");
      return ResponseModel(
        data: e.toString(),
        hasError: true,
        errorCode: 500,
      );
    }
  }

  Future<ResponseModel> saveInternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String url = 'https://decentgroupofschools.com/api/$branchId/teacher/marks';
    String jsonPayload = jsonEncode(payload);

    debugPrint("✅ Save External Marks URL: $url");
    debugPrint("✅ Save External Marks Payload: $jsonPayload");

    try {
      var response = await Dio().post(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );

      debugPrint("✅ Save External Marks Response: ${response.data}");
      debugPrint("✅ Status Code: ${response.statusCode}");

      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      debugPrint("❌ Error saving external marks: $e");
      return ResponseModel(
        data: e.toString(),
        hasError: true,
        errorCode: 500,
      );
    }
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/term-attendance/examination-terms?examination_group_id=$examinationGroupId';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ term section Dashboard URL: $url");
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

    debugPrint("✅ Term Attendance Students URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
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
    var headers = {
      'Content-type': 'Application/json',
      'Authorization': 'Bearer $token',
    };

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/examination/datesheet?'
        'examination_group_id=$examinationGroupId'
        '&examination_term_id=$examinationTermId'
        '&class_id=$classId';

    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    debugPrint("✅ exam schedule Attendance Students URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
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

    String url = '${DataConstants.getProfile}/$branchId/fees/invoice/$invoiceId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ invoice Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-classes/$classId/details?section_id=$sectionId&class_id=$classId';

    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ invoice Dashboard URL: $url");
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/attendance/students?attendance_date=$date&class_id=$classId&section_id=$sectionId';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ invoice Dashboard URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }
  // ============================================================
  // ✅ CREATE PAYMENT ORDER — POST with body
  // ============================================================
  Future<ResponseModel> createPaymentOrder({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required List<String> invoiceIds,
    required double amount,
    required String sessionId,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String url =
        'https://decentgroupofschools.com/api/$branchId/fees/student/$studentId/payment/create-order';

    // ✅ Request body — exact जो backend चाहता है
    final Map<String, dynamic> body = {
      'amount': amount.toInt(),
      'invoice_ids': invoiceIds,
      'session_id': sessionId,
      'platform': 'mobile',
    };
    final String jsonPayload = jsonEncode(body);

    debugPrint("════════════════════════════════════════════════");
    debugPrint("💳 CREATE PAYMENT ORDER — REQUEST");
    debugPrint("   URL:  $url");
    debugPrint("   BODY: $jsonPayload");
    debugPrint("════════════════════════════════════════════════");

    try {
      var response = await Dio().post(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );

      debugPrint("════════════════════════════════════════════════");
      debugPrint("✅ CREATE PAYMENT ORDER — SUCCESS");
      debugPrint("   Status: ${response.statusCode}");
      debugPrint("   Data: ${response.data}");
      debugPrint("════════════════════════════════════════════════");

      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      debugPrint("════════════════════════════════════════════════");
      debugPrint("❌ CREATE PAYMENT ORDER — ERROR");
      debugPrint("   Exception: $e");
      debugPrint("════════════════════════════════════════════════");

      if (e is DioException && e.response != null) {
        dynamic responseData = e.response!.data;

        if (responseData is String) {
          try {
            responseData = jsonDecode(responseData);
          } catch (_) {}
        }

        debugPrint("📦 SERVER RESPONSE (status ${e.response?.statusCode})");
        debugPrint("   $responseData");

        if (responseData is Map<String, dynamic>) {
          return ResponseModel(
            data: responseData,
            hasError: false,
            errorCode: e.response?.statusCode,
          );
        }
      }

      return ResponseModel(
        data: <String, dynamic>{
          'status': false,
          'message': e.toString(),
        },
        hasError: true,
        errorCode: 500,
      );
    }
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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/class-attendance/report?class_id=$classId&section_id=$sectionId&month=$date';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ invoice Dashboard URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
    return res;
  }

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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/my-students?class_id=$classId&section_id=$sectionId';
    var res = await apiWrapper.makeRequest(
      url,
      Request.get,
      null,
      isLoading,
      headers,
    );

    debugPrint("🔍 All Student List URL: $url");
    debugPrint("📦 RAW RESPONSE DATA: ${res.data}");
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

    String url = 'https://decentgroupofschools.com/api/$branchId/mobile/teacher/class-attendance';
    String jsonPayload = jsonEncode(payload);

    debugPrint("✅ Save Attendance URL: $url");
    debugPrint("✅ Save Attendance Payload: $jsonPayload");

    try {
      var response = await Dio().post(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );

      debugPrint("✅ Save Attendance Response: ${response.data}");
      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("📤📤📤 RETURNING FROM PRESENTER - SUCCESS");

      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      debugPrint("❌ Error: $e");
      debugPrint("📤📤📤 RETURNING FROM PRESENTER - ERROR");

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

    String url = 'https://decentgroupofschools.comn/api/$branchId/mobile/teacher/class-attendance';
    String jsonPayload = jsonEncode(payload);

    debugPrint("✅ Save Attendance URL: $url");
    debugPrint("✅ Save Attendance Payload: $jsonPayload");

    try {
      var response = await Dio().put(
        url,
        data: jsonPayload,
        options: Options(headers: headers),
      );

      debugPrint("✅ Save Attendance Response: ${response.data}");
      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("📤📤📤 RETURNING FROM PRESENTER - SUCCESS");

      return ResponseModel(
        data: response.data,
        hasError: false,
        errorCode: null,
      );
    } catch (e) {
      debugPrint("❌ Error: $e");
      debugPrint("📤📤📤 RETURNING FROM PRESENTER - ERROR");

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

    String url = '${DataConstants.getProfile}/$branchId/mobile/teacher/class-attendance?attendance_date=$attendanceDate&class_id=$classId&section_id=$sectionId&per_page=$perPage&page=$page';
    var res = await apiWrapper.makeRequest(
        url,
        Request.get,
        null,
        isLoading,
        headers);

    debugPrint("✅ invoice Dashboard URL: $url");
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
    String url = 'https://decentgroupofschools.com/api/$branchId/mobile/teacher/term-attendance';
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
    return res;
  }
}