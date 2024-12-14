import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/my_color.dart';

class MyShimmerWidget extends StatelessWidget {
  Color? baseColor = MyColor.colorGrey;
  Color? highlightColor = MyColor.colorGrey;
  EdgeInsets? mergin;
  Widget child;
  MyShimmerWidget({
    super.key,
    this.baseColor,
    this.mergin,
    this.highlightColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? MyColor.colorGrey.withOpacity(0.1),
      highlightColor: highlightColor ?? MyColor.primaryColor.withOpacity(0.1),
      child: child,
    );
  }
}
