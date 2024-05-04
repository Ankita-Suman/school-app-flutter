import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/choose_options/choose_options.dart';

class ChooseOptionsScreen extends StatelessWidget {
  const ChooseOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ChooseOptionsController>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<ChooseOptionsController>(
            builder: (controller) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetConstants.iSchoolLogo,
                      width: Dimens.fourHundred,
                      height: Dimens.hundred,
                      fit: BoxFit.fill),
                  SizedBox(
                    height: Dimens.twentyFive,
                  ),
                  InkWell(
                    onTap: () {
                      RouteManagement.goToLoginTeacher();
                    },
                    child: Image.asset(AssetConstants.icTeacher,
                        width: Dimens.hundredFifty,
                        height: Dimens.hundredFifty,
                        fit: BoxFit.fill),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          RouteManagement.goToLoginStudent();
                        },
                        child: Image.asset(AssetConstants.icStudent,
                            width: Dimens.hundredFifty,
                            height: Dimens.hundredFifty,
                            fit: BoxFit.fill),
                      ),
                      InkWell(
                        onTap: () {
                          RouteManagement.goToLoginParent();
                        },
                        child: Image.asset(AssetConstants.icParent,
                            width: Dimens.hundredFifty,
                            height: Dimens.hundredFifty,
                            fit: BoxFit.fill),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
