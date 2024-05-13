import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/choose_options/choose_options.dart';

class ChooseOptionsScreen extends StatelessWidget {
  const ChooseOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<ChooseOptionsController>(
            builder: (controller) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageContainer(
                  width: Dimens.fourHundred,
                  // height: Dimens.hundred,
                  assetPath: AssetConstants.iSchoolLogo,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: Dimens.twentyFive,
                ),
                InkWell(
                  onTap: () {
                    RouteManagement.goToLoginTeacher();
                  },
                  child: SizedBox(
                    width: Dimens.hundredFifty,
                    height: Dimens.hundredFifty,
                    child:  const ImageContainer(
                        assetPath:AssetConstants.icTeacher,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        RouteManagement.goToLoginStudent();
                      },
                      child: SizedBox(
                        width: Dimens.hundredFifty,
                        height: Dimens.hundredFifty,
                        child:  const ImageContainer(
                            assetPath:AssetConstants.icStudent,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        RouteManagement.goToLoginParent();
                      },
                      child: SizedBox(
                        width: Dimens.hundredFifty,
                        height: Dimens.hundredFifty,
                        child:  const ImageContainer(
                            assetPath:AssetConstants.icParent
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),),
      );
}
