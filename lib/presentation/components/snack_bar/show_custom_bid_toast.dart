import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:leoparduser/data/model/global/bid/bid_model.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/screens/drawer/widget/drawer_user_info_card.dart';

class CustomBidToast {
  static newBid({
    required BidModel bid,
    required String currency,
    required String imagePath,
    required VoidCallback accepted,
    VoidCallback? reject,
    int duration = 15,
  }) {
    if (Get.context == null) {
      Get.rawSnackbar(
        progressIndicatorBackgroundColor: MyColor.transparentColor,
        progressIndicatorValueColor:
            const AlwaysStoppedAnimation<Color>(Colors.transparent),
        messageText: Column(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(RouteHelper.driverReviewScreen,
                  arguments: bid.driver?.id),
              child: DrawerUserCard(
                fullName: '${bid.driver?.firstname} ${bid.driver?.lastname}',
                username: '${bid.driver?.username}',
                subtitle: "",
                rightWidget: Text(
                  "$currency${bid.bidAmount}",
                  style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
                ),
                imgWidget: MyImageWidget(
                  imageUrl: imagePath,
                  boxFit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  radius: 20,
                  isProfile: true,
                ),
                imgHeight: 40,
                imgWidth: 40,
              ),
            ),
            const SizedBox(height: Dimensions.space10),
            Row(
              children: [
                Expanded(
                    child: RoundedButton(
                  text: 'Decline',
                  press: () {
                    if (reject != null) {
                      reject();
                    } else {
                      Get.back();
                    }
                  },
                  color: MyColor.colorGrey,
                  isColorChange: true,
                )),
                const SizedBox(width: Dimensions.space10),
                Expanded(
                    child: RoundedButton(
                  text: 'Accept',
                  press: () {
                    printX('Accept from snackbar');
                    Get.back();
                    accepted();
                  },
                  color: MyColor.primaryColor,
                  isColorChange: true,
                )),
              ],
            ),
          ],
        ),
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColor.colorWhite,
        borderRadius: 4,
        margin: Get.isSnackbarOpen
            ? const EdgeInsets.only(top: Dimensions.space30)
            : const EdgeInsets.all(Dimensions.space10),
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
        messageText: Column(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(RouteHelper.driverReviewScreen,
                  arguments: bid.driver?.id),
              child: DrawerUserCard(
                fullName: '${bid.driver?.firstname} ${bid.driver?.lastname}',
                username: '${bid.driver?.username}',
                subtitle: "",
                rightWidget: Text(
                  "$currency${bid.bidAmount}",
                  style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
                ),
                imgWidget: MyImageWidget(
                  imageUrl: imagePath,
                  boxFit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  radius: 20,
                  isProfile: true,
                ),
                imgHeight: 40,
                imgWidth: 40,
              ),
            ),
            const SizedBox(height: Dimensions.space10),
            Row(
              children: [
                Expanded(
                    child: RoundedButton(
                  text: MyStrings.decline.tr,
                  press: () {
                    printX('Decline from snackbar');
                    if (reject != null) {
                      reject();
                    } else {
                      Get.back();
                    }
                  },
                  color: MyColor.colorGrey,
                  isColorChange: true,
                )),
                const SizedBox(width: Dimensions.space10),
                Expanded(
                    child: RoundedButton(
                  text: MyStrings.accept.tr,
                  press: () {
                    printX('Accept from snackbar');
                    accepted();
                  },
                  color: MyColor.primaryColor,
                  isColorChange: true,
                )),
              ],
            ),
          ],
        ),
        showProgressIndicator: true,
        margin: Get.isSnackbarOpen
            ? const EdgeInsets.only(top: Dimensions.space30)
            : const EdgeInsets.all(Dimensions.space10),
        borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        backgroundColor: MyColor.colorWhite,
        duration: Duration(seconds: duration),
        leftBarIndicatorColor: MyColor.colorWhite,
        forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }
}
