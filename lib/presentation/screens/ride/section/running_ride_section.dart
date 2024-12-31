import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/ride/active_ride/ride_history_controller.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/ride_shimmer.dart';
import 'package:leoparduser/presentation/screens/ride/widget/activeride_card.dart';

import '../../../../core/utils/dimensions.dart';

class RunningRideSection extends StatefulWidget {
  bool isInterCity;
  RunningRideSection({super.key, required this.isInterCity});

  @override
  State<RunningRideSection> createState() => _RunningRideSectionState();
}

class _RunningRideSectionState extends State<RunningRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<RideHistoryController>().hasNext()) {
        Get.find<RideHistoryController>()
            .getRideList(AppStatus.RIDE_RUNNING.toString());
      }
    }
  }

  //
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(RideHistoryController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller
          .initialData(
              isIntraCity: widget.isInterCity,
              status: AppStatus.RIDE_RUNNING.toString())
          .then((v) {
        controller.getRideList(AppStatus.RIDE_RUNNING.toString());
      });
    });
    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideHistoryController>(
      builder: (controller) {
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            controller.getRideList(AppStatus.RIDE_RUNNING.toString());
          },
          backgroundColor: MyColor.primaryColor,
          color: MyColor.colorWhite,
          child: controller.isLoading
              ? SingleChildScrollView(
                  child: Column(
                      children:
                          List.generate(10, (index) => const RideShimmer())))
              : controller.isLoading == false && controller.rideList.isEmpty
                  ? NoDataWidget(
                      fromRide: true, text: MyStrings.noRunningRideFound)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.space15),
                      itemCount: controller.rideList.length + 1,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        if (controller.rideList.length == index) {
                          return controller.hasNext()
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const RideShimmer())
                              : const SizedBox();
                        }
                        return ActiveRideCard(
                          ride: controller.rideList[index],
                          currency: controller.defaultCurrencySymbol,
                        );
                      },
                    ),
        );
      },
    );
  }
}
