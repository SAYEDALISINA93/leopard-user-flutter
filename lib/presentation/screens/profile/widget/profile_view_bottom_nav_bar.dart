import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/util.dart';
import '../../../components/buttons/rounded_button.dart';

class ProfileViewBottomNavBar extends StatefulWidget {
  const ProfileViewBottomNavBar({super.key});

  @override
  State<ProfileViewBottomNavBar> createState() =>
      _ProfileViewBottomNavBarState();
}

class _ProfileViewBottomNavBarState extends State<ProfileViewBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Dimensions.space50 + 25,
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        boxShadow: MyUtils.getBottomNavShadow(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space20,
          vertical: Dimensions.space10,
        ),
        child: RoundedButton(
          text: MyStrings.editProfile,
          textStyle: boldExtraLarge.copyWith(
            color: MyColor.colorWhite,
            fontSize: Dimensions.fontLarge,
          ),
          press: () {
            Get.toNamed(RouteHelper.editProfileScreen);
          },
          isOutlined: false,
        ),
      ),
    );
  }
}
