import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';

class SocialLoginButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;
  final bool? isLoading;
  const SocialLoginButton(
      {super.key,
      required this.title,
      required this.image,
      this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 60,
          width: 55,
          decoration:
              BoxDecoration(color: MyColor.colorWhite, shape: BoxShape.circle),
          padding: const EdgeInsets.all(Dimensions.space3),
          child: isLoading!
              ? const SpinKitThreeBounce(color: MyColor.primaryColor, size: 20)
              : MyLocalImageWidget(
                  imagePath: image,
                  height: 50,
                  width: 50,
                  boxFit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
