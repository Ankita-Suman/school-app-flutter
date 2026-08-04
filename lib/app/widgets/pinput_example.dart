// widgets/pinput_example.dart (Using Obx)
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import '../pages/new_otp_verification/new_otp_verification_controller.dart';

class PinputExample extends StatelessWidget {
  const PinputExample({super.key});

  @override
  Widget build(BuildContext context) {
    final NewOtpVerificationController controller = Get.find();

    return Obx(
          () {
        Color borderColor;
        Color backgroundColor;

        if (controller.isFocused.value) {
          borderColor = ColorsValue.darkFillBlueColor;
          backgroundColor = ColorsValue.navSelectColor;
        } else if (controller.hasText.value) {
          borderColor = ColorsValue.darkFillBlueColor;
          backgroundColor = ColorsValue.navSelectColor;
        } else {
          borderColor = Colors.grey.shade300;
          backgroundColor = Colors.grey.shade50;
        }

        final defaultPinTheme = PinTheme(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: controller.isFocused.value || controller.hasText.value ? 2 : 1,
            ),
          ),
          textStyle: Styles.darkBlueW80026
        );

        return Center(
          child: Form(
            key: controller.otpFormKey,
            child: Pinput(
              controller: controller.pinController,
              focusNode: controller.focusNode,
              length: 4,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration?.copyWith(
                  border: Border.all(
                    color: ColorsValue.darkFillBlueColor,
                    width: 2,
                  ),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration?.copyWith(
                  color: Colors.blue.shade50,
                  border: Border.all(
                    color:ColorsValue.darkFillBlueColor,
                    width: 2,
                  ),
                ),
              ),
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              onCompleted: (pin) {
                debugPrint('OTP Completed: $pin');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 3,
                    color: ColorsValue.darkFillBlueColor,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              showCursor: true,
              onChanged: (pin) {
                debugPrint('Changed PIN: $pin');
              },
            ),
          ),
        );
      },
    );
  }
}