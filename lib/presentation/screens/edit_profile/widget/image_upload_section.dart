import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';

class ImageUploadSection extends StatefulWidget {
  const ImageUploadSection({super.key});

  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.space5),
      decoration: BoxDecoration(
        color: MyColor.getCardBgColor(),
        shape: BoxShape.circle,
      ),
      child: Container(
        height: 75,
        width: 75,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.space5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Container(
              height: 55,
              width: 55,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(MyImages.profile), fit: BoxFit.fill)),
            ),
            Positioned(
              bottom: 0,
              right: 2,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 18,
                  width: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: MyColor.primaryColor, shape: BoxShape.circle),
                  child:
                      const Icon(Icons.add, color: MyColor.colorWhite, size: 9),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
