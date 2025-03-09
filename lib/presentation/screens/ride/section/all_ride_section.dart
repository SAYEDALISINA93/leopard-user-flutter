import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/ride/active_ride/ride_history_controller.dart';
import 'package:leoparduser/data/controller/ride/all_ride_controller.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/ride_shimmer.dart';
import 'package:leoparduser/presentation/screens/ride/widget/ride_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/dimensions.dart';

class AllRideSection extends StatefulWidget {
  bool isCity;
  AllRideSection({super.key, required this.isCity});

  @override
  State<AllRideSection> createState() => _AllRideSectionState();
}

class _AllRideSectionState extends State<AllRideSection> {
  ScrollController scrollController = ScrollController();
  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<AllRideController>().hasNext()) {
        Get.find<AllRideController>().getAllRide();
      }
    }
  }

  @override
  void initState() {
    printX(Get.arguments);
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    Get.put(RideHistoryController(repo: Get.find()));
    final controller =
        Get.put(AllRideController(repo: Get.find(), isCity: widget.isCity));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllRideController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.initialData();
          },
          backgroundColor: MyColor.primaryColor,
          color: MyColor.colorWhite,
          child: controller.isLoading
              ? SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: Dimensions.space10),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: List.generate(10, (index) => const RideShimmer()),
                  ),
                )
              : controller.isLoading == false && controller.rideList.isEmpty
                  ? NoDataWidget(fromRide: true, text: MyStrings.noRideFound)
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: controller.rideList.length + 1,
                      itemBuilder: (context, index) {
                        if (controller.rideList.length == index) {
                          return controller.hasNext()
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const RideShimmer())
                              : const SizedBox();
                        }
                        return RideCard(
                          currency: controller.defaultCurrencySymbol,
                          ride: controller.rideList[index],
                        );
                      },
                    ),
        );
      },
    );
  }
}
