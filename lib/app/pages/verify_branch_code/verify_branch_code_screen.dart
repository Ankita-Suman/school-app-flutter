// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/pages/verify_branch_code/verify_branch_code_controller.dart';
import '../../widgets/gradient_button.dart';

class VerifyBranchCodeScreen extends StatelessWidget {
  const VerifyBranchCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final VerifyBranchCodeController controller =
    Get.put(VerifyBranchCodeController(Get.find()), permanent: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // ✅ Logo Top Center (Size Increased)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.09),
                child: Image.asset(
                  AssetConstants.iclogo,
                  height: screenWidth * 0.55, // 🔼 Increased from 0.35 to 0.45
                  width: screenWidth * 0.55,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom Card
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
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔼 Top Spacing Increased (Card ko lamba karne ke liye)
                          SizedBox(height: screenHeight * 0.05),

                          // ✅ 2 Lines Message
                          Text(
                            'Welcome Back 👋',
                            style: Styles.darkBlcW70020.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please enter your branch code first to verify your school and continue.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: GoogleFonts.sora().fontFamily,
                              height: 1.4,
                            ),
                          ),

                          // 🔼 Spacing Increased (Text aur Field ke bich)
                          SizedBox(height: screenHeight * 0.05),

                          // Branch code field
                          _buildBranchCodeField(
                              controller, screenWidth, screenHeight),

                          // 🔼 Spacing Increased (Field aur Button ke bich)
                          SizedBox(height: screenHeight * 0.08),

                          // Verify Button
                          _buildVerifyButton(
                              controller, screenWidth, screenHeight),

                          // 🔼 Bottom Spacing Increased
                          SizedBox(height: screenHeight * 0.06),
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

  // ---- Branch Code Field ----
  Widget _buildBranchCodeField(VerifyBranchCodeController controller,
      double screenWidth, double screenHeight) {
    return Obx(() {
      final hasError = controller.branchCodeError.value.isNotEmpty;
      final isVerified = controller.isBranchVerified.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BRANCH CODE',
              style: Styles.darkGryW700.copyWith(fontSize: 13)),
          SizedBox(height: screenHeight * 0.012), // Thoda spacing badhaya
          Container(
            decoration: BoxDecoration(
              color: controller.isBranchCodeFocused.value
                  ? Colors.white
                  : (controller.branchCodeController?.text.isNotEmpty == true
                  ? Colors.blue.shade50
                  : Colors.grey.shade50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (isVerified
                    ? Colors.green
                    : (controller.isBranchCodeFocused.value ||
                    controller.branchCodeController?.text
                        .isNotEmpty ==
                        true)
                    ? Colors.blue.shade700
                    : Colors.grey.shade300),
                width: hasError
                    ? 1.5
                    : (isVerified
                    ? 1.5
                    : (controller.isBranchCodeFocused.value ||
                    controller.branchCodeController?.text
                        .isNotEmpty ==
                        true)
                    ? 1.5
                    : 1),
              ),
            ),
            child: TextField(
              controller: controller.branchCodeController,
              focusNode: controller.branchCodeFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: Styles.darkBlcW400,
              onChanged: (value) => controller.validateBranchCode(value),
              onSubmitted: (value) => controller.verifyBranchCode(),
              decoration: InputDecoration(
                hintText: 'Enter branch code (e.g., ASDF34UYGHS)',
                hintStyle: Styles.darkGryW40014,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.022), // Height thodi badhayi
                prefixIcon: Icon(
                  Icons.lock,
                  size: screenWidth * 0.05,
                  color: hasError
                      ? Colors.red
                      : (isVerified
                      ? Colors.green
                      : (controller.isBranchCodeFocused.value ||
                      controller.branchCodeController?.text
                          .isNotEmpty ==
                          true)
                      ? Colors.blue.shade700
                      : Colors.grey.shade500),
                ),
                suffixIcon: controller.isLoading.value
                    ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue.shade700,
                    ),
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
        ],
      );
    });
  }

  // ---- Verify Button ----
  Widget _buildVerifyButton(VerifyBranchCodeController controller,
      double screenWidth, double screenHeight) {
    return Obx(() {
      final isEnabled = controller.isBranchCodeValid.value &&
          !controller.isLoading.value &&
          !controller.isBranchVerified.value;
      return Opacity(
        opacity: isEnabled || controller.isBranchVerified.value ? 1.0 : 0.5,
        child: SizedBox(
          width: double.infinity,
          height: 50, // Button ki height fix kar di taaki touch easy ho
          child: GradientButton(
            onPressed: controller.isBranchVerified.value
                ? () {}
                : (isEnabled
                ? () {
              FocusScope.of(Get.context!).unfocus();
              controller.verifyBranchCode();
            }
                : () {}),
            text:
            controller.isBranchVerified.value ? 'Verified' : 'Verify Code',
            icon: Icon(
              controller.isBranchVerified.value
                  ? Icons.check_circle
                  : Icons.verified_user,
              size: screenWidth * 0.05,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}