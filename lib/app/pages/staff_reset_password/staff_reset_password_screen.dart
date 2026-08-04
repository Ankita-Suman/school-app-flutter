import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/pages/staff_reset_password/staff_reset_password_controller.dart';
import 'package:school_app/app/widgets/gradient_button.dart';

class StaffResetPasswordScreen extends StatelessWidget {
  const StaffResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StaffResetPasswordController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final backgroundHeight = screenHeight < 700 ? 100.0 : 130.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ---------- Blue Header ----------
          SizedBox(
            width: double.infinity,
            height: backgroundHeight,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    AssetConstants.icBlueBg,
                    width: double.infinity,
                    height: backgroundHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.clearForm();
                            Get.back();
                          },
                          child: SvgPicture.asset(AssetConstants.icBackBg),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Reset Password',
                          style: Styles.whiteBold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------- White Content Area ----------
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(AssetConstants.icPassLock),
                    const SizedBox(height: 10),
                    Text(
                      'Create New Password',
                      style: Styles.blackDark16,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your new password must be different from previous used passwords.',
                      style: Styles.darkBlueW40013.copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // ---- Current Password (styled like ChangePasswordScreen) ----
                    _buildPasswordField(
                      label: 'Current Password',
                      hint: 'Enter current password',
                      controller: controller.currentPasswordController,
                      focusNode: controller.currentPasswordFocusNode,
                      isFocused: controller.isCurrentPasswordFocused,
                      isVisible: controller.isCurrentPasswordVisible,
                      toggleVisibility:
                          controller.toggleCurrentPasswordVisibility,
                      errorText: controller.currentPasswordError,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    const SizedBox(height: 16),

                    // ---- New Password ----
                    _buildPasswordField(
                      label: 'New Password',
                      hint: 'Enter new password',
                      controller: controller.newPasswordController,
                      focusNode: controller.newPasswordFocusNode,
                      isFocused: controller.isNewPasswordFocused,
                      isVisible: controller.isNewPasswordVisible,
                      toggleVisibility: controller.toggleNewPasswordVisibility,
                      errorText: controller.newPasswordError,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    const SizedBox(height: 16),

                    // ---- Confirm Password ----
                    _buildPasswordField(
                      label: 'Confirm New Password',
                      hint: 'Confirm new password',
                      controller: controller.confirmPasswordController,
                      focusNode: controller.confirmPasswordFocusNode,
                      isFocused: controller.isConfirmPasswordFocused,
                      isVisible: controller.isConfirmPasswordVisible,
                      toggleVisibility:
                          controller.toggleConfirmPasswordVisibility,
                      errorText: controller.confirmPasswordError,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                        if (controller.isFormValid.value) {
                          controller.resetPassword();
                        }
                      },
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // ---------- Fixed Bottom Button ----------
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Obx(
              () => Opacity(
                opacity: controller.isFormValid.value ? 1.0 : 0.5,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: GradientButton(
                    onPressed: controller.isFormValid.value &&
                            !controller.isLoading.value
                        ? () {
                            FocusScope.of(context).unfocus();
                            controller.resetPassword();
                          }
                        : () {},
                    text: controller.isLoading.value
                        ? 'Resetting...'
                        : 'Reset Password',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Password Field (exact styling from ChangePasswordScreen) ----------
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required RxBool isFocused,
    required RxBool isVisible,
    required VoidCallback toggleVisibility,
    required RxString errorText,
    required TextInputAction textInputAction,
    required void Function(String) onSubmitted,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Obx(() {
      final hasFocus = isFocused.value;
      final hasContent = controller.text.isNotEmpty;
      final isError = errorText.value.isNotEmpty;

      final borderColor = isError
          ? Colors.red
          : (hasFocus || hasContent)
              ? Colors.blue.shade700
              : Colors.grey.shade300;
      final borderWidth = (hasFocus || hasContent || isError) ? 1.5 : 1.0;
      final bgColor = isError
          ? Colors.red.shade50
          : hasFocus
              ? Colors.white
              : hasContent
                  ? Colors.blue.shade50
                  : Colors.grey.shade50;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Styles.darkGryW700),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Row(
              children: [
                // Prefix icon (lock)
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: Icon(
                    Icons.lock_outline,
                    size: screenWidth * 0.05,
                    color: (hasFocus || hasContent)
                        ? Colors.blue.shade700
                        : Colors.grey.shade500,
                  ),
                ),
                // TextField
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    obscureText: !isVisible.value,
                    textInputAction: textInputAction,
                    onSubmitted: onSubmitted,
                    style: Styles.darkBlcW400,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: Styles.darkGryW40014,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
                // Suffix visibility toggle
                IconButton(
                  icon: Icon(
                    isVisible.value ? Icons.visibility_off : Icons.visibility,
                    size: screenWidth * 0.05,
                    color: (hasFocus || hasContent)
                        ? Colors.blue.shade700
                        : Colors.grey.shade500,
                  ),
                  onPressed: toggleVisibility,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: screenWidth * 0.02),
              ],
            ),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                errorText.value,
                style: Styles.darkRedW70012,
              ),
            ),
        ],
      );
    });
  }
}
