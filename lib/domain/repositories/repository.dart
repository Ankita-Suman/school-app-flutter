import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/data/data.dart';
import 'package:school_app/device/device.dart';
import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/models/invoice_response.dart';
import 'package:school_app/domain/models/profile_response.dart';

import '../models/attendance_response.dart';
import '../models/branch_verify_response.dart';
import '../models/class_attendance_response.dart';
import '../models/co_curricular_marks_response.dart';
import '../models/delete_account_response.dart';
import '../models/document_response.dart';
import '../models/events_response.dart';
import '../models/forgot_password_model.dart';
import '../models/get_student_attendance_response.dart';
import '../models/my_classmates_response.dart';
import '../models/payment_order_response.dart';
import '../models/staff_attendance_response.dart';
import '../models/student_notice_response.dart';
import '../models/term_attendance_student_response.dart';

/// The main repository which will get the data from [DeviceRepository] or the
/// [DataRepository].
class Repository {
  /// [_deviceRepository] : the local repository.
  /// [_dataRepository] : the data repository like api and all.
  Repository(this._deviceRepository, this._dataRepository);

  final DeviceRepository _deviceRepository;
  final DataRepository _dataRepository;

  /// Clear data from local storage for [key].
  void clearData(dynamic key) {
    try {
      _deviceRepository.clearData(
        key,
      );
    } catch (_) {
      _dataRepository.clearData(
        key,
      );
    }
  }

  /// Get the string value for the [key].
  ///
  /// [key] : The key whose value is needed.
  String getStringValue(String key) {
    try {
      return _deviceRepository.getStringValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getStringValue(
        key,
      );
    }
  }

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved.
  /// [value] : The value which needs to be saved.
  void saveValue(dynamic key, dynamic value) {
    try {
      _deviceRepository.saveValue(
        key,
        value,
      );
    } catch (_) {
      _dataRepository.saveValue(
        key,
        value,
      );
    }
  }

