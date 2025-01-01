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
      appBar: CustomAppBar(title: 'Driver Ratings'),
      backgroundColor: MyColor.colorWhite,
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
                    : Container(
                        color: MyColor.colorWhite,
                        child: Column(
                          children: [
                            spaceDown(Dimensions.space20),
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
                                        .withOpacity(0.8))),
                            spaceDown(Dimensions.space20),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(MyStrings.riderReviews.tr,
                                  style: boldOverLarge.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.getHeadingTextColor())),
                            ),
                            spaceDown(Dimensions.space10),
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) => Container(
                                    color: MyColor.borderColor.withOpacity(0.5),
                                    height: 1),
                                itemCount: controller.reviews.length,
                                itemBuilder: (context, index) {
                                  final review = controller.reviews[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.space10,
                                        vertical: Dimensions.space10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.mediumRadius)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyImageWidget(
                                          imageUrl:
                                              '${controller.driverImagePath}/${review.ride?.user?.image}',
                                          height: 50,
                                          width: 50,
                                          radius: 25,
                                          isProfile: true,
                                        ),
                                        SizedBox(width: Dimensions.space10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          '${review.ride?.user?.firstname ?? ''} ${review.ride?.user?.lastname ?? ''}'
                                                              .toCapitalized(),
                                                          style: boldDefault
                                                              .copyWith(
                                                                  color: MyColor
                                                                      .primaryColor))),
                                                  spaceSide(Dimensions.space10),
                                                  Text(
                                                      DateConverter
                                                          .isoStringToLocalDateOnly(
                                                              review.createdAt ??
                                                                  ''),
                                                      style: lightSmall.copyWith(
                                                          color: MyColor
                                                              .primaryTextColor)),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: Dimensions.space5),
                                              SizedBox(
                                                  height: Dimensions.space5),
                                              RatingBar.builder(
                                                initialRating:
                                                    Converter.formatDouble(
                                                        review.rating ?? '0'),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: false,
                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                                itemSize: 16,
                                                onRatingUpdate: (v) {},
                                              ),
                                              SizedBox(
                                                  height: Dimensions.space5),
                                              Text(review.review ?? '',
                                                  style:
                                                      lightDefault.copyWith()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
