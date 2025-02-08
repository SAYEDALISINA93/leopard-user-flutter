import 'package:flutter/material.dart';

class MyColor {
  static const Color primaryColor =
      Color.from(alpha: 100, red: 205, green: 0, blue: 0);
  static const Color secondaryColor = Color(0xffF6F7FE);
  //Screen
  static const Color screenBgColor = Color(0xFFF8FAFC);
  //Card
  static const Color cardBgColor = Color(0xFFFFFFFF);

  //Text
  static const Color primaryTextColor = Color(0xff262626);
  static const Color contentTextColor = Color(0xff777777);
  static const Color lineColor = Color(0xffECECEC);
  static const Color borderColor = Color(0xffD9D9D9);
  static const Color bodyTextColor = Color(0xFF747475);

  static const Color rideBlackButtonColor = Color(0xff212121);
  static const Color rideTitle = Color(0xff212121);
  static const Color rideSub = Color(0xff9E9E9E);
  static const Color bodyText = Color(0xff757575);
  static const Color bodyTextBgColor = Color(0xffF8F8F8);
  static const Color simpleBg = Color(0xFFFAFAFA);

  //Border
  static const Color rideBorderColor = Color(0xffBDBDBD);
  static const Color titleColor = Color(0xff373e4a);
  static const Color labelTextColor = Color(0xff444444);
  static const Color smallTextColor1 = Color(0xff555555);

  static const Color appBarColor = primaryColor;
  static const Color appBarContentColor = colorWhite;

  static const Color textFieldDisableBorderColor = Color(0xffCFCEDB);
  static const Color textFieldEnableBorderColor = primaryColor;
  static const Color hintTextColor = Color(0xff9e9e9e);

  static const Color primaryButtonColor = primaryColor;
  static const Color primaryButtonTextColor = colorWhite;
  static const Color secondaryButtonColor = colorWhite;
  static const Color secondaryButtonTextColor = colorBlack;

  static const Color iconColor = Color(0xff555555);
  static const Color filterEnableIconColor = primaryColor;
  static const Color filterIconColor = iconColor;

  static const Color colorWhite = Color(0xffFFFFFF);
  static const Color colorBlack = Color(0xff262626);
  static const Color colorGreen = Color(0xff28C76F);
  static const Color colorRed = Color(0xFFD92027);
  static const Color colorRed2 = Color(0xFFF33333);
  static const Color colorRed3 = Color(0xffEA5455);
  static const Color colorYellow = Color(0xFFFEC400);
  static const Color colorOrange = Colors.orange;
  static const Color colorAmber = Colors.amber;
  static const Color colorGrey = Color(0xff555555);
  static const Color colorGrey2 = Color(0xffE0E0E0);
  static const Color colorGreyIcon = Color(0xff424242);
  static const Color transparentColor = Colors.transparent;

  static const Color greenSuccessColor = greenP;
  static const Color redCancelTextColor = Color(0xFFF93E2C);
  static const Color highPriorityPurpleColor = Color(0xFF7367F0);
  static const Color pendingColor = Colors.orange;

  static const Color greenP = Color(0xFF28C76F);
  static const Color containerBgColor = Color(0xffF9F9F9);
  static const Color shadowColor = Color(0xffEAEAEA);
  static const Color ticketDateColor = Color(0xff888888);

  static Color getPrimaryColor() {
    return primaryColor;
  }

  static Color getHeaderBGColor() {
    return primaryColor;
  }

  static Color getScreenBgColor() {
    return screenBgColor;
  }

  static Color getAuthBgColor() {
    return colorWhite;
  }

  static Color getRideTitleColor() {
    return rideTitle;
  }

  static Color getRideSubTitleColor() {
    return rideSub;
  }

  static Color getBodyTextColor() {
    return bodyText;
  }

  static Color getGreyText() {
    return MyColor.colorBlack.withValues(alpha: 0.5);
  }

  static Color getAppBarColor() {
    return appBarColor;
  }

  static Color getAppBarContentColor() {
    return appBarContentColor;
  }

  static Color getHeadingTextColor() {
    return primaryTextColor;
  }

  static Color getContentTextColor() {
    return contentTextColor;
  }

  static Color getLabelTextColor() {
    return labelTextColor;
  }

  static Color getHintTextColor() {
    return hintTextColor;
  }

  static Color getTextFieldDisableBorder() {
    return textFieldDisableBorderColor;
  }

  static Color getTextFieldEnableBorder() {
    return textFieldEnableBorderColor;
  }

  static Color getPrimaryButtonColor() {
    return primaryButtonColor;
  }

  static Color getPrimaryButtonTextColor() {
    return primaryButtonTextColor;
  }

  static Color getSecondaryButtonColor() {
    return secondaryButtonColor;
  }

  static Color getSecondaryButtonTextColor() {
    return secondaryButtonTextColor;
  }

  static Color getIconColor() {
    return iconColor;
  }

  static Color getFilterDisableIconColor() {
    return filterIconColor;
  }

  static Color getSearchEnableIconColor() {
    return colorRed;
  }

  static Color getTransparentColor() {
    return transparentColor;
  }

  static Color getTextColor() {
    return colorBlack;
  }

  static Color getCardBgColor() {
    return colorWhite;
  }

  static Color getShadowColor() {
    return shadowColor;
  }

  static List<Color> symbolPlate = [
    const Color(0xffDE3163),
    const Color(0xffC70039),
    const Color(0xff900C3F),
    const Color(0xff581845),
    const Color(0xffFF7F50),
    const Color(0xffFF5733),
    const Color(0xff6495ED),
    const Color(0xffCD5C5C),
    const Color(0xffF08080),
    const Color(0xffFA8072),
    const Color(0xffE9967A),
    const Color(0xff9FE2BF),
  ];

  static getSymbolColor(int index) {
    int colorIndex = index > 10 ? index % 10 : index;
    return symbolPlate[colorIndex];
  }
}