  /// Get the bool value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getBoolValue(String key) {
    try {
      return _deviceRepository.getBoolValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getBoolValue(
        key,
      );
    }
  }

  /// Get the stored value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getStoredValue(String key) {
    try {
      return _deviceRepository.getBoolValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getBoolValue(
        key,
      );
    }
  }

  /// Get the secure value for the [key].
  /// [key] : The key whose value is needed.
  Future<String> getSecureValue(String key) {
    try {
      return _deviceRepository.getSecuredValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getSecuredValue(
        key,
      );
    }
  }

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved.
  /// [value] : The value which needs to be saved.
  void saveSecureValue(String key, String value) async {
    try {
      _deviceRepository.saveValueSecurely(
        key,
        value,
      );
    } catch (_) {
      _dataRepository.saveValueSecurely(
        key,
        value,
      );
    }
  }

  /// Clear data from secure storage for [key].
  void deleteSecuredValue(String key) {
    try {
      _deviceRepository.deleteSecuredValue(
        key,
      );
    } catch (_) {
      _dataRepository.deleteSecuredValue(
        key,
      );
    }
  }

  /// Clear all data from secure storage .
  void deleteAllSecuredValues() {
    try {
      _deviceRepository.deleteAllSecuredValues();
    } catch (_) {
      _dataRepository.deleteAllSecuredValues();
    }
  }

  // Future<String?> uploadImage({
  //   required bool isLoading,
  //   required String signedUploadUrl,
  //   required File image,
  // }) async {
  //   try {
  //     await _dataRepository.uploadImage(
  //         isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
  //     //if (!res.hasError) {
  //     final uri = Uri.tryParse(signedUploadUrl);
  //     if (uri == null) {
  //       Utility.closeDialog();
  //       await Utility.showAlertInfoDialog(
  //           message: 'Could not parse S3 uploadURL',
  //           title: 'Info',
  //           onPress: () {
  //             Get.back<dynamic>();
  //           });
  //     }
  //
  //     return uri?.pathSegments.last;
  //     // } else {
  //     //   //Utility.showInfoDialog(res);
  //     //   return null;
  //     // }
  //   } catch (e) {
  //     await _deviceRepository.uploadImage(
  //         isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
  //     return null;
  //   }
  // }

  Future<LoginResponse?> loginApi(
      {required bool isLoading, required String loginName,
        required String password,
        required String branchCode}) async {
    try {
      var res = await _dataRepository.loginApi(isLoading: isLoading, loginName: loginName, password: password, branchCode: branchCode, );
      if (!res.hasError) {
        var data = loginResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.loginApi(isLoading: isLoading, loginName: loginName, password: password,branchCode: branchCode);
      return null;
    }
  }

  Future<ForgotPasswordResponse?> forgotPasswordAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
  }) async {
    try {
      var res = await _dataRepository.forgotPasswordAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      if (!res.hasError) {
        var data = forgotPasswordResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.forgotPasswordAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      return null;
    }
  }
  Future<ClassmatesResponse?> getClassmatesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    try {
      var res = await _dataRepository.getClassmatesAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );

      if (!res.hasError && res.data != null) {
        // ✅ सबसे बड़ा फिक्स: चेक करें कि डेटा Map है या String
        if (res.data is Map<String, dynamic>) {
          return ClassmatesResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return ClassmatesResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        // Utility.showInfoDialog(res); // इसे हटा दें ताकि ऐप क्रैश न हो
        debugPrint("⚠️ API Error in getClassmatesAPI: ${res.data}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ getClassmatesAPI Exception: $e");
      // fallback call हटा दें ताकि अनचाहे एरर न आएं
      return null;
    }
  }

  Future<ResponseModel?> getStaffAnnouncementDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    String? tab, // 'my' या 'other' (Student केस के लिए null भी हो सकता है)
  }) async {
    try {
      var res = await _dataRepository.getStaffAnnouncementDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        tab: tab ?? 'my', // अगर null है तो डिफ़ॉल्ट 'my' भेजें
      );
      if (!res.hasError && res.data != null) {
        return res; // ✅ Raw ResponseModel रिटर्न कर रहे हैं ताकि कंट्रोलर पार्स कर सके
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getStaffAnnouncementDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        tab: tab ?? 'my',
      );
      return null;
    }
  }

  Future<ForgotPasswordResponse?> resendOtpAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
  }) async {
    try {
      var res = await _dataRepository.resendOtpAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      if (!res.hasError) {
        var data = forgotPasswordResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.resendOtpAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      return null;
    }
  }

  Future<OtpVerifyResponse?> verifyOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async {
    try {
      var res = await _dataRepository.verifyOtpAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        otp: otp,
      );
      if (!res.hasError) {
        var data = otpVerifyResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.verifyOtpAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        otp: otp,
      );
      return null;
    }
  }

 Future<ResetPasswordResponse?> resetPasswordAPI({
   required bool isLoading,
   required String login,
   required String branchCode,
   required String token,
   required String newPassword,
   required String passwordConfirmation,
  }) async {
    try {
      var res = await _dataRepository.resetPasswordAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      if (!res.hasError) {
        var data = resetResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.resetPasswordAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      return null;
    }
  }

  Future<ResetPasswordResponse?> changePasswordAPI({
   required bool isLoading,
    required String branchId,
    required String token,
   required String oldPassword,
   required String newPassword,
   required String passwordConfirmation,
  }) async {
    try {
      var res = await _dataRepository.changePasswordAPI(
        isLoading: isLoading,
        branchId: branchId,
        token: token,
        oldPassword: oldPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      if (!res.hasError) {
        var data = resetResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.changePasswordAPI(
        isLoading: isLoading,
        branchId: branchId,
        token: token,
        oldPassword: oldPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      return null;
    }
  }
  Future<LeaveRequestSubmitResponse?> submitLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    required File? attachment, required String studentId,
  }) async {
    try {
      var res = await _dataRepository.submitLeaveApplication(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        leaveType: leaveType,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
        attachment: attachment,
      );
      if (!res.hasError && res.data != null) {
        try {
          // Handle both Map and String responses
          if (res.data is Map<String, dynamic>) {
            return LeaveRequestSubmitResponse.fromJson(res.data as Map<String, dynamic>);
          } else if (res.data is String) {
            return LeaveRequestSubmitResponse.fromJson(jsonDecode(res.data));
          } else {
            return null;
          }
        } catch (e) {
          return null; // JSON parse error – just return null
        }
      } else {
        // ❌ Do NOT call Utility.showInfoDialog(res) here – it crashes on non‑JSON
        return null;
      }
    } catch (e) {
      await _deviceRepository.submitLeaveApplication(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        leaveType: leaveType,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
        attachment: attachment,
      );
      return null;
    }
  }

  Future<LeaveRequestSubmitResponse?> submitStaffLeaveApplication({
    required bool isLoading,
    required String token,
    required String branchId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    required File? attachment,
  }) async {
    try {
      var res = await _dataRepository.submitStaffLeaveApplication(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        leaveType: leaveType,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
        attachment: attachment,
      );
      if (!res.hasError && res.data != null) {
        try {
          // Handle both Map and String responses
          if (res.data is Map<String, dynamic>) {
            return LeaveRequestSubmitResponse.fromJson(res.data as Map<String, dynamic>);
          } else if (res.data is String) {
            return LeaveRequestSubmitResponse.fromJson(jsonDecode(res.data));
          } else {
            return null;
          }
        } catch (e) {
          return null; // JSON parse error – just return null
        }
      } else {
        // ❌ Do NOT call Utility.showInfoDialog(res) here – it crashes on non‑JSON
        return null;
      }
    } catch (e) {
      await _deviceRepository.submitStaffLeaveApplication(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        leaveType: leaveType,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
        attachment: attachment,
      );
      return null;
    }
  }

 Future<StaffResetPasswordResponse?> resetStaffPassword({
   required bool isLoading,
   required String currentPassword,
   required String branchId,
   required String token,
   required String newPassword,
   required String passwordConfirmation,
  }) async {
    try {
      var res = await _dataRepository.resetStaffPassword(
        isLoading: isLoading,
        currentPassword: currentPassword,
        branchId: branchId,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      if (!res!.hasError && res.data != null) {
        var data = resetPasswordResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.resetStaffPassword(
        isLoading: isLoading,
        currentPassword: currentPassword,
        branchId: branchId,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      return null;
    }
  }
  Future<StaffAttendanceResponse?> getStaffAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String month,
  }) async {
    try {
      var res = await _dataRepository.getStaffAttendanceRecordAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        month: month,
      );
      if (!res.hasError && res.data != null) {
        // ✅ Map और String दोनों रिस्पॉन्स को हैंडल करें
        if (res.data is Map<String, dynamic>) {
          return StaffAttendanceResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return StaffAttendanceResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getStaffAttendanceRecordAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        month: month,
      );
      return null;
    }
  }
  Future<ProfileResponse?> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    try {
      var res = await _dataRepository.getProfileDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      if (!res.hasError && res.data != null) {
        return profileResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getProfileDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      return null;
    }
  }
  Future<DocumentsResponse?> getStudentDocumentsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    try {
      var res = await _dataRepository.getStudentDocumentsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      if (!res.hasError && res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return DocumentsResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return DocumentsResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getStudentDocumentsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      return null;
    }
  }
  Future<FeeResponseModel?> getFeesDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    try {
      var res = await _dataRepository.getFeesDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      if (!res.hasError && res.data != null) {
        return feeResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getFeesDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      return null;
    }
  }
  Future<AttendanceResponse?> getAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required String month,
  }) async {
    try {
      var res = await _dataRepository.getAttendanceRecordAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        month: month,
      );
      if (!res.hasError && res.data != null) {
        // ✅ Handle both Map and String responses
        if (res.data is Map<String, dynamic>) {
          return AttendanceResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return AttendanceResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getAttendanceRecordAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        month: month,
      );
      return null;
    }
  }
  Future<StudentNoticeResponse?> getStudentNoticesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    try {
      var res = await _dataRepository.getStudentNoticesAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );

      if (!res.hasError && res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return StudentNoticeResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return StudentNoticeResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        debugPrint("⚠️ API Error in getStudentNoticesAPI: ${res.data}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ getStudentNoticesAPI Exception: $e");
      return null;
    }
  }

  Future<TeacherDashboardResponse?> getTeacherDashboardAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getTeacherDashboardAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return teacherDashboardResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getTeacherDashboardAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
      );
      return null;
    }
  }

