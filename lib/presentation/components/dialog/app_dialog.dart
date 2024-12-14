import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:get/get.dart';

class AppDialog {
  void warningAlertDialog(BuildContext context, VoidCallback press,
      {required String msgText}) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              surfaceTintColor: MyColor.transparentColor,
              backgroundColor: MyColor.getCardBgColor(),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: Dimensions.space40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
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
                          right: Dimensions.space15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: MyColor.getCardBgColor(),
                          borderRadius: BorderRadius.circular(5)),
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
                                color: MyColor.getTextColor()),
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
                                    textColor: MyColor.colorWhite),
                              )
                            ],
                          )
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
                    )
                  ],
                ),
              ),
            ));
  }
}
