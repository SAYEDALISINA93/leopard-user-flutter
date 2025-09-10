import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class CustomBottomSheet {
  final Widget child;
  bool isNeedMargin;
  final VoidCallback? voidCallback;
  final Color bgColor;

  CustomBottomSheet({
    required this.child,
    this.isNeedMargin = false,
    this.voidCallback,
    this.bgColor = MyColor.colorWhite,
  });

  void customBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: MyColor.transparentColor,
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          curve: Curves.decelerate,
          child: Container(
            //       margin: isNeedMargin ? const EdgeInsets.only(left: 15, right: 15, bottom: 15) : EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.space15,
              vertical: Dimensions.space12,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: isNeedMargin
                  ? BorderRadius.circular(15)
                  : const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
            ),
            child: child,
          ),
        ),
      ),
    ).then((value) => voidCallback);
  }
}
