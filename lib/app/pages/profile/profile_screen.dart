import 'package:flutter_svg/svg.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
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
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: Dimens.edgeInsets20_55_20_10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: Get.back,
                              child: SizedBox(
                                  height: Dimens.twenty,
                                  width: Dimens.twenty,
                                  child: SvgPicture.asset(
                                      AssetConstants.icBackArrow,
                                      height: Dimens.twenty,
                                      width: Dimens.twenty,
                                      fit: BoxFit.scaleDown))),
                          Text(StringConstants.profile, style: Styles.white30B),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: Dimens.edgeInsets0_5_0_0,
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: SvgPicture.asset(
                                        AssetConstants.icHomeNotification)),
                              ),
                              Dimens.boxHeight10,
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: Dimens.edgeInsets5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Dimens.boxHeight10,
                              Container(
                                width: Dimens.percentWidth(1),
                                margin: EdgeInsets.only(
                                    left: Dimens.ten,
                                    top: 0.0,
                                    right: Dimens.ten,
                                    bottom: Dimens.eight),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    color: ColorsValue.lightSkyBgClr,
                                    border: Border.all(
                                      color: ColorsValue.primaryColor,
                                      width: 1,
                                    )),
                                child: Padding(
                                  padding: Dimens.edgeInsets5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // FIX: Row mein Expanded add kiya
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center, // Center alignment
                                        children: [
                                          // Profile Image - Fixed size
                                          Image.asset(
                                            AssetConstants.icProfile,
                                            width: Dimens.eighty,
                                            height: Dimens.eighty,
                                            fit: BoxFit.fill,
                                          ),
                                          Dimens.boxWidth10,
                                          // Middle Section - Expanded to take available space
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Dimens.boxHeight2,
                                                Text(
                                                  'Anmol Singh',
                                                  style: Styles.black20,
                                                  overflow: TextOverflow.ellipsis, // Add ellipsis for long text
                                                ),
                                                Dimens.boxHeight5,
                                                Text(
                                                  'Class II-B  |  Roll no: 04',
                                                  style: Styles.black15,
                                                  overflow: TextOverflow.ellipsis, // Add ellipsis for long text
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Camera Icon - Fixed position
                                          Padding(
                                            padding: Dimens.edgeInsets30_0_0_0,
                                            child: SvgPicture.asset(
                                              AssetConstants.icCamera,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Dimens.boxHeight10,
                              // FIX 1: Quick Action Buttons Row - Overflow Fixed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        StringConstants.information,
                                        style: Styles.black12,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        StringConstants.attendance,
                                        style: Styles.black12,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        StringConstants.result,
                                        style: Styles.black12,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        StringConstants.fees,
                                        style: Styles.black12,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: Dimens.edgeInsets5_0_5_0,
                                  child: const Divider(
                                    thickness: 2,
                                    color: ColorsValue.bordersColor,
                                  )),
                              // FIX 2: Aadhar No and Academic Year Row - Overflow Fixed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.aadharNo,
                                            style: Styles.grey12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text('1234 4325 4567 1234',
                                                    style: Styles.darkGrey12,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Padding(
                                                padding: Dimens.edgeInsets8_2_8_2,
                                                child: SvgPicture.asset(
                                                    height: Dimens.twelve,
                                                    width: Dimens.twelve,
                                                    AssetConstants.icLock),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.academicYear,
                                            style: Styles.grey12,
                                          ),
                                          Text('2020-2021',
                                              style: Styles.darkGrey12),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              // FIX 3: Admission Class and Admission No Row - Overflow Fixed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.admissionClass,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  Dimens.edgeInsets8_2_8_2,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icParler),
                                                ),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.admissionNo,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('T00221',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              // FIX 4: Date of Admission and Date of Birth Row - Overflow Fixed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.dateOfAdmission,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('01 Apr 2019',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.dateOfBirth,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('22 July 2017',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              // FIX 5: Blood Group and Phone No Row - Overflow Fixed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.bloodGroup,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('O+',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.phoneNo,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('0123456789',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              // FIX 6: Height and Weight Row - Overflow Fixed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.height,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('3.5',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.weight,
                                            style: Styles.grey12,
                                          ),
                                          SizedBox(
                                            width: Dimens.hundredFiftyFive,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('25',
                                                    style: Styles.darkGrey12),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                      height: Dimens.twelve,
                                                      width: Dimens.twelve,
                                                      AssetConstants.icLock),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.hundredFiftyFive,
                                              child: const Divider(
                                                thickness: 1,
                                                color: ColorsValue.bordersColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight20,
                              // Parent Id Row - No change needed
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StringConstants.parentId,
                                          style: Styles.grey12,
                                        ),
                                        SizedBox(
                                          width: Dimens.percentWidth(0.91),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text('parentboth84@gmail.com',
                                                    style: Styles.darkGrey12,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.bottomRight,
                                                child: SvgPicture.asset(
                                                    height: Dimens.twelve,
                                                    width: Dimens.twelve,
                                                    AssetConstants.icLock),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: ColorsValue.bordersColor,
                              ),
                              Dimens.boxHeight5,
                              // Mother Name Row
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.motherName,
                                            style: Styles.grey12,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text('Amit Singh',
                                                    style: Styles.darkGrey12,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.bottomRight,
                                                child: SvgPicture.asset(
                                                    height: Dimens.twelve,
                                                    width: Dimens.twelve,
                                                    AssetConstants.icLock),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: ColorsValue.bordersColor,
                              ),
                              Dimens.boxHeight5,
                              // Father Name Row
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.fatherName,
                                            style: Styles.grey12,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text('Preeti Singh',
                                                    style: Styles.darkGrey12,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.bottomRight,
                                                child: SvgPicture.asset(
                                                    height: Dimens.twelve,
                                                    width: Dimens.twelve,
                                                    AssetConstants.icLock),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: ColorsValue.bordersColor,
                              ),
                              Dimens.boxHeight5,
                              // Permanent Address Row
                              Padding(
                                padding: Dimens.edgeInsets10_5_10_0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstants.permanentAddress,
                                            style: Styles.grey12,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text('Ludhiana , Punjab',
                                                    style: Styles.darkGrey12,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.bottomRight,
                                                child: SvgPicture.asset(
                                                    height: Dimens.twelve,
                                                    width: Dimens.twelve,
                                                    AssetConstants.icLock),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight25,
                            ],
                          )
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