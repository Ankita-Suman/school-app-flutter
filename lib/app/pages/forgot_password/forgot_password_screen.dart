import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot_password.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
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
                                StringConstants.forgotPasswordText,
                                style: Styles.blueDark20,
                              ),
                              Dimens.boxHeight20,
                              Text(
                                StringConstants.enterMobileNumber,
                                style: Styles.greyDark14,
                                textAlign: TextAlign.center,
                              ),
                              Dimens.boxHeight30,
                              FormFieldWidget(
                                onTap: () async {},
                                contentPadding: Dimens.edgeInsets0_10_8_10,
                                labelText: StringConstants.mobileNumberEmail,
                                formStyle: Styles.darkBlue16,
                                textInputAction: TextInputAction.done,
                                labelStyle: Styles.blueDarkHintReg12,
                                textInputType: TextInputType.emailAddress,
                                focusNode: controller.focusNode,
                                maxLength: 45,
                                errorText: controller.emailErrorText,
                                errorStyle: Styles.lightRed12,
                                textEditingController:
                                    controller.emailMobileEditingController,
                                onChange: (String val) {
                                  controller.checkEmailIsValid(val);
                                },
                              ),
                              Dimens.boxHeight25,
                              FormSubmitWidget(
                                buttonHeight: Dimens.fourty,
                                opacity: (controller.isEmailValid) ? 1 : 0.5,
                                text: StringConstants.resetPassword,
                                textStyle: Styles.whiteBold16,
                                buttonColor: ColorsValue.signInButtonColor,
                                borderRadius: Dimens.five,
                                onTap: () {
                                  if (controller.isEmailValid) {
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      openCheckEmailDialog(context);
                                    });
                                  } else {
                                    Get.back<dynamic>();
                                  }
                                },
                              ),
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
