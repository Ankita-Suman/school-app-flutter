import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
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
          leading: SizedBox(
              height: Dimens.ten,
              width: Dimens.ten,
              child: SvgPicture.asset(AssetConstants.icBackArrow,
                  height: Dimens.ten,
                  width: Dimens.ten,
                  fit: BoxFit.scaleDown)),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorsValue.primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 5),
                height: Dimens.threeHundredFourty,
                color: ColorsValue.primaryColor,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  child: Container(
                    width: Dimens.percentWidth(1),
                    height: Dimens.percentHeight(0.82),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
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
                                'Please check your email www.uihut@gmail.com to see the verification code',
                               // '${StringConstants.pleaseCheckEmail}email${StringConstants.verificationCode}',
                                style: Styles.greyDark14,
                                textAlign: TextAlign.center,
                              ),
                              Dimens.boxHeight30,
                              Align(
                                alignment:Alignment.topLeft,
                                child: Text(StringConstants.otpCode,
                              style: Styles.darkGrey16,
                              textAlign: TextAlign.start)),
                              Dimens.boxHeight20,
                              const FractionallySizedBox(
                                widthFactor: 1,
                                child: PinputExample(),
                              ),
                              Dimens.boxHeight25,
                              FormSubmitWidget(
                                buttonHeight: Dimens.fourty,
                                text: StringConstants.resetPassword,
                                textStyle: Styles.whiteBold16,
                                buttonColor: ColorsValue.signInButtonColor,
                                borderRadius: Dimens.five,
                                onTap: () {
                                 RouteManagement.goToLoginStudent();
                                },
                              ),
                              Dimens.boxHeight20,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(StringConstants.resendCode,
                                    style: Styles.greyBg14w400,),

                                  // Text('00:${NumberFormat("00").format(controller.counter)}',
                                  Text('0:126',
                                    style: Styles.greyBg14w400,),
                                ],
                              )

                            ],
                          ),
                        ),
                      ],
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

  Future openCheckEmailDialog(BuildContext context) {
    return showDialog(
         barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Dimens.boxHeight20,
                    SvgPicture.asset(AssetConstants.icOpenEmail),
                    Dimens.boxHeight30,
                    Text(
                      StringConstants.checkYouEmail,
                      style: Styles.blackDark18,
                    ),
                    Dimens.boxHeight10,
                    Text(
                      StringConstants.sendPassword,
                      style: Styles.greyDark14,
                      textAlign: TextAlign.center,
                    ),
                    Dimens.boxHeight30,
                  ],
                ),
          );
        });
  }
}

/// This is the basic usage of Pinput
/// For more examples check out the demo directory
class PinputExample extends StatefulWidget {
  const PinputExample({Key? key}) : super(key: key);

  @override
  State<PinputExample> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinputExample> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      margin: Dimens.edgeInsets5_0_5_0,
      width: 70,
      height: 56,
      textStyle: Styles.darkGrey20,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        //border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(5),
      ),
    );
    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              defaultPinTheme: defaultPinTheme,
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod:
              AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              separatorBuilder: (index) => const SizedBox(width: 8),
              // validator: (value) {
              //   return value == '2222' ? null : 'Pin is incorrect';
              // },
              // onClipboardFound: (value) {
              //   debugPrint('onClipboardFound: $value');
              //   pinController.setText(value);
              // },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
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
                 // border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  //border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
