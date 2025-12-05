import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_animation.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:get/get.dart';

class AppDialog {
  void warningAlertDialog(
    BuildContext context,
    VoidCallback press, {
    required String msgText,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        surfaceTintColor: MyColor.transparentColor,
        backgroundColor: MyColor.getCardBgColor(),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: Dimensions.space40,
                  bottom: Dimensions.space15,
                  left: Dimensions.space15,
                  right: Dimensions.space15,
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: MyColor.getCardBgColor(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    /*  Text(
                            MyStrings.areYouSure_.tr,
                            style: semiBoldLarge.copyWith(color: MyColor.colorRed),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),*/
                    const SizedBox(height: Dimensions.space15),
                    Text(
                      msgText.tr,
                      style: regularDefault.copyWith(
                        color: MyColor.getTextColor(),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    const SizedBox(height: Dimensions.space20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RoundedButton(
                            text: MyStrings.no.tr,
                            press: () {
                              Navigator.pop(context);
                            },
                            horizontalPadding: 3,
                            verticalPadding: 3,
                            color: MyColor.greenSuccessColor,
                            textColor: MyColor.colorWhite,
                          ),
                        ),
                        const SizedBox(width: Dimensions.space10),
                        Expanded(
                          child: RoundedButton(
                            text: MyStrings.yes.tr,
                            press: press,
                            horizontalPadding: 3,
                            verticalPadding: 3,
                            color: MyColor.redCancelTextColor,
                            textColor: MyColor.colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -30,
                left: MediaQuery.of(context).padding.left,
                right: MediaQuery.of(context).padding.right,
                child: Image.asset(
                  MyImages.warningImage,
                  height: 60,
                  width: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showRideDetailsDialog(
    BuildContext context, {
    required String title,
    required String description,
    required Function() onTap,
    Function()? onClose,
    Color? yes,
    Color? no,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.zero,
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Container(
                padding: const EdgeInsetsDirectional.only(
                  end: Dimensions.space5,
                  start: Dimensions.space5,
                  top: Dimensions.space30,
                  bottom: Dimensions.space20,
                ),
                margin: const EdgeInsets.all(Dimensions.space15 + 1),
                decoration: BoxDecoration(
                  color: MyColor.colorWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: MyColor.borderColor, width: 0.6),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraint.minHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            MyAnimation.rideDetailsLoadingAnimation,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: Dimensions.space30),
                          Text(
                            title,
                            style: semiBoldDefault.copyWith(
                              color: MyColor.titleColor,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.space5),
                          Text(
                            description,
                            style: lightDefault.copyWith(
                              color: MyColor.bodyText,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.space20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space15,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                      onTap();
                                    },
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.extraRadius,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.space15,
                                        vertical: Dimensions.space12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: yes ?? MyColor.primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.extraRadius,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          MyStrings.continue_.tr,
                                          style: boldDefault.copyWith(
                                            color: MyColor.colorWhite,
                                            fontSize: Dimensions.fontLarge,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.space10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
