import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/pages/delete_account/delete_account_controller.dart';
import 'package:school_app/app/pages/delete_account/delete_account_presenter.dart';
import '../../widgets/gradient_button.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    final DeleteAccountController controller = Get.put(
      DeleteAccountController(Get.find<DeleteAccountPresenter>()),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.09),
                child: Image.asset(
                  AssetConstants.iclogo,
                  height: screenWidth * 0.55,
                  width: screenWidth * 0.55,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.04),

                          Text(
                            'Delete Account',
                            style: Styles.darkBlcW70020.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your branch code, then username / email. You will receive an OTP to permanently delete your account.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // ============ STEP 1: Branch Code ============
                          _buildBranchCodeField(
                              controller, screenWidth, screenHeight),

                          SizedBox(height: screenHeight * 0.025),

                          // ============ STEP 2: Username / Email — ALWAYS VISIBLE ============
                          _buildInputField(
                            label: 'USERNAME / EMAIL',
                            hint: 'Enter username or email',
                            icon: Icons.person,
                            controller: controller.usernameController,
                            focusNode: controller.usernameFocusNode,
                            isFocused: controller.isUsernameFocused,
                            error: controller.usernameError,
                            onChanged: controller.validateUsername,
                            enabled: !controller.isOtpStep.value,
                          ),

                          // ============ STEP 3: OTP — only after Send OTP success ============
                          Obx(() {
                            if (!controller.isOtpStep.value) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                SizedBox(height: screenHeight * 0.025),
                                _buildInputField(
                                  label: 'ENTER OTP',
                                  hint: 'Enter 6 digit OTP',
                                  icon: Icons.lock_clock,
                                  controller: controller.otpController,
                                  focusNode: controller.otpFocusNode,
                                  isFocused: controller.isOtpFocused,
                                  error: controller.otpError,
                                  onChanged: controller.validateOtp,
                                  enabled: true,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            );
                          }),

                          SizedBox(height: screenHeight * 0.05),

                          // ============ MAIN ACTION BUTTON ============
                          Obx(() {
                            final isOtpStep = controller.isOtpStep.value;
                            final isBranchVerified =
                                controller.isBranchVerified.value;
                            final isLoading = controller.isLoading.value;
                            final isVerifyingBranch =
                                controller.isBranchVerifying.value;

                            String btnText;
                            IconData btnIcon;
                            bool isDisabled = false;

                            if (isLoading) {
                              btnText = 'Please wait...';
                              btnIcon = Icons.hourglass_empty;
                              isDisabled = true;
                            } else if (isVerifyingBranch) {
                              btnText = 'Verifying branch...';
                              btnIcon = Icons.sync;
                              isDisabled = true;
                            } else if (isOtpStep) {
                              btnText = 'Verify & Delete';
                              btnIcon = Icons.delete_forever;
                            } else if (isBranchVerified) {
                              btnText = 'Send OTP';
                              btnIcon = Icons.send;
                            } else {
                              btnText = 'Verify Branch Code';
                              btnIcon = Icons.verified_user;
                            }

                            return Opacity(
                              opacity: isDisabled ? 0.5 : 1.0,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: GradientButton(
                                  onPressed: isDisabled
                                      ? () {}
                                      : controller.onMainButtonPressed,
                                  text: btnText,
                                  icon: Icon(
                                    btnIcon,
                                    size: screenWidth * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ✅ BRANCH CODE FIELD
  // ============================================================
  Widget _buildBranchCodeField(DeleteAccountController controller,
      double screenWidth, double screenHeight) {
    return Obx(() {
      final hasError = controller.branchCodeError.value.isNotEmpty;
      final isVerified = controller.isBranchVerified.value;
      final isVerifying = controller.isBranchVerifying.value;
      final hasText = controller.branchCodeController.text.isNotEmpty;
      final isFocused = controller.isBranchCodeFocused.value;

      Color borderColor;
      double borderWidth;
      if (hasError) {
        borderColor = Colors.red;
        borderWidth = 1.5;
      } else if (isVerified) {
        borderColor = Colors.green;
        borderWidth = 1.5;
      } else if (isFocused || hasText) {
        borderColor = Colors.blue.shade700;
        borderWidth = 1.5;
      } else {
        borderColor = Colors.grey.shade300;
        borderWidth = 1;
      }

      Color fillColor;
      if (!isFocused && hasText && isVerified) {
        fillColor = Colors.green.shade50;
      } else if (isFocused) {
        fillColor = Colors.white;
      } else if (hasText) {
        fillColor = Colors.blue.shade50;
      } else {
        fillColor = Colors.grey.shade50;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BRANCH CODE',
              style: Styles.darkGryW700.copyWith(fontSize: 13)),
          SizedBox(height: screenHeight * 0.012),
          Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: TextField(
              controller: controller.branchCodeController,
              focusNode: controller.branchCodeFocusNode,
              enabled: !controller.isOtpStep.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: Styles.darkBlcW400,
              onChanged: controller.validateBranchCode,
              onSubmitted: (_) => controller.verifyBranchCode(),
              decoration: InputDecoration(
                hintText: 'Enter branch code (e.g., ASDF34UYGHS)',
                hintStyle: Styles.darkGryW40014,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.022),
                prefixIcon: Icon(
                  Icons.business,
                  size: screenWidth * 0.05,
                  color: hasError
                      ? Colors.red
                      : (isVerified
                      ? Colors.green
                      : (isFocused || hasText)
                      ? Colors.blue.shade700
                      : Colors.grey.shade500),
                ),
                suffixIcon: isVerifying
                    ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.blue.shade700),
                  ),
                )
                    : (isVerified
                    ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.check_circle,
                      color: Colors.green, size: 22),
                )
                    : null),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                controller.branchCodeError.value,
                style: const TextStyle(fontSize: 11, color: Colors.red),
              ),
            ),
          // ✅ REMOVED: 'Branch verified successfully' text row yahan se hata diya
        ],
      );
    });
  }

  // ============================================================
  // Reusable Input Field
  // ============================================================
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required RxBool isFocused,
    required RxString error,
    required Function(String) onChanged,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Obx(() {
      final hasError = error.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Styles.darkGryW700.copyWith(fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: enabled
                  ? (isFocused.value ? Colors.white : Colors.grey.shade50)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (isFocused.value
                    ? Colors.blue.shade700
                    : Colors.grey.shade300),
                width: hasError || isFocused.value ? 1.5 : 1,
              ),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: Styles.darkBlcW400,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: Styles.darkGryW40014,
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                prefixIcon: Icon(icon,
                    size: 20,
                    color: hasError ? Colors.red : Colors.grey.shade500),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(error.value,
                  style: const TextStyle(fontSize: 11, color: Colors.red)),
            ),
        ],
      );
    });
  }
}