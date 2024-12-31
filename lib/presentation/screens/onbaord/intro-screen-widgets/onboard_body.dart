import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../components/divider/custom_spacer.dart';

class OnboardingPage extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String description;
  final int index;

  const OnboardingPage(
      {super.key,
      this.imagePath,
      required this.title,
      required this.description,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: ValueKey(index),
      curve: Curves.fastOutSlowIn,
      tween: Tween<double>(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.space50),
            if (imagePath != null) ...[
              Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..rotateX(value * -0.06),
                child: MyLocalImageWidget(
                  imagePath: imagePath ?? '',
                  width: double.infinity,
                  height: context.height / 3,
                  boxFit: BoxFit.contain,
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(Dimensions.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    title.tr,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: boldExtraLarge.copyWith(
                        fontSize: Dimensions.fontOverLarge,
                        fontWeight: FontWeight.w600),
                  ).animate(effects: [FadeEffect()]),
                  const SizedBox(height: 12),
                  Text(
                    description.tr,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: regularDefault.copyWith(
                        fontSize: 16, color: Color(0xFF475569)),
                  ).animate().shimmer(),
                ],
              ),
            ),
            spaceDown(Dimensions.space10),
          ],
        );
      },
    );
  }
}
