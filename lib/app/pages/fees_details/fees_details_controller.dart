// pages/login/new_otp_verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeesDetailsController extends GetxController {
  var selectedTab = 0.obs;

  // ✅ Loading state — default TRUE
  var isLoading = true.obs;

  // Text Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Focus Nodes
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // Focus States
  var isEmailFocused = false.obs;
  var isPasswordFocused = false.obs;
  var isPasswordVisible = false.obs;

  // ============================================================
  // Fee data (dummy — API aane pe replace karna)
  // ============================================================
  var totalDue = ''.obs;
  var paidAmount = ''.obs;
  var pendingAmount = ''.obs;
  var hasData = false.obs;

  @override
  void onInit() {
    super.onInit();

    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });

    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });

    // ✅ Screen khulte hi data fetch
    loadFeesData();
  }

  // ============================================================
  // ✅ DATA FETCH — HAR BAAR blank screen + fresh data
  // ============================================================
  Future<void> loadFeesData() async {
    // ✅ STEP 1: Sabse pehle blank screen
    isLoading.value = true;
    hasData.value = false;

    // ✅ STEP 2: Purana data turant clear karo
    // (isse blank screen ke peeche purana data nahi dikhega)
    totalDue.value = '';
    paidAmount.value = '';
    pendingAmount.value = '';

    try {
      // ============================================
      // 👉 YAHAN API CALL KARO (abhi dummy delay hai)
      // ============================================
      // Example:
      // var deviceRepo = Get.find<DeviceRepository>();
      // var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      // var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);
      // var studentId = await deviceRepo.getSecuredValue(DeviceConstants.studentId);
      // var res = await presenter.getFeesDetailsAPI(
      //   isLoading: false,
      //   token: token,
      //   branchId: branchId,
      //   studentId: studentId,
      // );
      // if (res != null && res.status == true && res.data != null) {
      //   totalDue.value = '₹${res.data!.totalDue}';
      //   paidAmount.value = '₹${res.data!.paidAmount}';
      //   pendingAmount.value = '₹${res.data!.pendingAmount}';
      // }

      // ⏳ Dummy delay — API lagao to hata do
      await Future.delayed(const Duration(seconds: 2));

      // ✅ STEP 3: Data set karo
      totalDue.value = '₹22,560';
      paidAmount.value = '₹5,080';
      pendingAmount.value = '₹17,480';
      hasData.value = true;

    } catch (e) {
      debugPrint("❌ loadFeesData error: $e");
    } finally {
      // ✅ STEP 4: Data set hone ke baad hi screen dikhegi
      isLoading.value = false;
    }
  }

  // ============================================================

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}