Future<LeaveRequestsResponse?> getLeaveApprovalStatusAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getLeaveApprovalStatusAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return leaveRequestsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getLeaveApprovalStatusAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
      );
      return null;
    }
  }

Future<StaffProfileResponse?> getStaffProfileData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getStaffProfileData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return staffProfileResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getStaffProfileData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
      );
      return null;
    }
  }

 Future<LateArrivalsResponse?> getLateArrivalData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    try {
      var res = await _dataRepository.getLateArrivalData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        filter: filter,

      );
      if (!res.hasError && res.data != null) {
        return lateArrivalsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getLateArrivalData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        filter: filter,
      );
      return null;
    }
  }

Future<LeaveBalanceResponse?> getLeaveBalanceAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getLeaveBalanceAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return leaveBalanceResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getLeaveBalanceAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
      );
      return null;
    }
  }
  Future<SchoolInfoResponse?> getSchoolInfo({
    required bool isLoading, required String branchCode,

  }) async {
    try {
      var res = await _dataRepository.getSchoolInfo(
        isLoading: isLoading,
        branchCode: branchCode,

      );
      if (!res.hasError && res.data != null) {
        return schoolInfoResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getSchoolInfo(
        isLoading: isLoading,
        branchCode: branchCode,
      );
      return null;
    }
  }

  Future<BranchVerifyResponse?> getBranchInfo({
    required bool isLoading, required String branchCode,

  }) async {
    try {
      var res = await _dataRepository.getBranchInfo(
        isLoading: isLoading,
        branchCode: branchCode,

      );
      if (!res.hasError && res.data != null) {
        return branchInfoResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getBranchInfo(
        isLoading: isLoading,
        branchCode: branchCode,
      );
      return null;
    }
  }

  Future<LeaveApplicationsResponse?> getLeaveStatusData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    try {
      var res = await _dataRepository.getLeaveStatusData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        filter: filter,

      );
      if (!res.hasError && res.data != null) {
        return leaveApplicationsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getLeaveStatusData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        filter: filter,
      );
      return null;
    }
  }

