import 'package:flutter/material.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  final Color color;
  final bool? onlyTop;
  final bool? onlyBottom;

  const CustomDivider({super.key, this.space = Dimensions.space20, this.color = MyColor.bodyText, this.onlyTop = true, this.onlyBottom = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        onlyTop! ? SizedBox(height: space) : const SizedBox.shrink(),
        Divider(
          color: color.withOpacity(0.2),
          height: 0.5,
          thickness: 0.5,
        ),
        onlyBottom! ? SizedBox(height: space) : const SizedBox.shrink(),
      ],
    );
  }
}
