import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/branch_verify_response.dart';
import '../../navigators/routes_management.dart';
import 'delete_account_presenter.dart';

class DeleteAccountController extends GetxController {
  DeleteAccountController(this.presenter);

  final DeleteAccountPresenter presenter;

  // ========== BRANCH CODE ==========
  late final TextEditingController branchCodeController;
  late final FocusNode branchCodeFocusNode;
  var isBranchCodeFocused = false.obs;
  var branchCodeError = ''.obs;
  var isBranchCodeValid = false.obs;
  var isBranchVerifying = false.obs;
  var isBranchVerified = false.obs;

  // ========== USERNAME / EMAIL ==========
  late final TextEditingController usernameController;
  late final FocusNode usernameFocusNode;
  var isUsernameFocused = false.obs;
  var usernameError = ''.obs;

  // ========== OTP ==========
  late final TextEditingController otpController;
  late final FocusNode otpFocusNode;
  var isOtpFocused = false.obs;
  var otpError = ''.obs;
  var isOtpStep = false.obs;

  // ========== UI STATES ==========
  var isLoading = false.obs;
  var schoolInfoData = Rxn<BranchVerifyResponse>();

  // Internal
  String _lastFetchedBranch = '';
  bool _isFetchingBranch = false;
  bool _branchCodeErrorShown = false;

  // ============================================================
  // INIT
  // ============================================================
  @override
  void onInit() {
    super.onInit();

    branchCodeController = TextEditingController();
    branchCodeFocusNode = FocusNode();
    usernameController = TextEditingController();
    usernameFocusNode = FocusNode();
    otpController = TextEditingController();
    otpFocusNode = FocusNode();

    branchCodeFocusNode.addListener(_onBranchCodeFocusChange);
    usernameFocusNode.addListener(
            () => isUsernameFocused.value = usernameFocusNode.hasFocus);
    otpFocusNode.addListener(
            () => isOtpFocused.value = otpFocusNode.hasFocus);
  }

  // ============================================================
  // ✅ Helper: Get branchId — from verify API response (memory)
  // ============================================================
  Future<String> _getBranchId() async {
    final fromApi = schoolInfoData.value?.data?.branchId ?? '';
    if (fromApi.isNotEmpty) {
      debugPrint('✅ branchId from verify response: $fromApi');
      return fromApi;
    }
    debugPrint('❌ branchId NOT available — verify branch first');
    return '';
  }

  // ============================================================
  // ✅ Helper: Get auth token from secure storage
  // ============================================================
  Future<String> _getToken() async {
    try {
      final deviceRepo = Get.find<DeviceRepository>();
      final token =
          await deviceRepo.getSecuredValue(DeviceConstants.token) ?? '';
      if (token.isEmpty) {
        debugPrint('❌ token EMPTY — user must login again');
      } else {
        debugPrint(
            '✅ token fetched: ${token.substring(0, 20)}... (len: ${token.length})');
      }
      return token;
    } catch (e, st) {
      debugPrint('❌ _getToken error: $e\n$st');
      return '';
    }
  }

  // ============================================================
  // ✅ VALIDATION ONLY (no API on typing)
  // ============================================================
  void validateBranchCode(String value) {
    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeError.value = '';
      _branchCodeErrorShown = false;
      schoolInfoData.value = null;
      _lastFetchedBranch = '';
      isBranchVerified.value = false;
      return;
    }

    if (value.length < 3) {
      isBranchCodeValid.value = false;
      branchCodeError.value = 'Branch code must be at least 3 characters';
      schoolInfoData.value = null;
      _lastFetchedBranch = '';
      isBranchVerified.value = false;
      return;
    }

    isBranchCodeValid.value = true;
    branchCodeError.value = '';
    _branchCodeErrorShown = false;