Future<LeaveHistoryResponse?> getLeaveHistory({
    required bool isLoading,
    required String token,
    required String branchId,
    required String staffId,
  }) async {
    try {
      var res = await _dataRepository.getLeaveHistory(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        staffId: staffId,

      );
      if (!res.hasError && res.data != null) {
        return leaveHistoryResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getLeaveHistory(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        staffId: staffId,
      );
      return null;
    }
  }

  Future<EventsResponseModel?> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    try {
      var res = await _dataRepository.getAllEvents(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );

      debugPrint("📥 getAllEvents res.data: ${res.data}");
      debugPrint("📥 getAllEvents res.hasError: ${res.hasError}");

      if (!res.hasError && res.data != null) {
        return eventsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e, stackTrace) {
      // ================================================================
      // 💥 YAHAN LOGS — pata chalega exact kya error hai
      // ================================================================
      debugPrint("════════════════════════════════════════════════");
      debugPrint("💥 getAllEvents CATCH BLOCK");
      debugPrint("   Error: $e");
      debugPrint("   Error runtimeType: ${e.runtimeType}");
      debugPrint("   StackTrace:");
      debugPrint("$stackTrace");
      debugPrint("════════════════════════════════════════════════");

      // Fallback call
      await _deviceRepository.getAllEvents(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );
      return null;
    }
  }
  Future<TeacherClassesResponse?> getMyClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getMyClassData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return teacherClassesResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getMyClassData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      return null;
    }
  }

