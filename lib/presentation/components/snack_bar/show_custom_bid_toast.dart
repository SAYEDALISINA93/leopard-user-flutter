import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/model/global/bid/bid_model.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/snack_bar/bid_profile_widget.dart';

class CustomBidToast {
  static void newBid({
    required BidModel bid,
    required String currency,
    required String driverImagePath,
    required String serviceImagePath,
    required String totalRideCompleted,
    required VoidCallback accepted,
    VoidCallback? reject,
    int duration = 15,
  }) {
    if (Get.context == null) {
      Get.rawSnackbar(
        progressIndicatorBackgroundColor: MyColor.transparentColor,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
          Colors.transparent,
        ),
        messageText: messageText(
          bid: bid,
          currency: currency,
          driverImagePath: driverImagePath,
          accepted: accepted,
          reject: reject,
          serviceImagePath: serviceImagePath,
          totalRideCompleted: totalRideCompleted,
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
        reverseAnimationCurve: Curves.easeOut,
        borderColor: MyColor.primaryColor.withValues(alpha: 0.5),
        borderWidth: .5,
      );
    } else {
      Flushbar(
        messageText: messageText(
          bid: bid,
          currency: currency,
          driverImagePath: driverImagePath,
          accepted: accepted,
          reject: reject,
          serviceImagePath: serviceImagePath,
          totalRideCompleted: totalRideCompleted,
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
        borderColor: MyColor.primaryColor.withValues(alpha: 0.5),
        borderWidth: .5,
      ).show(Get.context!);
    }
  }

  static Widget messageText({
    required BidModel bid,
    required String currency,
    required String driverImagePath,
    required String serviceImagePath,
    required String totalRideCompleted,
    required VoidCallback accepted,
    VoidCallback? reject,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      '${bid.driver?.firstname} ${bid.driver?.lastname}'
                          .toCapitalized(),
                      style: boldDefault.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontLarge + 3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: Dimensions.space3),
                  Text(
                    "@${bid.driver?.username}",
                    style: regularDefault.copyWith(
                      fontSize: Dimensions.fontSmall,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              "$currency${bid.bidAmount}",
              style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
            ),
          ],
        ),
        BidProfileWidget(
          driverImage: driverImagePath,
          serviceImage: serviceImagePath,
          totalCompletedRide: totalRideCompleted,
          driver: bid.driver,
        ),
        const SizedBox(height: Dimensions.space20),
        Row(
          children: [
            Expanded(
              child: RoundedButton(
                text: MyStrings.decline,
                press: () {
                  if (reject != null) {
                    reject();
                  } else {
                    Get.back();
                  }
                },
                color: MyColor.colorGrey,
                isColorChange: true,
              ),
            ),
            const SizedBox(width: Dimensions.space20),
            Expanded(
              child: RoundedButton(
                text: MyStrings.accept,
                press: () {
                  Get.back();
                  accepted();
                },
                color: MyColor.primaryColor,
                isColorChange: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget driverProfile({
    required String id,
    required String driverImage,
    required String serviceImage,
    required String serviceName,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.toNamed(RouteHelper.driverReviewScreen, arguments: id);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 30,
              top: -10,
              child: MyImageWidget(
                imageUrl: serviceImage,
                height: 80,
                width: 80,
                boxFit: BoxFit.fitWidth,
                radius: 20,
              ),
            ),
            MyImageWidget(
              imageUrl: driverImage,
              height: 50,
              width: 50,
              radius: 25,
              boxFit: BoxFit.fitWidth,
              isProfile: true,
            ),
          ],
        ),
      ),
    );
  }
}