    if (value.trim() != _lastFetchedBranch) {
      isBranchVerified.value = false;
    }
    if (isOtpStep.value) {
      isOtpStep.value = false;
      otpController.clear();
      otpError.value = '';
    }
  }

  // ============================================================
  // ✅ FOCUS CHANGE — API hit on focus loss
  // ============================================================
  void _onBranchCodeFocusChange() {
    if (branchCodeFocusNode == null) return;
    isBranchCodeFocused.value = branchCodeFocusNode.hasFocus;

    if (!branchCodeFocusNode.hasFocus) {
      final branchCode = branchCodeController.text.trim();
      if (branchCode.length >= 3 &&
          isBranchCodeValid.value &&
          !isBranchVerified.value) {
        fetchSchoolInfoForBranch(branchCode);
      }
    }
  }

  // ============================================================
  // ✅ BRANCH VERIFY API
  // ============================================================
  Future<void> fetchSchoolInfoForBranch(String branchCode) async {
    if (branchCode.isEmpty || branchCode.length < 3) return;
    if (_isFetchingBranch) return;
    if (_lastFetchedBranch == branchCode && schoolInfoData.value != null) {
      return;
    }

    _isFetchingBranch = true;
    isBranchVerifying.value = true;
    branchCodeError.value = '';

    try {
      var deviceRepo = Get.find<DeviceRepository>();

      await deviceRepo.saveValueSecurely(
          DeviceConstants.branchCode, branchCode);

      isLoading.value = true;

      var res = await presenter.getSchoolInfo(
        isLoading: false,
        branchCode: branchCode,
      );

      debugPrint("🔍 School Info Response: ${res?.toJson()}");

      if (res != null && res.status == true && res.data != null) {
        final branchName = res.data?.branchName ?? '';

        if (branchName.isNotEmpty) {
          schoolInfoData.value = res;
          _lastFetchedBranch = branchCode;
          isBranchVerified.value = true;
          branchCodeError.value = '';

          await deviceRepo.saveValueSecurely(
              DeviceConstants.schoolInfo, jsonEncode(res.toJson()));
          await deviceRepo.saveValueSecurely(
              DeviceConstants.branchId, res.data?.branchId ?? '');
          await deviceRepo.saveValueSecurely('branch_name', branchName);
          await deviceRepo.saveValueSecurely('branch_code', branchCode);
          await deviceRepo.saveValueSecurely(
              'logo_url', res.data?.logoUrl ?? '');

          debugPrint(
              "✅ Branch saved: $branchCode | $branchName | id=${res.data?.branchId}");

          // ✅ REMOVED: success snackbar — ab koi snackbar nahi aayega
        } else {
          schoolInfoData.value = null;
          _lastFetchedBranch = '';
          isBranchVerified.value = false;
          branchCodeError.value = 'Branch not found';
        }
      } else {
        schoolInfoData.value = null;
        _lastFetchedBranch = '';
        isBranchVerified.value = false;
        branchCodeError.value = res?.message ?? 'Invalid branch code';
      }
    } catch (e, st) {
      debugPrint("❌ School info error: $e\n$st");
      schoolInfoData.value = null;
      _lastFetchedBranch = '';
      isBranchVerified.value = false;
      branchCodeError.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
      isBranchVerifying.value = false;
      _isFetchingBranch = false;
    }
  }

  // ============================================================
  // ✅ MANUAL VERIFY
  // ============================================================
  void verifyBranchCode() {
    String branchCode = branchCodeController.text.trim();

    if (branchCode.isEmpty) {
      branchCodeError.value = 'Please enter branch code';
      branchCodeFocusNode.requestFocus();
      return;
    }
    if (branchCode.length < 3) {
      branchCodeError.value = 'Branch code must be at least 3 characters';
      branchCodeFocusNode.requestFocus();
      return;
    }
    branchCodeError.value = '';
    fetchSchoolInfoForBranch(branchCode);
  }

  // ============================================================
  // ✅ SEND OTP — with branch_id + TOKEN
  // ============================================================
  Future<void> onSendOtpPressed() async {
    final branchCode = branchCodeController.text.trim();
    final username = usernameController.text.trim();

    branchCodeError.value = '';
    usernameError.value = '';

    if (branchCode.isEmpty) {
      branchCodeError.value = 'Please enter branch code';
      return;
    }
    if (!isBranchVerified.value) {
      branchCodeError.value = 'Please wait for branch verification';
      return;
    }
    if (username.isEmpty) {
      usernameError.value = 'Please enter username or email';
      usernameFocusNode.requestFocus();
      return;
    }

    final branchId = await _getBranchId();
    final token = await _getToken();

    debugPrint('════════ SEND OTP ════════');
    debugPrint('║ branchCode : $branchCode');
    debugPrint('║ branchId   : $branchId');
    debugPrint('║ username   : $username');
    debugPrint(
        '║ token      : ${token.isNotEmpty ? "${token.substring(0, 20)}..." : "EMPTY"}');
    debugPrint('══════════════════════════');

    if (branchId.isEmpty) {
      Get.snackbar('Error', 'Branch ID missing. Please re-verify branch code.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (token.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final res = await presenter.sendDeleteAccountOtp(
        isLoading: false,
        branchCode: branchCode,
        branchId: branchId,
        username: username,
        token: token,
      );

      debugPrint("════════ SEND OTP RESULT ════════");
      debugPrint("res is null : ${res == null}");
      debugPrint("res.status  : ${res?.status}");
      debugPrint("res.message : ${res?.message}");
      debugPrint("res.data    : ${res?.data?.toJson()}");
      debugPrint("═════════════════════════════════");

      if (res != null && res.status == true) {
        isOtpStep.value = true;

        final otp = res.data?.otp ?? '';
        if (otp.isNotEmpty) {
          otpController.text = otp;
        }

        Get.snackbar('OTP Sent', res.message ?? 'OTP sent successfully.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        final msg = res == null
            ? 'Server response could not be read. Please try again.'
            : (res.message ?? 'Failed to send OTP.');
        Get.snackbar('Error', msg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e, st) {
      debugPrint('❌ Send OTP: $e\n$st');
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ✅ VERIFY OTP → DELETE → LOGIN — with branch_id + TOKEN
  // ============================================================
  Future<void> onVerifyOtpPressed() async {
    final branchCode = branchCodeController.text.trim();
    final username = usernameController.text.trim();
    final otp = otpController.text.trim();

    otpError.value = '';
    if (otp.isEmpty) {
      otpError.value = 'Please enter OTP';
      return;
    }

    final branchId = await _getBranchId();
    final token = await _getToken();

    debugPrint('════════ VERIFY OTP ════════');
    debugPrint('║ branchCode : $branchCode');
    debugPrint('║ branchId   : $branchId');
    debugPrint('║ username   : $username');
    debugPrint('║ otp        : $otp');
    debugPrint(
        '║ token      : ${token.isNotEmpty ? "${token.substring(0, 20)}..." : "EMPTY"}');
    debugPrint('════════════════════════════');

    if (branchId.isEmpty) {
      Get.snackbar('Error', 'Branch ID missing. Please re-verify branch code.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (token.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please login again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final res = await presenter.verifyDeleteAccountOtp(
        isLoading: false,
        branchCode: branchCode,
        branchId: branchId,
        username: username,
        otp: otp,
        token: token,
      );

      debugPrint("════════ VERIFY OTP RESULT ════════");
      debugPrint("res is null : ${res == null}");
      debugPrint("res.status  : ${res?.status}");
      debugPrint("res.message : ${res?.message}");
      debugPrint("res.data    : ${res?.data?.toJson()}");
      debugPrint("═══════════════════════════════════");

      if (res != null && res.status == true) {
        Get.snackbar(
            'Success', res.message ?? 'Account deleted successfully.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));

        await Future.delayed(const Duration(seconds: 2));

        Get.deleteAll(force: true);
        RouteManagement.goToLogin();
        return;
      } else {
        final msg = res == null
            ? 'Server response could not be read. Please try again.'
            : (res.message ?? 'Invalid OTP.');
        Get.snackbar('Error', msg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        isLoading.value = false;
      }
    } catch (e, st) {
      debugPrint('❌ Verify OTP: $e\n$st');
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      isLoading.value = false;
    }
  }

  // ============================================================
  // ✅ Main Button
  // ============================================================
  void onMainButtonPressed() {
    if (isLoading.value || isBranchVerifying.value) return;

    if (isOtpStep.value) {
      onVerifyOtpPressed();
    } else if (isBranchVerified.value) {
      onSendOtpPressed();
    } else {
      verifyBranchCode();
    }
  }

  // ============================================================
  // Validators
  // ============================================================
  void validateUsername(String _) {
    usernameError.value = '';
  }

  void validateOtp(String _) {
    otpError.value = '';
  }

  // ============================================================
  // DISPOSE
  // ============================================================
  @override
  void onClose() {
    branchCodeFocusNode.removeListener(_onBranchCodeFocusChange);
    branchCodeController.dispose();
    branchCodeFocusNode.dispose();
    usernameController.dispose();
    usernameFocusNode.dispose();
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}