Future<TermClassResponse?> getTermClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getTermClassData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return termClassResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getTermClassData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      return null;
    }
  }

Future<ExaminationGroupResponse?> getExamGroupData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getExamGroupData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      if (!res.hasError && res.data != null) {
        return examinationGroupResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getExamGroupData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
      return null;
    }
  }

  Future<TermAttendanceStudentsResponse?> getTermAttendanceStudents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getTermAttendanceStudents(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
      if (!res.hasError && res.data != null) {
        return termAttendanceStudentsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getTermAttendanceStudents(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
      return null;
    }
  }
  Future<SaveExternalMarksResponse?> saveExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      var res = await _dataRepository.saveExternalMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      if (!res.hasError && res.data != null) {
        // ✅ Handle both Map and String responses
        if (res.data is Map<String, dynamic>) {
          return SaveExternalMarksResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return saveExternalMarksResponseFromJson(res.data as String);
        } else {
          return null;
        }
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.saveExternalMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      return null;
    }
  }
  // ============================================================
  // ✅ NEW: Save Co-Curricular Marks (FIXED — no crash on error)
  // ============================================================
  Future<SaveExternalMarksResponse?> saveCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      var res = await _dataRepository.saveCoCurricularMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (!res.hasError && res.data != null) {
        // ✅ Parse — Map या String दोनों handle करें
        try {
          if (res.data is Map<String, dynamic>) {
            return SaveExternalMarksResponse.fromJson(
                res.data as Map<String, dynamic>);
          } else if (res.data is String) {
            return saveExternalMarksResponseFromJson(res.data as String);
          }
        } catch (parseErr) {
          debugPrint("⚠️ saveCoCurricularMarks parse error: $parseErr");
        }
        return null;
      } else {
        // ✅ FIX: showInfoDialog को try-catch में wrap (crash-safe)
        try {
          Utility.showInfoDialog(res);
        } catch (_) {
          debugPrint("⚠️ showInfoDialog failed, ignoring");
        }
        return null;
      }
    } catch (e) {
      debugPrint("❌ saveCoCurricularMarks error: $e");
      try {
        await _deviceRepository.saveCoCurricularMarks(
          isLoading: isLoading,
          token: token,
          branchId: branchId,
          payload: payload,
        );
      } catch (_) {}
      return null;
    }
  }

  Future<DeleteAccountResponse?> sendDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
  }) async {
    try {
      var res = await _dataRepository.sendDeleteAccountOtp(
        isLoading: isLoading,
        branchCode: branchCode,
        username: username,
      );
      if (!res.hasError && res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return DeleteAccountResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return DeleteAccountResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.sendDeleteAccountOtp(
        isLoading: isLoading,
        branchCode: branchCode,
        username: username,
      );
      return null;
    }
  }

  Future<DeleteAccountResponse?> verifyDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
    required String otp,
  }) async {
    try {
      var res = await _dataRepository.verifyDeleteAccountOtp(
        isLoading: isLoading,
        branchCode: branchCode,
        username: username,
        otp: otp,
      );
      if (!res.hasError && res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return DeleteAccountResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return DeleteAccountResponse.fromJson(jsonDecode(res.data));
        }
        return null;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.verifyDeleteAccountOtp(
        isLoading: isLoading,
        branchCode: branchCode,
        username: username,
        otp: otp,
      );
      return null;
    }
  }

  Future<SaveExternalMarksResponse?> saveInternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      var res = await _dataRepository.saveInternalMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      if (!res.hasError && res.data != null) {
        // ✅ Handle both Map and String responses
        if (res.data is Map<String, dynamic>) {
          return SaveExternalMarksResponse.fromJson(res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return saveExternalMarksResponseFromJson(res.data as String);
        } else {
          return null;
        }
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.saveInternalMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      return null;
    }
  }
