import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/my_color.dart';

class ClickableTermsText extends StatelessWidget {
  const ClickableTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By signing up, you agree to the ',
            style: regularDefault.copyWith(color: MyColor.bodyText),
          ),
          TextSpan(
            text: 'Terms of Service',
            style: regularDefault.copyWith(
              color: MyColor.primaryColor,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Replace this with your action when 'Terms of Service' is clicked
                printx('Terms of Service clicked');
                // You can navigate to a new page or perform any action here
              },
          ),
          TextSpan(
            text: ' and ',
            style: regularDefault.copyWith(color: MyColor.bodyText),
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: regularDefault.copyWith(
              color: MyColor.primaryColor,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Replace this with your action when 'Privacy Policy' is clicked
                printx('Privacy Policy clicked');
                // You can navigate to a new page or perform any action here
              },
          ),
        ],
      ),
    );
  }
}
