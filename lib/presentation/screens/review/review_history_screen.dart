import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/review/review_controller.dart';
import 'package:leoparduser/data/repo/review/review_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/transaction_card_shimmer.dart';

class ReviewHistoryScreen extends StatefulWidget {
  final String driverId;
  const ReviewHistoryScreen({super.key, required this.driverId});

  @override
  State<ReviewHistoryScreen> createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
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
      appBar: CustomAppBar(title: 'Driver Review\'s'),
      backgroundColor: MyColor.screenBgColor,
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(
                left: Dimensions.space15,
                right: Dimensions.space15,
                top: Dimensions.space15),
            child: controller.isLoading
                ? ListView.builder(itemBuilder: (context, index) {
                    return TransactionCardShimmer();
                  })
                : (controller.reviews.isEmpty && controller.isLoading == false)
                    ? NoDataWidget()
                    : ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: Dimensions.space20),
                        itemCount: controller.reviews.length,
                        itemBuilder: (context, index) {
                          final review = controller.reviews[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.space10,
                                vertical: Dimensions.space10),
                            decoration: BoxDecoration(
                                color: MyColor.colorWhite,
                                boxShadow: MyUtils.getCardShadow(),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyImageWidget(
                                    imageUrl:
                                        '${controller.imagePath}/${review.user?.image}',
                                    height: 50,
                                    width: 50,
                                    radius: 25,
                                    isProfile: true),
                                SizedBox(width: Dimensions.space10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(review.user?.username ?? '',
                                          style: boldDefault.copyWith(
                                              color: MyColor.primaryColor)),
                                      SizedBox(height: Dimensions.space5),
                                      Text(review.review ?? '',
                                          style: lightDefault.copyWith()),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Dimensions.space10),
                                Container(
                                  decoration: BoxDecoration(
                                      color: MyColor.colorBlack,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.space20)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.space10,
                                      vertical: Dimensions.space5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          color: MyColor.colorOrange,
                                          size: Dimensions.fontLarge),
                                      const SizedBox(width: 5),
                                      Text(
                                        review.rating == '0.00'
                                            ? MyStrings.nA.tr
                                            : (review.rating ?? ''),
                                        style: boldDefault.copyWith(
                                            fontSize: Dimensions.fontDefault,
                                            color: MyColor.colorWhite),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
