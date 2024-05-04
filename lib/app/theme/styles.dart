import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';

/// A chunk of styles used in the application.
/// Will be ignored for test since all are static values and would not change.
abstract class Styles {

  static TextStyle redR20 = TextStyle(
      color: ColorsValue.redReportHex,
      fontFamily: 'Inter',
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w400);


  static TextStyle tabUnselectedSB16 = TextStyle(
      color: ColorsValue.tabUnselectedTextColor,
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w600);

  static TextStyle tabSelectedSB16 = TextStyle(
      color: ColorsValue.tabSelectedColor,
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w600);

  static TextStyle greySB14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.skipLightGreyColor);

  static TextStyle blackContentSB14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blackContentTitleColor);

  static TextStyle greyReg14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.infoTitleColor);
  static TextStyle greyEMed14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.infoTitleColor);
  static TextStyle greyReg12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.infoTitleColor);

  static TextStyle greyReg13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.greyDescriptionColor);

  static TextStyle blueDarkHintReg12 = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.primaryColorTextHint);

  static TextStyle skyBlueDark14 = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.skipBlueColor);

  static TextStyle greyHintReg13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.infoHintColor);

  static TextStyle greyHintReg14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.infoHintColor);

  static TextStyle greyHintMed14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.infoHintColor);

  static TextStyle greyDescReg13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.greyDescriptionColor);

  static TextStyle white23 = TextStyle(
    // color: ColorsValue.whiteColor,
    fontSize: Dimens.twentyThree,
  );

  static TextStyle white14 = TextStyle(
      // color: ColorsValue.whiteColor,
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      color: Colors.white);

  static TextStyle blackBold16 = TextStyle(
    color: ColorsValue.blackColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.bold,
    fontSize: Dimens.sixteen,
  );
  static TextStyle blackReg16 = TextStyle(
    color: ColorsValue.blackColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.sixteen,
  );
  static TextStyle blackOnBoardSB20 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twenty,
  );
  static TextStyle blacksSB14 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackSBColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fourteen,
  );
  static TextStyle blackOnBoardBold20 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twenty,
  );
  static TextStyle blackOnBoardBold13 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.thirteen,
  );
  static TextStyle lightBlackMed11 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.lightBlackColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.eleven,
  );
  static TextStyle lightBlackMed13 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.lightBlackColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.thirteen,
  );
  static TextStyle blackOnBoardSB18 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eighteen,
  );
  static TextStyle blackOnBoardB14 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.fourteen,
  );
  static TextStyle blackOnBoardSB15 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fifteen,
  );
  static TextStyle blackOnBoardMed12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );
  static TextStyle blackOnBoardSB12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twelve,
  );
  static TextStyle blackOnBoardSB11 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eleven,
  );
  static TextStyle blackOnBoardB13 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.thirteen,
  );
  static TextStyle blackOnBoardB12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twelve,
  );
  static TextStyle blackOnBoardMed13 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.thirteen,
  );
  static TextStyle blackOnBoardMed11 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.eleven,
  );
  static TextStyle blackOnBoardM12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redeemDescBlackColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );
  static TextStyle blackTitleSB18 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eighteen,
  );
  static TextStyle blackTitleSB17 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.seventeen,
  );
  static TextStyle blackTitleSB13 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.thirteen,
  );
  static TextStyle blackTitleSB15 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fifteen,
  );
  static TextStyle blackTitleB17 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.seventeen,
  );
  static TextStyle blackTitleSB12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twelve,
  );
  static TextStyle blackOnBoardSB24 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackOnBoardingColorHexColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twentyFour,
  );
  static TextStyle whiteBold14 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.fourteen,
  );
  static TextStyle whiteBold12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.twelve,
  );
  static TextStyle whiteBold8 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.eight,
  );
  static TextStyle whiteBold16 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.sixteen,
  );
  static TextStyle whiteBold15 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.fifteen,
  );
  static TextStyle whiteSB10 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.ten,
  );
  static TextStyle whiteSB12 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twelve,
  );
  static TextStyle whiteSB14 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.fourteen,
  );

  static TextStyle blackSB18 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackSB181 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor2);

  static TextStyle blackSB181W900 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w900,
      color: ColorsValue.titleBlackColor2);

  static TextStyle blackSB181W700 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleBlackColor2);

  static TextStyle black16B = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleBlackColor2);

  static TextStyle purple14Underline = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    color: ColorsValue.splashPurpleColor,
  );

  static TextStyle purple13 = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: Dimens.thirteen,
    fontWeight: FontWeight.w600,
    color: ColorsValue.splashPurpleColor,
  );

  static TextStyle blackSB20 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor);

  static TextStyle black14RegSpace = TextStyle(
    color: ColorsValue.titleBlackColor,
    fontFamily: 'Quicksand',
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );
  static TextStyle blackBold13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackReg13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackMed13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackMed12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackMed14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.titleBlackColor);

  static TextStyle darkBlue16 = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.primaryColorText);

  static TextStyle darkBlue14 = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.primaryColorText);

  static TextStyle blackBold17 = TextStyle(
      fontFamily: 'Poppins',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: Colors.black);

  static TextStyle greyMed12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.disableGreyColor);

  static TextStyle blackRedeemMed16 = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.blackColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.sixteen,
  );

  static TextStyle blackReg14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackSB14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackSB13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackM10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w500,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackM12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.lightGreyBlackColor);

  static TextStyle blackReg12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackSB16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackSB15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackSB151 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.titleBlackColor1);

  static TextStyle blackBold15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackTileColor);

  static TextStyle blacksSB13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackTileColor);

  static TextStyle grey12Medium = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.greyTileColor);

  static TextStyle grey11Medium = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w500,
      color: ColorsValue.greyTileColor);

  static TextStyle lightGreyMedium15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.lightGreyColor);

  static TextStyle blackBold14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blackOnBoardingColorHexColor);

  static TextStyle blackBold12W700 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.bold,
      color: ColorsValue.blackOnBoardingColorHexColor);

  static TextStyle blackBold11W700 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.bold,
      color: ColorsValue.blackOnBoardingColorHexColor);

  static TextStyle blackBold14W700 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackOnBoardingColorHexColor);

  static TextStyle black13Light = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.normal,
      color: ColorsValue.profileTitleBlackColor);

  static TextStyle lightGreyMedium14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.lightGreyColor);

  static TextStyle blackOfferM10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blackOfferHex);

  static TextStyle blackOfferReg13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blackOfferHex);

  static TextStyle blackOfferBold18 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackOfferHex);

  static TextStyle blackOfferBold11 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackOfferHex);

  static TextStyle blackLightW50011 = TextStyle(
    color: ColorsValue.lightGreyColor,
    fontWeight: FontWeight.w500,
    fontFamily: 'Quicksand',
    fontSize: Dimens.eleven,
  );

  static TextStyle violetLearMoreBold13 = TextStyle(
      decoration: TextDecoration.underline,
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.learnMoreVioletColor);

  static TextStyle purpleBold12 = TextStyle(
      decoration: TextDecoration.underline,
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.splashPurpleColor);

  static TextStyle purpleOpacityColorBold14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.purpleOpacityColor);

  static TextStyle whiteLight14w700 = TextStyle(
      decoration: TextDecoration.underline,
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.learnMoreVioletColor);

  static TextStyle violetSB14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.learnMoreVioletColor);

  static TextStyle violetSB16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.learnMoreVioletColor);

  static TextStyle genderUnselectedSB14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.genderUnselectedColor);

  static TextStyle whiteSB14Selected = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: Colors.white);

  static TextStyle genderM16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.genderUnselectedColor);

  static TextStyle greenBold10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkGreenColor);

  static TextStyle orangeBold10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkOrangeBgColor);

  static TextStyle violetBold10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkVioletColor);

  static TextStyle violetSB10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkVioletColor);

  static TextStyle darkBlueSB10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkBlueColor);

  static TextStyle homeBlackBold15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.homeBlackTitleColor);

  static TextStyle homeGreyMed14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.homeGreyAddressColor);

  static TextStyle everythingBlackBold18 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackEverythingColor);

  static TextStyle everythingBlackBold20 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackEverythingColor);

  static TextStyle blc16SB = TextStyle(
    color: ColorsValue.blackEverythingColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: Dimens.sixteen,
  );
  static TextStyle blackMed15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blackEverythingColor);

  static TextStyle blackEBold16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackEverythingColor);

  static TextStyle blackEM14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.titleBlackColor);

  static TextStyle purpleBold13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkPurpleColor);

  static TextStyle blackEBold15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackEverythingColor);

  static TextStyle greyOffBold12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      decoration: TextDecoration.lineThrough,
      fontWeight: FontWeight.w700,
      color: ColorsValue.greyOffColor);

  static TextStyle blackDollarBold14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.dollarBlackColor);

  static TextStyle blackESB12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blackEverythingColor);

  static TextStyle blackESB13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blackEverythingColor);

  static TextStyle blackEB13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackEverythingColor);

  static TextStyle blackTileBold15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackTileColor);

  static TextStyle blackTile16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.normal,
      color: ColorsValue.blackTileColor);

  static TextStyle blackTileBold13 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackTileColor);

  static TextStyle green16 = TextStyle(
    color: Colors.green,
    fontSize: Dimens.sixteen,
  );

  static TextStyle black15 = TextStyle(
    color: ColorsValue.blackColor,
    fontSize: Dimens.fifteen,
  );

  static TextStyle lightRed12 = TextStyle(
    fontFamily: 'Quicksand',
    color: Colors.red,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
  );

  static TextStyle red16Bold = TextStyle(
    fontFamily: 'Quicksand',
    color: ColorsValue.redColorDelete,
    fontSize: Dimens.sixteen,
    fontWeight: FontWeight.w700,
  );
  static TextStyle primaryMed14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blackColor);

  static TextStyle blackGreyMed12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blackGreyColor);

  static TextStyle selectedBottomPurpleBold10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.selectedItemColor);

  static TextStyle selectedBottomPurpleBold12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.selectedItemColor);

  static TextStyle selectedBottomPurpleBold14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.selectedItemColor);

  static TextStyle unSelectedBottomPurpleBold10 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.unSelectedItemColor);

  static TextStyle ratingGreySB16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.ratingGreyColor);

  static TextStyle profileSB15 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.profileTitleBlackColor);

  static TextStyle blackBold20 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackBold28 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twentyEight,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleBlackColor);

  static TextStyle blackB16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleBlackColor);

  static TextStyle blacksBold16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blacksColor);

  static TextStyle white18 = TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    color: ColorsValue.whiteColor,
    fontSize: Dimens.eighteen,
  );

  static TextStyle white18SB = TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    color: ColorsValue.whiteColor,
    fontSize: Dimens.eighteen,
  );

  static TextStyle black13RegSpace = TextStyle(
    color: ColorsValue.titleBlackColor,
    fontFamily: 'Quicksand',
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.thirteen,
  );
  static TextStyle red14Med = TextStyle(
    color: ColorsValue.redColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );
  static TextStyle red16B = TextStyle(
    color: ColorsValue.redColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twenty,
  );
  static TextStyle red12Med = TextStyle(
    color: ColorsValue.redColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );
  static TextStyle subGreyMed12 = TextStyle(
    color: ColorsValue.subGreyColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );
  static TextStyle subGreyMed14 = TextStyle(
    color: ColorsValue.subGreyColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );
  static TextStyle subGreyMed11 = TextStyle(
    color: ColorsValue.subGreyColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.eleven,
  );
  static TextStyle subGreyBold12 = TextStyle(
    color: ColorsValue.subGreyColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.bold,
    fontSize: Dimens.twelve,
  );
  static TextStyle subGreyUnderlineMed12 = TextStyle(
    color: ColorsValue.subGreyColor,
    fontFamily: 'Quicksand',
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );
  static TextStyle greyGuestBold16 = TextStyle(
    color: ColorsValue.greyGuestColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: Dimens.sixteen,
  );
  static TextStyle greyGuestBold16U = TextStyle(
    color: ColorsValue.greyGuestColor,
    fontFamily: 'Quicksand',
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.sixteen,
  );
  static TextStyle greyGuestBold12U = TextStyle(
    color: ColorsValue.greyGuestColor,
    fontFamily: 'Quicksand',
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twelve,
  );
  static TextStyle skyLightSB16 = TextStyle(
    color: ColorsValue.skyLightColor,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.sixteen,
  );
  static TextStyle skyLightSB20 = TextStyle(
    color: ColorsValue.skyLightColor,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.twenty,
  );
  static TextStyle blackReg16Space = TextStyle(
    color: ColorsValue.blackColor,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: 'Quicksand',
    fontSize: Dimens.sixteen,
  );
  static TextStyle violetBold12 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.learnMoreVioletColor);

  static TextStyle violetBold14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.learnMoreVioletColor);
  static TextStyle violetBold16 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.learnMoreVioletColor);
  static TextStyle greyMed14 = TextStyle(
      fontFamily: 'Quicksand',
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.greySearchColor);
  static TextStyle grey13Med = TextStyle(
    color: ColorsValue.lightGreyTxtBackgroundH,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.thirteen,
  );
  static TextStyle grey10Med = TextStyle(
    color: ColorsValue.lightGreyTxtBackgroundH,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.ten,
  );
  static TextStyle greenSB10 = TextStyle(
    color: ColorsValue.greenTextCl,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.ten,
  );
  static TextStyle greenSB14 = TextStyle(
    color: ColorsValue.greenTextCl,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.fourteen,
  );
  static TextStyle pendingSB10 = TextStyle(
    color: ColorsValue.pendingRedColor,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.ten,
  );
  static TextStyle orangeSB10 = TextStyle(
    color: ColorsValue.orangeTxtClrBack,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.ten,
  );
  static TextStyle orangeSB14 = TextStyle(
    color: ColorsValue.orangeTxtClrBack,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.fourteen,
  );
  static TextStyle redSB10 = TextStyle(
    color: ColorsValue.redTxtBgClrHexa,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.ten,
  );
  static TextStyle redM12 = TextStyle(
    color: ColorsValue.redTxtBgClrHexa,
    fontWeight: FontWeight.w500,
    fontFamily: 'Quicksand',
    fontSize: Dimens.twelve,
  );
  static TextStyle darSB10 = TextStyle(
    color: ColorsValue.darkGryColor,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.eleven,
  );
  static TextStyle blueSB10 = TextStyle(
    color: ColorsValue.blueTextClrHex,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.ten,
  );
  static TextStyle gry13Med = TextStyle(
    color: ColorsValue.lightGrColor,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.thirteen,
  );
  static TextStyle blackGrySB14 = TextStyle(
    color: ColorsValue.lightBlackColorH,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.fourteen,
  );
  static TextStyle blackGrySB13 = TextStyle(
    color: ColorsValue.lightBlackColorH,
    fontWeight: FontWeight.w600,
    fontFamily: 'Quicksand',
    fontSize: Dimens.thirteen,
  );
  static TextStyle blackGrySB14Space = TextStyle(
    color: ColorsValue.lightBlackColorH,
    fontWeight: FontWeight.w600,
    height: 1.5,
    fontFamily: 'Quicksand',
    fontSize: Dimens.fourteen,
  );
  static TextStyle blackSearch14Med = TextStyle(
    color: ColorsValue.serachTextClr,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    fontSize: Dimens.fifteen,
  );
  static TextStyle redeemGreySB11 = TextStyle(
    color: ColorsValue.redeemGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eleven,
  );
  static TextStyle redeemCodeGreySB11 = TextStyle(
    color: ColorsValue.redeemCodeGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eleven,
  );
  static TextStyle redeemCardGreySB11 = TextStyle(
    color: ColorsValue.redeemCardValidGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eleven,
  );
  static TextStyle redeemCardGreySB13 = TextStyle(
    color: ColorsValue.redeemCardValidGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: Dimens.thirteen,
  );
  static TextStyle redeemCardAmountGreyHexSB14 = TextStyle(
    color: ColorsValue.redeemCardAmountGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    fontSize: Dimens.fourteen,
  );
  static TextStyle redeemGreyMed9 = TextStyle(
    color: ColorsValue.redeemOnGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.nine,
  );
  static TextStyle redeemCodeGreyMed9 = TextStyle(
    color: ColorsValue.redeemCardCodeGreyHex,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: Dimens.nine,
  );
}
