// coverage:ignore-file
import 'dart:io';
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
    print("✅ Profile url---: ${url}");
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
