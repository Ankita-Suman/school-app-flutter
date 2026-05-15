// screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/new_forgot_password/new_forgot_password.dart';
import 'package:school_app/app/pages/new_otp_verification/new_otp_verification.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/pinput_example.dart';

class NewOtpVerificationScreen extends StatelessWidget {
  const NewOtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return GetBuilder<NewOtpVerificationController>(
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // SVG Background
            SvgPicture.asset(
              AssetConstants.icBackG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.015),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            AssetConstants.icBackBg,
                          ),
                        ),
                        SizedBox(
                          height: screenWidth * 0.25,
                          width: screenWidth * 0.25,
                          child: ClipRect(
                            child: SvgPicture.asset(
                              AssetConstants.icOtps,
                              height: screenWidth * 0.25,
                              width: screenWidth * 0.25,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'OTP Verification',
                          style: Styles.whiteExBold22,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'We have sent a 6-digit OTP to your registered email address.',
                          style: Styles.whiteW40013,
                        ),
                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Card - Align Bottom Center
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
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.06),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // OTP Label
                        Text(
                          'OTP CODE',
                          style: Styles.darkGryW700,
                        ),
                        SizedBox(height: screenHeight * 0.025),

                        // Pinput Widget
                        const PinputExample(),
                        SizedBox(height: screenHeight * 0.06),

                        // Verify Button
                        Obx(
                              () => Opacity(
                            opacity: controller.isOtpComplete.value ? 1.0 : 0.5,
                            child: GradientButton(
                              onPressed: controller.isOtpComplete.value && !controller.isLoading.value
                                  ? () {
                                FocusScope.of(context).unfocus();
                                controller.verifyOtpAPI();
                              }
                                  : (){},
                              text: 'Verify OTP',
                              icon: SvgPicture.asset(
                                AssetConstants.icTik,
                                height: screenWidth * 0.035,
                                width: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),

                        // Resend OTP Timer Container - ✅ Fixed timer display
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
                          decoration: BoxDecoration(
                            color: ColorsValue.navSelectColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ColorsValue.darkFillBlueColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.enableResend ? 'Resend OTP' : 'Resend OTP in',
                                    style: Styles.darkBlackW70011,
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  // ✅ Fixed: Show timer only when enableResend is false AND counter > 0
                                   (!controller.enableResend && controller.counter > 0)?
                                    Text(
                                      '00:${controller.counter.toString().padLeft(2, '0')}',
                                      style: Styles.blueExBold,
                                    ):Text(
                                     '00:00',
                                     style: Styles.blueExBold,
                                   )
                                ],
                              ),
                              GestureDetector(
                                onTap: controller.enableResend ? controller.resendOTP : null,
                                child: SvgPicture.asset(
                                  AssetConstants.icResend,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),

                        // Rich Text - Entered wrong email? Change email
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: RichText(
                              text: TextSpan(
                                style: Styles.darkBlackW700,
                                children:  [
                                  TextSpan(
                                    text: 'Entered wrong email? ',
                                  ),
                                  TextSpan(
                                    text: 'Change email',
                                    style: Styles.darkBlueW700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                      ],
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
}