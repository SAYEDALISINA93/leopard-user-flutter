import 'package:flutter/material.dart';

import '../../../core/utils/my_color.dart';

class CustomBottomSheetPlus {
  final Widget child;

  final bool isNeedPadding;
  final VoidCallback? voidCallback;
  final Color bgColor;
  final bool enableDrag;
  final bool isScrollControlled;

  CustomBottomSheetPlus({
    required this.child,
    this.isNeedPadding = true,
    this.isScrollControlled = true,
    this.enableDrag = true,
    this.voidCallback,
    this.bgColor = MyColor.colorWhite,
  });

  void show(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      elevation: 0.0,
      enableDrag: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: isNeedPadding == true
              ? const EdgeInsetsDirectional.only(
                  start: 20,
                  end: 20,
                  bottom: 30,
                  top: 8,
                )
              : EdgeInsets.zero,
          child: AnimatedPadding(
            padding: EdgeInsetsDirectional.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            child: IntrinsicHeight(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.8, // Maximum height
                ),
                child: child, // Your child widget goes here
              ),
            ),
          ),
        );
      },
    ).then((value) => voidCallback);
  }
}
