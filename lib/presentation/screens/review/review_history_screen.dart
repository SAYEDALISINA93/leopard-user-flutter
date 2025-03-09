import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/review/review_controller.dart';
import 'package:leoparduser/data/repo/review/review_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/transaction_card_shimmer.dart';
import 'package:leoparduser/presentation/screens/review/widget/car_information.dart';
import 'package:leoparduser/presentation/screens/review/widget/driver_revew_list.dart';

class ReviewHistoryScreen extends StatefulWidget {
  final String driverId;
  const ReviewHistoryScreen({super.key, required this.driverId});

  @override
  State<ReviewHistoryScreen> createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  bool isReviewTab = true;
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ReviewRepo(apiClient: Get.find()));
    final controller = Get.put(ReviewController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.getReview(widget.driverId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: CustomAppBar(title: 'Driver Ratings'),
      backgroundColor: MyColor.colorWhite,
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.space15,
                  right: Dimensions.space15,
                  top: Dimensions.space15),
              child: (controller.reviews.isEmpty &&
                      controller.isLoading == false)
                  ? NoDataWidget()
                  : Container(
                      color: MyColor.colorWhite,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.space10),
                                    decoration: BoxDecoration(
                                        color: MyColor.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: MyColor.colorWhite,
                                        size: 20),
                                  ),
                                ),
                                SizedBox(width: Dimensions.space10),
                              ],
                            ),
                          ),
                          spaceDown(Dimensions.space20),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.space10,
                                vertical: Dimensions.space5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius)),
                            child: Column(
                              children: [
                                MyImageWidget(
                                  imageUrl:
                                      '${controller.driverImagePath}/${controller.driver?.avatar}',
                                  height: 80,
                                  width: 80,
                                  radius: 40,
                                  isProfile: true,
                                ),
                                spaceDown(Dimensions.space10),
                                Text(controller.driver?.email ?? '',
                                    style: lightDefault.copyWith(
                                        color: MyColor.bodyText)),
                                Text(
                                    '${controller.driver?.firstname ?? ''} ${controller.driver?.lastname ?? ''}',
                                    style: semiBoldDefault.copyWith(
                                        color: MyColor.primaryColor,
                                        fontSize: 24)),
                              ],
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: double.tryParse(
                                    controller.driver?.avgRating ?? "0") ??
                                0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            itemSize: 50,
                            onRatingUpdate: (v) {},
                          ),
                          spaceDown(Dimensions.space5),
                          Text(
                              '${MyStrings.yourAverageRatingIs.tr} ${double.tryParse(controller.driver?.avgRating ?? "0") ?? 0}'
                                  .toCapitalized(),
                              style: boldDefault.copyWith(
                                  color: MyColor.getBodyTextColor()
                                      .withValues(alpha: 0.8))),
                          spaceDown(Dimensions.space20),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.space15,
                                vertical: Dimensions.space5),
                            decoration: BoxDecoration(
                                color:
                                    MyColor.colorGrey2.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isReviewTab = true;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.space15,
                                          vertical: Dimensions.space7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.mediumRadius),
                                        color: isReviewTab
                                            ? MyColor.primaryColor
                                            : MyColor.transparentColor,
                                      ),
                                      child: Center(
                                          child: Text(MyStrings.review.tr,
                                              style: boldDefault.copyWith(
                                                  color: isReviewTab
                                                      ? MyColor.colorWhite
                                                      : MyColor.primaryColor))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isReviewTab = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.space15,
                                          vertical: Dimensions.space7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.mediumRadius),
                                        color: isReviewTab
                                            ? MyColor.transparentColor
                                            : MyColor.primaryColor,
                                      ),
                                      child: Center(
                                          child: Text(MyStrings.carInfo.tr,
                                              style: boldDefault.copyWith(
                                                  color: !isReviewTab
                                                      ? MyColor.colorWhite
                                                      : MyColor.primaryColor))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isReviewTab) ...[
                            spaceDown(Dimensions.space20),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                  isReviewTab
                                      ? MyStrings.riderReviews.tr
                                      : "".tr,
                                  style: boldOverLarge.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.getHeadingTextColor())),
                            ),
                          ],
                          spaceDown(Dimensions.space10),
                          Expanded(
                              child: isReviewTab
                                  ? DriverReviewList()
                                  : CarInformation()),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
