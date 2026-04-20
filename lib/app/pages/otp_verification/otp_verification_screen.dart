import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'otp_verification.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpVerificationController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsValue.primaryColor,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SizedBox(
              height: Dimens.ten,
              width: Dimens.ten,
              child: SvgPicture.asset(
                AssetConstants.icBackArrow,
                height: Dimens.ten,
                width: Dimens.ten,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true, // Set to true to adjust when keyboard opens
        backgroundColor: ColorsValue.primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 5),
                height: Dimens.threeHundred,
                color: ColorsValue.primaryColor,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  child: Container(
                    width: Dimens.percentWidth(1),
                    height: Dimens.percentHeight(0.82),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView( // Added SingleChildScrollView
                      physics: const ClampingScrollPhysics(), // Smooth scrolling
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: Dimens.edgeInsets24_10_24_10,
                            child: Column(
                              children: [
                                Dimens.boxHeight30,
                                Text(
                                  StringConstants.otpVerification,
                                  style: Styles.blueDark20,
                                ),
                                Dimens.boxHeight20,
                                Text(
                                  'Please check your email to see the verification code',
                                  style: Styles.greyDark14,
                                  textAlign: TextAlign.center,
                                ),
                                Dimens.boxHeight30,
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    StringConstants.otpCode,
                                    style: Styles.darkGrey16,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Dimens.boxHeight20,
                                PinputExample(
                                  pinController: controller.pinController,
                                  formKey: controller.otpFormKey,
                                  focusNode: controller.focusNode,
                                ),
                                Dimens.boxHeight30,
                                // Button with Obx for reactive updates
                                Obx(() => Opacity(
                                  opacity: controller.isOtpComplete.value ? 1.0 : 0.5,
                                  child: FormSubmitWidget(
                                    buttonHeight: Dimens.fourtyFive,
                                    text: StringConstants.verifyOtp,
                                    textStyle: Styles.whiteBold16,
                                    buttonColor: ColorsValue.signInButtonColor,
                                    borderRadius: Dimens.five,
                                    onTap: controller.isOtpComplete.value
                                        ? () {
                                      FocusScope.of(context).unfocus();

                                      controller.verifyOtpAPI();
                                    }
                                        : null,
                                  ),
                                )),
                                Dimens.boxHeight20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (controller.enableResend) {
                                          controller.resendOTP();
                                        }
                                      },
                                      child: Text(
                                        StringConstants.resendCode,
                                        style: TextStyle(
                                          color: controller.enableResend
                                              ? ColorsValue.primaryColor
                                              : Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '00:${NumberFormat("00").format(controller.counter)}',
                                      style: Styles.greyBg14w400,
                                    ),
                                  ],
                                ),
                                // Add extra bottom padding for small devices
                                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinputExample extends StatelessWidget {
  const PinputExample({
    Key? key,
    required this.pinController,
    required this.formKey,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController pinController;
  final GlobalKey<FormState> formKey;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      margin: Dimens.edgeInsets5_0_5_0,
      width: 70,
      height: 56,
      textStyle: Styles.darkGrey20,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Pinput(
            defaultPinTheme: defaultPinTheme,
            controller: pinController,
            focusNode: focusNode,
            separatorBuilder: (index) => const SizedBox(width: 8),
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) {
              debugPrint('onCompleted: $pin');
              FocusScope.of(context).unfocus();
            },
            onChanged: (value) {
              debugPrint('onChanged: $value');
            },
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyBorderWith(
              border: Border.all(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}