Future<ExamScheduleResponse?> getExamSchedule({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getExamSchedule(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
      if (!res.hasError && res.data != null) {
        return examScheduleResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getExamSchedule(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
      return null;
    }
  }

Future<TermSectionResponse?> getTermSectionData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
  }) async {
    try {
      var res = await _dataRepository.getTermSectionData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,

      );
      if (!res.hasError && res.data != null) {
        return termSectionResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getTermSectionData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,

      );
      return null;
    }
  }
  Future<SubjectResponse?> getSubjectData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getSubjectData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,

      );
      if (!res.hasError && res.data != null) {
        return subjectResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getSubjectData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,

      );
      return null;
    }
  }
  Future<StudentFeeStatusResponse?> getStudentFeeList({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getStudentFeeList(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,

      );
      if (!res.hasError && res.data != null) {
        return studentFeeStatusResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getStudentFeeList(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,

      );
      return null;
    }
  }
  Future<ExaminationTermResponse?> getExamTermData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
  }) async {
    try {
      var res = await _dataRepository.getExamTermData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,

      );
      if (!res.hasError && res.data != null) {
        return examinationTermResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getExamTermData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,

      );
      return null;
    }
  }
// ========== GET EXTERNAL MARKS ==========
  Future<ExternalMarksResponse?> getExternalMarks({
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
    try {
      var res = await _dataRepository.getExternalMarks(
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
      if (!res.hasError && res.data != null) {
        return externalMarksResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getExternalMarks(
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
      return null;
    }
  }

// ========== GET EXTERNAL MARKS ==========
  Future<InternalMarksResponse?> getInternalMarks({
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
    try {
      var res = await _dataRepository.getInternalMarks(
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
      if (!res.hasError && res.data != null) {
        return internalMarksResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getInternalMarks(
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
      return null;
    }
  }

 Future<ClassDetailsResponse?> getMyClassDetailsData({
    required bool isLoading,
    required String token,
    required String branchId,
   required String classId,
   required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getMyClassDetailsData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,

      );
      if (!res.hasError && res.data != null) {
        return classDetailsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getMyClassDetailsData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );
      return null;
    }
  }

  Future<GetStudentAttendanceResponse?> getStudentListData({
    required bool isLoading,
    required String token,
    required String branchId,
   required String classId,
   required String sectionId,
   required String date,
  }) async {
    try {
      var res = await _dataRepository.getStudentListData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: date,

      );
      if (!res.hasError && res.data != null) {
        return getStudentAttendanceResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getStudentListData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: date,
      );
      return null;
    }
  }
  Future<PaymentOrderResponse?> createPaymentOrder({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required List<String> invoiceIds,
    required double amount,
    required String sessionId,
  }) async {
    try {
      var res = await _dataRepository.createPaymentOrder(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
        invoiceIds: invoiceIds,
        amount: amount,
        sessionId: sessionId,
      );
      if (!res.hasError && res.data != null) {
        try {
          dynamic data = res.data;
          if (data is String) data = jsonDecode(data);
          if (data is Map<String, dynamic>) {
            return PaymentOrderResponse.fromJson(data);
          }
        } catch (parseErr) {
          debugPrint("⚠️ createPaymentOrder parse error: $parseErr");
        }
        return null;
      } else {
        debugPrint("⚠️ createPaymentOrder failed: ${res.data}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ createPaymentOrder error: $e");
      return null;
    }
  }

  Future<AttendanceReportResponse?> fetchClassAttendanceReport({
    required bool isLoading,
    required String token,
    required String branchId,
   required String classId,
   required String sectionId,
   required String date,
  }) async {
    try {
      var res = await _dataRepository.fetchClassAttendanceReport(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: date,

      );
      if (!res.hasError && res.data != null) {
        return attendanceReportResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.fetchClassAttendanceReport(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: date,
      );
      return null;
    }
  }

    Future<StudentsResponse?> getAllStudentList({
    required bool isLoading,
    required String token,
    required String branchId,
      required String classId,
      required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getAllStudentList(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );
      if (!res.hasError && res.data != null) {
        return studentsResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getAllStudentList(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );
      return null;
    }
  }

 Future<ClassAttendanceResponse?> getClassAttendance({
    required bool isLoading,
   required String token,
   required String attendanceDate,
   required String branchId,
   required String classId,
   required String sectionId, required int perPage,required int page
  }) async {
    try {
      var res = await _dataRepository.getClassAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        attendanceDate: attendanceDate,
        classId: classId,
        sectionId: sectionId,
        perPage: perPage,
        page: page,
      );
      if (!res.hasError && res.data != null) {
        return classAttendanceResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getClassAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        attendanceDate: attendanceDate,
        classId: classId,
        sectionId: sectionId,
        perPage: perPage,
        page: page,
      );
      return null;
    }
  }

  Future<SaveAttendanceResponse?> saveAttendance({   // Object? ki jagah SaveAttendanceResponse?
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload
  }) async {
    try {
      var res = await _dataRepository.saveAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (res.hasError || res.data == null) {
        debugPrint("? Error or null data");
        return null;
      }

      String jsonString = res.data is String ? res.data as String : jsonEncode(res.data);

      SaveAttendanceResponse response = saveAttendanceResponseFromJson(jsonString);
      return response;   // ✅ already sahi tha
    } catch (e) {
      await _deviceRepository.saveAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      return null;
    }
  }
  Future<SaveAttendanceResponse?> updateAttendance({   // Object? ki jagah SaveAttendanceResponse?
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload
  }) async {
    try {
      var res = await _dataRepository.updateAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );

      if (res.hasError || res.data == null) {
        debugPrint("? Error or null data");
        return null;
      }

      String jsonString = res.data is String ? res.data as String : jsonEncode(res.data);

      SaveAttendanceResponse response = saveAttendanceResponseFromJson(jsonString);
      return response;   // ✅ already sahi tha
    } catch (e) {
      await _deviceRepository.updateAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      return null;
    }
  }
  // ============================================================
  // ✅ NEW: Co-Curricular Marks (returns parsed model)
  // ============================================================
  Future<CoCurricularMarksResponse?> getCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    try {
      var res = await _dataRepository.getCoCurricularMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
      if (!res.hasError && res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return CoCurricularMarksResponse.fromJson(
              res.data as Map<String, dynamic>);
        } else if (res.data is String) {
          return CoCurricularMarksResponse.fromJson(
              jsonDecode(res.data as String) as Map<String, dynamic>);
        }
        return null;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      debugPrint("❌ getCoCurricularMarks error: $e");
      await _deviceRepository.getCoCurricularMarks(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
      return null;
    }
  }
  Future<SaveTermAttendanceResponse?> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      var res = await _dataRepository.saveTermAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      if (!res.hasError && res.data != null) {
        try {
          // ✅ Handle both Map and String responses
          if (res.data is Map<String, dynamic>) {
            return SaveTermAttendanceResponse.fromJson(res.data as Map<String, dynamic>);
          } else if (res.data is String) {
            return saveTermAttendanceResponseFromJson(res.data as String);
          } else {
            return null;
          }
        } catch (e) {
          debugPrint("❌ JSON parse error in saveTermAttendance: $e");
          return null;
        }
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.saveTermAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
      return null;
    }
  }
  Future<InvoiceResponseModel?> getInvoiceDetailsAPI({
    required bool isLoading,
    required String token,
    required String invoiceId, required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getInvoiceDetailsAPI(
        isLoading: isLoading,
        token: token,
        invoiceId: invoiceId,
        branchId: branchId,
      );
      if (!res.hasError && res.data != null) {
        return invoiceResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getInvoiceDetailsAPI(
        isLoading: isLoading,
        token: token,
        invoiceId: invoiceId,
        branchId: branchId,
      );
      return null;
    }
  }

  Future<ResponseModel?> logoutAPI({
    required bool isLoading, required String token,
  }) async {
    try {
      var res = await _dataRepository.logoutAPI(
          isLoading: isLoading, token: token);
      if (!res.hasError) {
        return res;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.logout(
          isLoading: isLoading, token: token, );
      return null;
    }
  }
}
