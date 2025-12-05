import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/review/review_controller.dart';
import 'package:leoparduser/data/repo/review/review_repo.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/divider/custom_divider.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';

class RideReviewScreen extends StatefulWidget {
  final String rideId;
  const RideReviewScreen({super.key, required this.rideId});

  @override
  State<RideReviewScreen> createState() => _RideReviewScreenState();
}

class _RideReviewScreenState extends State<RideReviewScreen> {
  @override
  void initState() {
    Get.put(ReviewRepo(apiClient: Get.find()));
    final controller = Get.put(ReviewController(repo: Get.find()));
    super.initState();
    printX("ride id >>>${widget.rideId}");
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(widget.rideId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Get.offAllNamed(RouteHelper.dashboard);
      },
      child: Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(title: "Driver Review", isTitleCenter: true),
        body: GetBuilder<ReviewController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              child: controller.isLoading
                  ? CustomLoader(isFullScreen: true)
                  : Column(
                      children: [
                        const SizedBox(height: Dimensions.space20),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: MyColor.colorWhite,
                            border: Border.all(color: MyColor.borderColor),
                            shape: BoxShape.circle,
                          ),
                          child: MyImageWidget(
                            imageUrl:
                                controller.ride?.driver?.imageWithPath ?? '',
                            height: 85,
                            width: 85,
                            radius: 50,
                            isProfile: true,
                            errorWidget: Image.asset(
                              MyImages.defaultAvatar,
                              height: 85,
                              width: 85,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space8),
                        Text(
                          "${controller.ride?.driver?.firstname} ${controller.ride?.driver?.lastname}",
                          style: regularDefault.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: Dimensions.space8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: MyColor.colorYellow,
                                ),
                                Text(
                                  "${controller.ride?.driver?.avgRating}",
                                  style: boldDefault.copyWith(
                                    color: MyColor.colorGrey,
                                    fontSize: Dimensions.fontDefault,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: MyColor.colorGrey,
                                  width: .5,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const CustomSvgPicture(
                                  image: MyIcons.suv,
                                  color: MyColor.bodyText,
                                  height: 10,
                                  width: 15,
                                ),
                                const SizedBox(width: Dimensions.space5 - 1),
                                Text(
                                  "+${controller.ride?.driver?.dialCode}${controller.ride?.driver?.mobile}",
                                  style: boldDefault.copyWith(
                                    color: MyColor.colorGrey,
                                    fontSize: Dimensions.fontDefault,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const CustomDivider(
                          space: Dimensions.space10,
                          color: MyColor.bodyText,
                        ),
                        const SizedBox(height: Dimensions.space30),
                        Text(
                          MyStrings.ratingDriver.tr,
                          style: semiBoldDefault.copyWith(
                            fontSize: Dimensions.fontOverLarge + 2,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space20),
                        RatingBar.builder(
                          initialRating: controller.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            controller.updateRating(rating);
                          },
                        ),
                        const SizedBox(height: Dimensions.space25 - 1),
                        Text(
                          MyStrings.whatCouldBetter.tr,
                          style: mediumDefault.copyWith(
                            fontSize: Dimensions.fontOverLarge - 1,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: CustomTextField(
                            needOutlineBorder: true,
                            animatedLabel: false,
                            labelText: '',
                            onChanged: (v) {},
                            controller: controller.reviewMsgController,
                            hintText: MyStrings.reviewMsgHintText.tr,
                            maxLines: 5,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space30 + 2),
                        RoundedButton(
                          text: MyStrings.submit,
                          textColor: MyColor.colorWhite,
                          isLoading: controller.isReviewLoading,
                          press: () {
                            printX(controller.rating);
                            printX(controller.reviewMsgController.text);
                            if (controller.rating > 0 &&
                                controller
                                    .reviewMsgController.text.isNotEmpty) {
                              controller.reviewRide();
                            }
                          },
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
