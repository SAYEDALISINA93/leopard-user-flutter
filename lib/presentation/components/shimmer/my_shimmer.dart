import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/my_color.dart';

class MyShimmerWidget extends StatelessWidget {
  Color? baseColor = MyColor.colorGrey;
  Color? highlightColor = MyColor.colorGrey;
  EdgeInsets? mergin;
  Widget child;
  bool isEnable;
  MyShimmerWidget({
    super.key,
    this.baseColor,
    this.mergin,
    this.highlightColor,
    required this.child,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return isEnable
        ? Shimmer.fromColors(
            baseColor: baseColor ?? MyColor.colorGrey.withValues(alpha: 0.1),
            highlightColor: highlightColor ?? MyColor.primaryColor.withValues(alpha: 0.1),
            child: child,
          )
        : child;
  }
}
