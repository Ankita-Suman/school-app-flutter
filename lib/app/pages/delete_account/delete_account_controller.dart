import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/branch_verify_response.dart';
import '../../navigators/routes_management.dart';
import '../verify_branch_code/verify_branch_code_presenter.dart';
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
  bool _isFetching = false;
  // Internal
  Timer? _branchVerifyDebounce;
  var _lastFetchedBranch = ''.obs;
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

  void verifyBranchCode() {
    // User ne jo type kiya hai wo yahan aayega
    String branchCode = branchCodeController?.text.trim() ?? '';

    if (branchCode.isEmpty) {
      branchCodeError.value = 'Please enter branch code';
      branchCodeFocusNode?.requestFocus();
      return;
    }

    if (branchCode.length < 3) {
      branchCodeError.value = 'Branch code must be at least 3 characters';
      branchCodeFocusNode?.requestFocus();
      return;
    }

    branchCodeError.value = '';
    fetchSchoolInfoForBranch(branchCode); // Function me bhej diya
  }
  // ========== VALIDATION (only branch code) ==========
  void validateBranchCode(String value) {
    if (value.isEmpty) {
      isBranchCodeValid.value = false;
      branchCodeError.value = '';
      _branchCodeErrorShown = false;
      schoolInfoData.value = null;
      _lastFetchedBranch.value = '';
      isBranchVerified.value = false;
      return;
    }

    if (value.length < 3) {
      isBranchCodeValid.value = false;
      branchCodeError.value = 'Branch code must be at least 3 characters';
      schoolInfoData.value = null;
      _lastFetchedBranch.value = '';
      isBranchVerified.value = false;
      return;
    }

    isBranchCodeValid.value = true;
    branchCodeError.value = '';
    _branchCodeErrorShown = false;
  }

  // ========== FOCUS CHANGE HANDLERS ==========
  void _onBranchCodeFocusChange() {
    if (branchCodeFocusNode == null) return;
    isBranchCodeFocused.value = branchCodeFocusNode!.hasFocus;

    if (!branchCodeFocusNode!.hasFocus) {
      final branchCode = branchCodeController?.text.trim() ?? '';
      if (branchCode.length >= 3 && isBranchCodeValid.value) {
        fetchSchoolInfoForBranch(branchCode);
      }
    }
  }

  // ============================================================
  // ✅ BRANCH VERIFY API
  // ============================================================
  Future<void> fetchSchoolInfoForBranch(String branchCode) async {
    // ✅ 1. Yahan 'branchCode' wo hai jo user ne input field me type kiya hai
    if (branchCode.isEmpty || branchCode.length < 3) return;
    if (_isFetching) return;

    if (_lastFetchedBranch.value == branchCode && schoolInfoData.value != null) {
      return;
    }

    _isFetching = true;
    try {
      // ✅ 2. Device Repository ko yahan initialize karo (Yeh missing tha)
      var deviceRepo = Get.find<DeviceRepository>();

      // ✅ 3. User ka type kiya hua branchCode save karo
      await deviceRepo.saveValueSecurely(DeviceConstants.branchCode, branchCode);

      isLoading.value = true;

      // ✅ 4. API me yahi user-typed branchCode bhejo verify karne ke liye
      // (branchCodeController!.text use karne ki zaroorat nahi, parameter me already aya hai)
      var res = await presenter.getSchoolInfo(
        isLoading: false,
        branchCode: branchCode,
      );

      debugPrint("🔍 School Info Response: ${res?.toJson()}");

      if (res != null && res.status == true && res.data != null) {
        // final schoolName = res.data?.schoolName ?? '';
        final branchName = res.data?.branchName ?? '';

        if (branchName.isNotEmpty) {
          schoolInfoData.value = res;
          _lastFetchedBranch.value = branchCode;
          isBranchVerified.value = true;

          // ============================================================
          // ✅ 5. API SE AAYE PURE MODEL KO SAVE KARO (Jaise aaya hai waise hi)
          // ============================================================


          // ✅ 6. Sab kuch save hone ke baad Login Screen par navigate karo
          await Future.delayed(const Duration(milliseconds: 500));
          RouteManagement.goToLogin();

        } else {
          schoolInfoData.value = null;
          _lastFetchedBranch.value = '';
          isBranchVerified.value = false;
          debugPrint("❌ Branch not found: Empty school/branch names");
        }
      } else {
        schoolInfoData.value = null;
        _lastFetchedBranch.value = '';
        isBranchVerified.value = false;
        debugPrint("❌ School info failed: ${res?.message}");
      }
    } catch (e) {
      debugPrint("❌ School info error: $e");
      schoolInfoData.value = null;
      _lastFetchedBranch.value = '';
      isBranchVerified.value = false;
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  // ============================================================
  // ✅ SEND OTP
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

    isLoading.value = true;
    try {
      final res = await presenter.sendDeleteAccountOtp(
        isLoading: false,
        branchCode: branchCode,
        username: username,
      );

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
        Get.snackbar('Error', res?.message ?? 'Failed to send OTP.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('❌ Send OTP: $e');
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ✅ VERIFY OTP → DELETE → LOGIN (kill all)
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

    isLoading.value = true;
    try {
      final res = await presenter.verifyDeleteAccountOtp(
        isLoading: false,
        branchCode: branchCode,
        username: username,
        otp: otp,
      );

      if (res != null && res.status == true) {
        Get.snackbar('Success', res.message ?? 'Account deleted successfully.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));

        await Future.delayed(const Duration(seconds: 2));
        Get.deleteAll(force: true);
        RouteManagement.goToLogin();
        return;
      } else {
        Get.snackbar('Error', res?.message ?? 'Invalid OTP.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint('❌ Verify OTP: $e');
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
      verifyBranchCode(); // fallback — immediate verify
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
    _branchVerifyDebounce?.cancel();
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