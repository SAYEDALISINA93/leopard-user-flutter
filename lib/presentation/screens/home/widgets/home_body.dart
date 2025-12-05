import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';
import 'package:leoparduser/presentation/components/shimmer/create_ride_shimmer.dart';
import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';
import 'package:leoparduser/presentation/components/shimmer/ride_services_shimmer.dart';
import 'package:leoparduser/presentation/screens/home/section/ride_create_form.dart';
import 'package:leoparduser/presentation/screens/home/section/ride_service_section.dart';
import 'package:leoparduser/presentation/screens/home/widgets/bottomsheet/ride_meassage_bottom_sheet_body.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../../core/utils/util.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/divider/custom_spacer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeBody extends StatefulWidget {
  final HomeController controller;
  const HomeBody({super.key, required this.controller});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.controller.isLoading
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: MyColor.colorWhite,
                child: const RideServiceShimmer(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.space15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.controller.isLoading == false &&
                        widget.controller.appServices.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space10,
                          vertical: Dimensions.space20,
                        ),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          boxShadow: MyUtils.getShadow2(),
                          borderRadius: BorderRadius.circular(
                            Dimensions.mediumRadius,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            MyStrings.noServiceAvailable.tr,
                            style: regularDefault.copyWith(
                              color: MyColor.bodyText,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      RideServiceSection(),
                    ],
                  ],
                ),
              ),
        spaceDown(Dimensions.space20),
        widget.controller.isLoading
            ? const CreateRideShimmer()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.space15,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(Dimensions.space12),
                    boxShadow: MyUtils.getCardTopShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.controller.rideFare.status != '-1' &&
                          widget.controller.rideFare.minAmount != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space5,
                            vertical: Dimensions.space8,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: Dimensions.space20,
                          ),
                          decoration: BoxDecoration(
                            color: MyColor.bodyTextBgColor,
                            borderRadius: BorderRadius.circular(
                              Dimensions.space5,
                            ),
                          ),
                          child: MyShimmerWidget(
                            isEnable: widget.controller.isPriceLoading,
                            child: Text(
                              MyStrings.recommendedPrice.tr.rKv({
                                "priceKey":
                                    "${widget.controller.defaultCurrencySymbol}${StringConverter.formatNumber(widget.controller.rideFare.recommendAmount.toString())}",
                                "distanceKey":
                                    "${widget.controller.rideFare.distance} ${MyStrings.km.tr}",
                              }).tr,
                              textAlign: TextAlign.center,
                              style: regularDefault.copyWith(
                                color: MyColor.bodyText,
                              ),
                            ),
                          ),
                        ).animate().shimmer(),
                      ],
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          MyStrings.findDriver.tr,
                          style: boldLarge.copyWith(
                            color: MyColor.getRideTitleColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.space10),
                      const RideCreateForm(),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: RoundedButton(
                                text: MyStrings.findDriver.tr,
                                isLoading: widget.controller.isSubmitLoading,
                                press: () {
                                  if (widget.controller.isValidForNewRide()) {
                                    widget.controller.createRide();
                                  }
                                },
                                isOutlined: false,
                              ),
                            ),
                            const SizedBox(width: Dimensions.space10),
                            InkWell(
                              onTap: () {
                                if (widget.controller.isPriceLoading == false) {
                                  CustomBottomSheet(
                                    child: const RideMassageBottomSheet(),
                                  ).customBottomSheet(context);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space12,
                                  vertical: Dimensions.space12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius,
                                  ),
                                  border: Border.all(
                                    color: MyColor.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                child: CustomSvgPicture(
                                  image: MyIcons.message,
                                  color: MyColor.primaryColor,
                                  height: 22,
                                  width: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      spaceDown(Dimensions.space15),
                    ],
                  ),
                ),
              ),
        spaceDown(Dimensions.space50 + 20),
      ],
    );
  }
}
