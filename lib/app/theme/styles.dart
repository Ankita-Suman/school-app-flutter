import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';

/// A chunk of styles used in the application.
/// Will be ignored for test since all are static values and would not change.
abstract class Styles {

  static TextStyle whiteW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.6));

static TextStyle whiteW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w600,
      color: ColorsValue.whiteColor);

  static TextStyle whiteW800 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirtyTwo,
      fontWeight: FontWeight.w800,
      color: ColorsValue.whiteColor);

static TextStyle whiteW50011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor);

static TextStyle whiteW40011Op= TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.8));

static TextStyle whiteW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor);

static TextStyle whiteW80010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w800,
      color: ColorsValue.whiteColor);

  static TextStyle darkBlueW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.navIconColor);

 static TextStyle darkBlcW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW60015 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW60013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blcColors);

 static TextStyle darkPinkW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW60014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW40010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w400,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW40013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.blcColors);

static TextStyle darkBlcW70014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

static TextStyle darkBlcW50012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blcColors);

static TextStyle darkBlcW50011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w500,
      color: ColorsValue.blcColors);

static TextStyle darkBlcW40012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.blcColors);

static TextStyle darkBlcGryW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.blcGryClr);

static TextStyle darkBlcW70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

static TextStyle darkBlcW70024 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twentyFour,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkGreenW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtGreenClrs);

 static TextStyle darkGreenW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtGreenClrs);

 static TextStyle darkGreenW70020 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtGreenClrs);

static TextStyle darkOrangeW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtOrangeClrs);

static TextStyle darkOrangeW70016 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtOrangeClrs);

static TextStyle darkOrangeW60010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.txtOrangeClrs);

static TextStyle darkRedW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtRedClrs);

static TextStyle darkRedW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtRedClrs);

static TextStyle skyBlueW50012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w500,
      color: ColorsValue.bgBlueColors);

static TextStyle skyBlueW60012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w600,
      color: ColorsValue.bgBlueColors);

static TextStyle skyBlueW70016 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgBlueColors);

static TextStyle skyBlueW70014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgBlueColors);

static TextStyle skyBlueW70032 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirtyTwo,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgBlueColors);

static TextStyle skyBlueW70020 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgBlueColors);

 static TextStyle darkBlcW70020 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW700016 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW80032 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirtyTwo,
      fontWeight: FontWeight.w800,
      color: ColorsValue.blcColors);

 static TextStyle darkBlcW70016 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blcColors);

 static TextStyle darkBlueW700Spacing = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w700,
      color: ColorsValue.navIconColor);

 static TextStyle darkPinkW70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtPinkClrs);

 static TextStyle darkGrW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtGrClrs);

 static TextStyle darkBlueW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.navIconColor);

 static TextStyle darkPinkW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.txtPinkClrs);

 static TextStyle darkGrW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.txtGrClrs);

  static TextStyle darkBlackW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlackW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlackW40014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.unSelectedClr);

static TextStyle darkBlackW70011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkGryBlueClr);

static TextStyle darkBlackW70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkGryBlueClr);

static TextStyle darkGryW60012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkGryClr);

static TextStyle darkGryW60014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkGryClr);

static TextStyle darkBlackW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      height: 1.5,
      color: ColorsValue.darkGryBlueClr);

static TextStyle darkBlackW40012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.darkGryBlueClr);

static TextStyle darkBlackW60009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkGryLightClr);

static TextStyle darkBlackW60012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w600,
      color: ColorsValue.darkGryLightClr);

static TextStyle darkBlueW500 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.darkGryLightClr);

static TextStyle darkBlueW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.darkGryLightClr);

static TextStyle darkBlueW40013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.darkGryLightClr);

static TextStyle darkBlueW40010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w400,
      color: ColorsValue.darkGryLightClr);

  static TextStyle darkGryW500 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.txtClrs);

  static TextStyle darkOrangeW800 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w800,
      color: ColorsValue.txtDarkOrangeClrs);

  static TextStyle darkGryW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtClrs);

  static TextStyle darkBlueW50012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.txtBlueClrs);

  static TextStyle darkGryW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtClrs);

  static TextStyle darkGry400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w400,
      color: ColorsValue.txtClrs);

static TextStyle darkGryW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w400,
      color: ColorsValue.txtClrs);

static TextStyle darkGryW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.txtClrs);

  static TextStyle darkGryW40011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      height: 2.5,
      color: ColorsValue.txtClrs);

