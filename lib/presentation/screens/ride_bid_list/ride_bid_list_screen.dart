import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/ride/ride_bid_list/ride_bid_list_controller.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/ride_shimmer.dart';
import 'package:leoparduser/presentation/screens/ride_bid_list/widget/bid_card.dart';
import 'package:leoparduser/presentation/screens/ride_bid_list/widget/cancel_bottom_sheet.dart';
import 'package:leoparduser/presentation/screens/ride_bid_list/widget/ride_details_card.dart';
import 'package:flutter/material.dart';

class RideBidListScreen extends StatefulWidget {
  const RideBidListScreen({super.key});

  @override
  State<RideBidListScreen> createState() => _RideBidListScreenState();
}

class _RideBidListScreenState extends State<RideBidListScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(RideBidListController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(Get.arguments);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
        title: MyStrings.rideDetails,
        backBtnPress: () {
          Get.back();
        },
      ),
      body: GetBuilder<RideBidListController>(
        builder: (controller) {
          return RefreshIndicator(
            color: MyColor.primaryColor,
            backgroundColor: MyColor.colorWhite,
            onRefresh: () async {
              controller.getRideBidList(controller.ride.id.toString(),
                  isShouldLoading: false);
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: Dimensions.screenPaddingHV,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: LinearProgressIndicator(
                              color: MyColor.primaryColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.mediumRadius)),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 120,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: MyColor.screenBgColor,
                                    borderRadius: BorderRadius.circular(2)),
                                child: Center(
                                    child: Text(MyStrings.findingDrivers.tr,
                                        style: boldDefault.copyWith()))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.isLoading
                      ? const RideShimmer()
                      : RideDetailsCard(
                          ride: controller.ride,
                          currency: controller.defaultCurrencySymbol,
                          callback: () {
                            CustomBottomSheet(
                              child: const CancelBottomSheet(),
                            ).customBottomSheet(context);
                          },
                        ),
                  const SizedBox(height: Dimensions.space20),
                  Text(MyStrings.bidList.tr,
                      style: regularExtraLarge.copyWith()),
                  const SizedBox(height: Dimensions.space10),
                  if (controller.bids.isNotEmpty) ...[
                    Column(
                      children: List.generate(
                        controller.bids.length,
                        (index) => BidCard(
                            bid: controller.bids[index],
                            ride: controller.ride,
                            currency: controller.defaultCurrencySymbol),
                      ),
                    )
                  ] else ...[
                    NoDataWidget(
                        fromRide: false, text: 'No bid found', margin: 20)
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
