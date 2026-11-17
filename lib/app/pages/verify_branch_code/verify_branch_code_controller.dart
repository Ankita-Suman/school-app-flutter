// verify_branch_code_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_app/app/pages/verify_branch_code/verify_branch_code_presenter.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/branch_verify_response.dart';
import '../../navigators/routes_management.dart';

class VerifyBranchCodeController extends GetxController {
  VerifyBranchCodeController(this.loginStudentPresenter);

  final VerifyBranchCodePresenter loginStudentPresenter;

  // ========== BRANCH CODE ==========
  TextEditingController? branchCodeController;
  FocusNode? branchCodeFocusNode;
  var isBranchCodeFocused = false.obs;
  var branchCodeError = ''.obs;
  var isBranchCodeValid = false.obs;
  bool _branchCodeErrorShown = false;

  // ========== UI STATES ==========
  var isLoading = false.obs;
  var isBranchVerified = false.obs;
  var schoolInfoData = Rxn<BranchVerifyResponse>();

  // Track last fetched branch to avoid duplicate calls
  var _lastFetchedBranch = ''.obs;
  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();

    branchCodeController = TextEditingController();
    branchCodeFocusNode = FocusNode();

    branchCodeFocusNode?.addListener(_onBranchCodeFocusChange);
  }

  // ========== FETCH SCHOOL INFO BY BRANCH CODE (API) ==========
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
      var res = await loginStudentPresenter.getSchoolInfo(
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

          // (A) Pura model JSON string me save karo
          await deviceRepo.saveValueSecurely(
              DeviceConstants.schoolInfo,
              jsonEncode(res.toJson())
          );

          // (B) Alag-alag fields bhi save karo taaki Login screen par aasani se use ho sake
          await deviceRepo.saveValueSecurely(DeviceConstants.branchId, res.data?.branchId ?? '');
        //  await deviceRepo.saveValueSecurely('school_name', schoolName);
          await deviceRepo.saveValueSecurely('branch_name', branchName);
          await deviceRepo.saveValueSecurely('branch_code', branchCode);
          await deviceRepo.saveValueSecurely('logo_url', res.data?.logoUrl ?? '');

          debugPrint("✅ User-typed branchCode saved: $branchCode");
          debugPrint("✅ Full Model saved successfully");

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

  // ✅ Button click par API hit karne ke liye
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

  // ========== SNACKBARS & DIALOGS ==========
  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  void clearBranchCodeError() {
    if (branchCodeError.value.isNotEmpty) {
      branchCodeError.value = '';
      isBranchCodeValid.value = false;
    }
  }

  void clearAllFields() {
    branchCodeController?.clear();
    isBranchCodeValid.value = false;
    branchCodeError.value = '';
    _branchCodeErrorShown = false;
    schoolInfoData.value = null;
    _lastFetchedBranch.value = '';
    isBranchVerified.value = false;
  }

  @override
  void onClose() {
    branchCodeFocusNode?.removeListener(_onBranchCodeFocusChange);
    super.onClose();
  }
}