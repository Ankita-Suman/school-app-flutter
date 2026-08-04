// coverage:ignore-file
import 'package:flutter/material.dart';

/// A list of custom color used in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class ColorsValue {
  /// Colors
  static Color primaryColor = Color(
    primaryColorHex,
  );

 static Color primaryColorTextHint = Color(
   primaryColorOpacity,
  );

static Color blueBgClr = const Color(
  blueBg,
  );

  static const Color transparent = Colors.transparent;

  static const Color skipBlueColor = Color(
    skipBlue,
  );

  static Color greyColor = Color(
    greyColorHex,
  );
  static const Color blackColor = Color(
    blackColorHex,
  );

  static const Color whiteColor = Color(
    whiteColorHex,
  );

  static const Color greyDescriptionColor = Color(
    greyDescription,
  );

  static const lightBorderBlueColor = Color(
    lightBorderBlue,
  );
  static const lightBorderOrangeColor = Color(
    lightBorderOrange,
  );
  static const lightPurpleClrs = Color(
    lightPurpleClr,
  );
  static const darkFillBlueColor = Color(
    darkFillBlue,
  );

  static const darkGryBlueClr = Color(
    darkGryBlue,
  );
  static const darkGryClr = Color(
    darkGry,
  );
  static const darkGryLightClr = Color(
    darkGryLight,
  );
  static const darkBlueClr = Color(
    darkBlueC,
  );

  static const Color bordersColor =  Color(
    borders,
  );

  static const Color lightBgPinkClr = Color(
    lightBgPink,
  );

  static const Color navIconColor = Color(
    navColor,
  );
  static const Color redClrs = Color(
    redClr,
  );
  static const Color blcColors = Color(
    blcColor,
  );
  static const Color navSelectColor = Color(
    navSelectedColor,
  );
  static const Color navBgColors = Color(
    navBgColor,
  );
  static const Color bgSkyColors = Color(
    bgSkyColor,
  );
  static const Color cardBorderColor = Color(
    cardBorder,
  );
  static const Color darkOrangeColor = Color(
    darkOrange,
  );
  static const Color lightOrangeColors = Color(
    lightOrangeClr,
  );
  static const Color txtClrs = Color(
    txtClr,
  );
  static const Color txtPinkClrs = Color(
    txtPinkClr,
  );
  static const Color txtBlueClrs = Color(
    txtBlueClr,
  );
