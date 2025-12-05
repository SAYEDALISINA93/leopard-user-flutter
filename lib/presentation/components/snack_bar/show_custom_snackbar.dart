import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomSnackBar {
  static void error({
    required List<String> errorList,
    int duration = 5,
    SnackPosition position = SnackPosition.TOP,
  }) {
    if (errorList.isEmpty) {
      errorList = [MyStrings.somethingWentWrong.tr];
    }

    for (var i = 0; i < errorList.length; i++) {
      String message =
          StringConverter.removeQuotationAndSpecialCharacterFromString(
        errorList[i].tr,
      );
      Future.delayed(Duration(microseconds: 1000 * (i + 1)), () {
        if (Get.context == null) {
          Get.closeAllSnackbars();
          Get.rawSnackbar(
            progressIndicatorBackgroundColor: MyColor.transparentColor,
            progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
              Colors.transparent,
            ),
            messageText: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space5,
                vertical: Dimensions.space5,
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: MyColor.redCancelTextColor, size: 24)
                      .animate(
                        onComplete: (controller) => controller.repeat(
                          reverse: true,
                          period: const Duration(seconds: 1),
                        ),
                      )
                      .scale(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      ),
                  SizedBox(width: Dimensions.space10),
                  Expanded(
                    child: Text(
                      message.tr,
                      style: regularLarge.copyWith(
                        color: MyColor.redCancelTextColor,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            dismissDirection: DismissDirection.horizontal,
            snackPosition: position,
            backgroundColor: MyColor.colorRed,
            borderRadius: 4,
            margin: const EdgeInsets.all(Dimensions.space8),
            padding: const EdgeInsets.all(Dimensions.space8),
            duration: Duration(seconds: duration),
            isDismissible: true,
            forwardAnimationCurve: Curves.easeIn,
            showProgressIndicator: true,
            leftBarIndicatorColor: MyColor.transparentColor,
            animationDuration: const Duration(seconds: 1),
            borderColor: MyColor.transparentColor,
            reverseAnimationCurve: Curves.easeOut,
            borderWidth: 2,
          );
        } else {
          Flushbar(
            messageText: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space5,
                vertical: Dimensions.space5,
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: MyColor.redCancelTextColor, size: 24)
                      .animate(
                        onComplete: (controller) => controller.repeat(
                          reverse: true,
                          period: const Duration(seconds: 1),
                        ),
                      )
                      .scale(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      ),
                  SizedBox(width: Dimensions.space10),
                  Expanded(
                    child: Text(
                      message.tr,
                      style: regularLarge.copyWith(
                        color: MyColor.redCancelTextColor,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            margin: const EdgeInsets.all(Dimensions.space10),
            borderRadius: BorderRadius.circular(Dimensions.cardRadius),
            backgroundColor: MyColor.colorWhite,
            duration: Duration(seconds: duration + (i + 1)),
            leftBarIndicatorColor: MyColor.redCancelTextColor,
            forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
            isDismissible: true,
            flushbarPosition: position == SnackPosition.TOP
                ? FlushbarPosition.TOP
                : FlushbarPosition.BOTTOM,
            positionOffset:
                (i + 1) * 80.0, // Increased offset for better visibility
          ).show(Get.context!);
        }
      });
    }
  }

  static void success({
    required List<String> successList,
    int duration = 2,
    SnackPosition position = SnackPosition.TOP,
  }) {
    if (successList.isEmpty) {
      successList = [MyStrings.success.tr];
    }
    for (var i = 0; i < successList.length; i++) {
      String message = successList[i].tr;
      message =
          StringConverter.removeQuotationAndSpecialCharacterFromString(message);
      Future.delayed(Duration(microseconds: 1000 * (i + 1)), () {
        Get.closeAllSnackbars();
        Get.rawSnackbar(
          progressIndicatorBackgroundColor: MyColor.transparentColor,
          progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
            MyColor.transparentColor,
          ),
          messageText: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.space5,
              vertical: Dimensions.space5,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: MyColor.colorGreen,
                  size: 24,
                ).animate().rotate(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    ),
                SizedBox(width: Dimensions.space10),
                Expanded(
                  child: Text(
                    message.tr,
                    style: regularLarge.copyWith(color: MyColor.colorGreen),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          dismissDirection: DismissDirection.horizontal,
          snackPosition: position,
          backgroundColor: MyColor.colorWhite,
          borderRadius: 4,
          margin: const EdgeInsets.all(Dimensions.space8),
          padding: const EdgeInsets.all(Dimensions.space8),
          duration: Duration(seconds: duration + (i + 1)),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeInOutCubicEmphasized,
          showProgressIndicator: false,
          leftBarIndicatorColor: MyColor.colorGreen,
          animationDuration: const Duration(seconds: 2),
          borderColor: MyColor.transparentColor,
          reverseAnimationCurve: Curves.easeOut,
          borderWidth: 0,
          instantInit: false,
          onTap: (snack) {},
        );
      });
    }
  }
}
