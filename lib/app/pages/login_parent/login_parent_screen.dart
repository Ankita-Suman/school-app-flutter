import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_parent.dart';

class LoginParentScreen extends StatelessWidget {
  const LoginParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginParentController>(
      builder: (controller) => Scaffold(
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
                height: Dimens.threeHundredSeventyFive,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AssetConstants.icParentHeader,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50)),
                  child: Container(
                    width: Dimens.percentWidth(1),
                    height: Dimens.percentHeight(0.63),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: Dimens.edgeInsets24_10_24_10,
                          child: Column(
                            children: [
                              Dimens.boxHeight10,
                              FormFieldWidget(
                                onTap: () async {},
                                contentPadding: Dimens.edgeInsets0_10_8_10,
                                labelText: StringConstants.mobileNumberEmail,
                                formStyle: Styles.darkBlue16,
                                textInputAction: TextInputAction.next,
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
                              Dimens.boxHeight20,
                              FormFieldWidget(
                                contentPadding: Dimens.edgeInsets0_10_8_10,
                                obscureCharacter: '\u2022',
                                textEditingController:
                                controller.passwordEditingController,
                                labelText: StringConstants.password,
                                isObscureText: !controller.isPasswordVisible,
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                formStyle: Styles.darkBlue16,
                                labelStyle: Styles.blueDarkHintReg12,
                                onChange: (String val) {
                                  controller.checkIfPasswordIsValid(val);
                                },
                                errorText: controller.passwordErrors,
                                errorStyle: Styles.lightRed12,
                                suffixIcon: InkWell(
                                    onTap: controller.updatePasswordVisibility,
                                    child: controller.isPasswordVisible
                                        ? Container(
                                            alignment: Alignment.bottomCenter,
                                            width: Dimens.thirty,
                                            height: Dimens.ten,
                                            child: SvgPicture.asset(
                                              AssetConstants.icClose,
                                            ),
                                          )
                                        : Container(
                                            alignment: Alignment.bottomCenter,
                                            width: Dimens.thirty,
                                            height: Dimens.ten,
                                            child: SvgPicture.asset(
                                              AssetConstants.iconView,
                                            ),
                                          )),
                              ),
                              Dimens.boxHeight40,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.black,
                                            value: controller.rememberMe,
                                            onChanged: (bool? value) {
                                              controller.onRememberMeChanged(value!);
                                            },
                                          ),
                                        ),
                                        Dimens.boxWidth10,
                                        Text(StringConstants.rememberMe,
                                            style: Styles.blackBold17)
                                      ]),
                                  InkWell(
                                    onTap: RouteManagement.goToForgotPassword,
                                    child: Text(
                                        StringConstants.forgotPassword,
                                        style: Styles.darkBlue14,
                                      ),
                                      ),
                                ],
                              ),
                              Dimens.boxHeight80,
                              FormSubmitWidget(
                                buttonHeight: Dimens.fourty,
                               opacity: (controller.isEmailValid &&
                                   controller.isPasswordValid)
                                     ? 1 : 0.5,
                                text: StringConstants.signIn,
                                textStyle: Styles.whiteBold16,
                                buttonColor: ColorsValue.signInButtonColor,
                                borderRadius: Dimens.five,
                                onTap: (){
                                  if(controller.isEmailValid &&
                                      controller.isPasswordValid){
                                    RouteManagement.goToHome();
                                  }else{
                                    RouteManagement.goToHome();
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
}
