import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/review/review_controller.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/shimmer/transaction_card_shimmer.dart';

class DriverReviewList extends StatelessWidget {
  const DriverReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      builder: (controller) {
        return controller.isLoading
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return TransactionCardShimmer();
                },
              )
            : ListView.separated(
                separatorBuilder: (context, index) => Container(
                  color: MyColor.borderColor.withValues(alpha: 0.5),
                  height: 1,
                ),
                itemCount: controller.reviews.length,
                itemBuilder: (context, index) {
                  final review = controller.reviews[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.space10,
                      vertical: Dimensions.space10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${review.ride?.user?.firstname ?? ''} ${review.ride?.user?.lastname ?? ''}'
                                          .toCapitalized(),
                                      style: boldDefault.copyWith(
                                        color: MyColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                  spaceSide(Dimensions.space10),
                                  Text(
                                    DateConverter.estimatedDate(
                                        DateTime.tryParse(
                                                '${review.createdAt}') ??
                                            DateTime.now(),
                                        formatType: DateFormatType.onlyDate),
                                    style: lightSmall.copyWith(
                                      color: MyColor.primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.space5),
                              SizedBox(height: Dimensions.space5),
                              RatingBar.builder(
                                initialRating: StringConverter.formatDouble(
                                  review.rating ?? '0',
                                ),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                ignoreGestures: true,
                                itemSize: 16,
                                onRatingUpdate: (v) {},
                              ),
                              SizedBox(height: Dimensions.space5),
                              Text(
                                review.review ?? '',
                                style: lightDefault.copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}