static TextStyle darkGryW40014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.txtClrs);

  static TextStyle darkBlkW500 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w500,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlkW70014 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlkW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlkW600013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w400,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlkW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkOrangeW400 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: ColorsValue.txtOrangeClr);

  static TextStyle darkOrangeW700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      height: 1.5,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtOrangeClr);

  static TextStyle darkBlkW600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w600,
      color: ColorsValue.unSelectedClr);

  static TextStyle darkBlkW40010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w400,
      color: ColorsValue.unSelectedClr);

static TextStyle darkBlkW70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.unSelectedClr);

static TextStyle darkBlkW60010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w600,
      color: ColorsValue.unSelectedClr);

static TextStyle darkBlueW70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgColors);

static TextStyle darkBlueW40011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: ColorsValue.bgColors);

static TextStyle darkBlueW70011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      height: 1.5,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgColors);

static TextStyle darkBlueW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.bgColors);

static TextStyle darkBlueW80015 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.bgColors);

static TextStyle darkBlueW80026 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twentySix,
      fontWeight: FontWeight.w800,
      color: ColorsValue.bgColors);

  static TextStyle darkOrangeW8009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w800,
      color: ColorsValue.darkOrangeColor);

  static TextStyle whiteW40011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.8));

  static TextStyle whiteW70011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor);

  static TextStyle whiteW40009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.5));

  static TextStyle whiteW40010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w400,
      color: ColorsValue.lightBorderBlueColor);

static TextStyle whiteW400011 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      color: ColorsValue.lightBorderBlueColor);

  static TextStyle whiteW70015 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleGreenBlackClr);

  static TextStyle greenW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.titleGreenBlackClr);

static TextStyle blueW70012 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blueColorss);

  static TextStyle whiteW60010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.5));

  static TextStyle whiteW40013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: ColorsValue.whiteColor.withOpacity(0.6));

  static TextStyle whiteW60009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w600,
      color: ColorsValue.whiteColor.withOpacity(0.6));

  static TextStyle whiteW70009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor);

  static TextStyle whiteW4009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.6));

static TextStyle whiteW400010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w400,
      color: ColorsValue.whiteColor.withOpacity(0.6));

static TextStyle whiteW70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor.withOpacity(0.6));

static TextStyle whiteW70010W = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor);

  static TextStyle whiteBold = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.seventeen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor);

 static TextStyle whiteBold15 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.whiteColor);

static TextStyle whiteBold14600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fourteen,
      fontWeight: FontWeight.w600,
      color: ColorsValue.whiteColor);

static TextStyle orangeBold700 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w700,
      color: ColorsValue.lightBorderOrangeColor);

static TextStyle orange12500 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twelve,
      fontWeight: FontWeight.w500,
      color: ColorsValue.lightBorderOrangeColor);

static TextStyle orange11600 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eleven,
      fontWeight: FontWeight.w600,
      color: ColorsValue.lightBorderOrangeColor);

static TextStyle blueBold70009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkBlueClr);

static TextStyle blueBold70010 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.ten,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkBlueClr);

static TextStyle greenBold70009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtGreenClrs);

static TextStyle rdBold70009 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.nine,
      fontWeight: FontWeight.w700,
      color: ColorsValue.txtRdClrs);

  static TextStyle whiteExBold = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.whiteColor);

static TextStyle whiteExBold15 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.whiteColor);

static TextStyle whiteExBold15G = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.titleGreenColors);

static TextStyle whiteExBold15R = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.titleRedColors);

  static TextStyle whiteExBold26 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twentySix,
      fontWeight: FontWeight.w800,
      color: ColorsValue.whiteColor);

  static TextStyle blueExBold = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w800,
      color: ColorsValue.darkBlueClr);

 static TextStyle blueW70013 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkBlueClr);

 static TextStyle blueW60015 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.darkBlueClr);

  static TextStyle whiteExBold22 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twentyTwo,
      fontWeight: FontWeight.w800,
      color: ColorsValue.whiteColor);

  static TextStyle greyReg13 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.greyDescriptionColor);

  static TextStyle blueDarkHintReg12 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.primaryColorTextHint);

  static TextStyle skyBlueDark14 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.skipBlueColor);

  static TextStyle skyBlueDark13 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.thirteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.skipBlueColor);

  static TextStyle blueDark20 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.twenty,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blueBgClr);

  static TextStyle blackDark18 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.eighteen,
      fontWeight: FontWeight.w400,
      color: ColorsValue.blackColor);

  static TextStyle blackDark16 = TextStyle(
      fontFamily: GoogleFonts.sora().fontFamily,
      fontSize: Dimens.sixteen,
      fontWeight: FontWeight.w700,
      color: ColorsValue.blackColor);

  static TextStyle blackReg16 = TextStyle(
    color: ColorsValue.blackColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.sixteen,
  );
}