static const Color txtGrClrs = Color(
  txtGrClr,
  );

  static const Color txtGreenClrs = Color(
    txtGreenClr,
  );
  static const Color txtRdClrs = Color(
    txtRdClr,
  );
  static const Color txtOrangeClrs = Color(
    txtOrangeClrss,
  );
  static const Color txtDarkOrangeClrs = Color(
    txtDarkOrangeClr,
  );
  static const Color txtRedClrs = Color(
    txtRedClr,
  );
  static const Color unSelectedClr = Color(
    unSelectedColor,
  );
  static const Color blueColorss = Color(
    blueColors,
  );
  static const Color cardBorderSkyClr = Color(
    cardBorderSky,
  );
  static const Color lightOrangeClrss = Color(
    lightOrangeClrs,
  );
  static const Color lightBgOrangeClrss = Color(
    lightBgOrangeClrs,
  );
  static const Color bgColors = Color(
    bgColor,
  );
  static const Color bgBlueColors = Color(
    bgBlueColor,
  );
  static const Color titleGreenColors = Color(
    titleGreen,
  );
  static const Color titleRedColors = Color(
    titleRed,
  );
  static const Color txtOrangeClr = Color(
    txtOrange,
  );
  static const Color titleGreenBlackClr = Color(
    titleGreenBlack,
  );
  static const Color lightYellowClr = Color(
    lightYellow,
  );
  static const Color blcGryClr = Color(
    blcGryColor,
  );
  // ===========================================================================

  /// Hex Values
  ///
  ///
  static int primaryColorHex = 0xff007CB6;
  static int primaryColorOpacity = 0xff990E265D;
  static const int skipBlue = 0xff0057FF;
  static const int txtOrange = 0xff92400E;
  static const int blueBg = 0xff1B1E28;
  static const int borders = 0xffD9D9D9;
  static const int lightYellow = 0xffFEEA71;
  static int greyColorHex = 0xff4E5568;
  static const int blackColorHex = 0xff000000;
  static const int whiteColorHex = 0xffffffff;
  static const int titleGreenBlack = 0xff047857;
  static const int titleBlack1 = 0xff111111;
  static const int titleBlack2 = 0xff171717;
  static const int titleGreen = 0xff86EFAC;
  static const int titleRed = 0xffFF8888;
  static const int otpBorder = 0xffD2D2D2;
  static const int lightGrey = 0xff5A5A5A;
  static const int lightGreyDivider = 0xffE0E0E0;
  static const int greyBorder = 0xffE9E9E9;
  static const int lightOrange = 0xffFFF3EC;
  static const int lemonColor = 0xffF4F6EA;
  static const int learnMoreViolet = 0xffBE8CB2;
  static const int redColorDeleteHex = 0xffEB5459;
  static const int infoTitle = 0xff585858;
  static const int infoHint = 0xff9B9B9B;
  static const int genderUnselected = 0xff969696;
  static const int greyDescription = 0xff5F5F5F;
  static const int skipLightGrey = 0xff9F9F9F;
  static const int redeemBorder = 0xffEFEDED;
  static const int redeemColor = 0xffF9F9F9;
  static const int redeemDescBlack = 0xff505050;
  static const int selectedItem = 0xff8373A4;
  static const int unSelectedItem = 0xffB7B7B7;
  static const int homeBlackTitle = 0xff020202;
  static const int homeGreyAddress = 0xff555555;
  static const int ratingGrey = 0xff747474;
  static const int profileTitleBlack = 0xff4B4B4B;
  static const int dividerColor = 0xffEDEAEA;
  static const int lightGreyDividerColorHex = 0xffF6F6F6;
  static const int gryColorHex = 0xffE8E8E8;
  static const int gryBgHex = 0xffF8F8F8;
  static const int greyGuest = 0xff9A9A9A;
  static const int disablePrimaryColorHex = 0xffd7d7d7;
  static const int disableGrey = 0xffCCCCCC;
  static const int tabUnselected = 0xffEBEBEB;
  static const int tabSelected = 0xff736296;
  static const int tabUnselectedText = 0xff606060;
  static const int blackContentTitle = 0xff111111;
  static const int blackEverything = 0xff171717;
  static const int greyDivider = 0xffF2F2F2;
  static const int skyLightColorHex = 0xff007AFF;
  static const int greySearch = 0xff949494;
  static const int pinkHintColorHex = 0xffF5E9F2;
  static const int greyBackground = 0xffF8F8F8;
  static const int violetBg = 0xffF2F1F7;
  static const int violetBorder = 0xffDAD6E9;
  static const int orangeOff = 0xffFF872F;
  static const int yellow = 0xffFFAE25;
  static const int blackTile = 0xff18202A;
  static const int greyTile = 0xff66686A;
  static const int addressBg = 0xffF7F6F9;
  static const int blackGrey = 0xff3B3B3B;
  static const int lightBlack = 0xff313131;
  static const int categoryGreyBorder = 0xffDEDEDE;
  static const int lightPurple = 0xffF4F2FF;
  static const int subGrey = 0xff747576;
  static const int greyOff = 0xffA8A8A8;
  static const int dollarBlack = 0xff454545;
  static const int orange = 0xffF5A368;
  static const int lightGreen = 0xffE9EED7;
  static const int lightOrangeBg = 0xffFFECDF;
  static const int lightViolet = 0xffEADAE6;
  static const int darkGreen = 0xff859548;
  static const int darkOrangeBg = 0xffDE8E54;
  static const int darkViolet = 0xffA57499;
  static const int lightBorderBlue = 0xff85B7EB;
  static const int lightBorderOrange = 0xffD97706;
  static const int lightPurpleClr = 0xff7C3AED;
  static const int darkFillBlue = 0xff378ADD;
  static const int navColor = 0xff124A82;
  static const int redClr = 0xffEF4444;
  static const int blcColor = 0xff0D1B2A;
  static const int blcGryColor = 0xff757575;
  static const int navSelectedColor = 0xffE6F1FB;
  static const int navBgColor = 0xffEFF6FF;
  static const int bgSkyColor = 0xffB5D4F4;
  static const int cardBorder = 0xffDEE9F4;
  static const int darkOrange = 0xffEA580C;
  static const int lightOrangeClr = 0xffFED7AA;
  static const int txtClr = 0xff717477;
  static const int txtPinkClr = 0xffEC4899;
  static const int txtBlueClr = 0xff124A82;
  static const int txtGrClr = 0xff0D9488;
  static const int txtGreenClr = 0xff059669;
  static const int txtRdClr = 0xffFF7F7F;
  static const int txtOrangeClrss = 0xffF97316;
  static const int txtDarkOrangeClr = 0xffB91C1C;
  static const int txtRedClr = 0xffDC2626;
  static const int unSelectedColor = 0xff383838;
  static const int blueColors = 0xff2D8CFF;
  static const int cardBorderSky = 0xffF4F8FD;
  static const int lightOrangeClrs = 0xffFDE68A;
  static const int lightBgOrangeClrs = 0xffFFFBEB;
  static const int bgColor = 0xff124D8C;
  static const int bgBlueColor = 0xff2070C8;
  static const int darkBlue = 0xff7769AC;
  static const int darkGryBlue = 0xff4A6080;
  static const int darkGry = 0xff4C4C4C;
  static const int darkGryLight = 0xff8AA0B8;
  static const int darkBlueC = 0xff185FA5;
  static const int lightBlue = 0xffEFEBFF;
  static int backgroundColorHex = 0xffEEEEEE;
  static int dottedBorder = 0xffC8C8C8;
  static int red = 0xffD82B2B;
  static int violet = 0xffE9E6EF;
  static int blackSB = 0xff171616;
  static int dividerProfile = 0xffEEECED;
  static int lightPurpleBorder = 0xffCFC4F8;
  static int lightPurpleBg = 0xffF9F7FF;
  static int darkPurple = 0xff7263AA;
  static int violetBorders = 0xffE2CBDC;
  static int violetBgs = 0xffF9F4F8;
  static int black = 0xff383737;
  static int purpleOpacity = 0xffC0B9D8;
  static int calenderPurple = 0xffF8F7FA;
  static const int lightGreyTxtBackground = 0xff6F6F6F;
  static int disableGreen = 0xffE4ECC5;
  static const int redTxtBgClr = 0xffF5696D;
  static int deliveryDetailsColorHex = 0xff4472c5;
  static const int redHex = 0xffF23636;
  static const int orangeBackground = 0xffFEE8D8;
  static const int lightPurplesBackground = 0xffFECECEC;
  static const int orangeTxtClrBackground = 0xffD3712A;
  static const int lightGreenColorHe = 0xffD0DBA0;
  static const int redLightColorHexa = 0xffFFD9D9;
  static const int orgBgClr = 0xffF9D3B6;
  static const int lightSkyBlue = 0xffC1CAEA;
  static const int bgColorRedHax = 0xffFCC2C3;
  static const int lightSky = 0xffEEF5FF;
  static const int blueTextClr = 0xff6371BF;
  static const int greenTextClr = 0xff80962B;
  static const int darkGryColorHe = 0xff777777;
  static int lightGrColorHex = 0xff464646;
  static const int lightBlackColorHexa = 0xff3C3C3C;
  static const int lightGreyBlack = 0xff5D5D5D;
  static const int addressBorder = 0xff8174B289;
  static const int lightDarkGreen = 0xffC0CB8F;
  static const int lightLightGreen = 0xffEAF0D2;
  static const int pendingRed = 0xffEB8E4A;
  static const int declineBgRed = 0xffFFECEC;
  static const int canceledBgGrey = 0xffECECEC;
  static const int serachText = 0xff182138;
  static const int ratingColor = 0xffFFAE15;
  static const int redReport = 0xffFF3B30;
  static const int blackOffer = 0xff2F2B2B;
  static const int lightBgPink = 0xffFEF2F2;
  static const int redeemGrey = 0xff868585;
  static const int redeemOnGrey = 0xffB3B2B2;
  static const int redeemCodeGrey = 0xff8D8B8B;
  static const int redeemCardCodeGrey = 0xffB5B4B4;
  static const int redeemCardValidGrey = 0xff6F6E6E;
  static const int redeemCardAmountGrey = 0xff706F6F;

}
