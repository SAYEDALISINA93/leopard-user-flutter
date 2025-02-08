import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/ride/active_ride/ride_history_controller.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/ride_shimmer.dart';
import 'package:leoparduser/presentation/screens/ride/widget/activeride_card.dart';
import 'package:flutter/material.dart';

class CompleteRideSection extends StatefulWidget {
  bool isInterCity;
  CompleteRideSection({super.key, required this.isInterCity});

  @override
  State<CompleteRideSection> createState() => _CompleteRideSectionState();
}

class _CompleteRideSectionState extends State<CompleteRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<RideHistoryController>().hasNext()) {
        Get.find<RideHistoryController>().getRideList(
            AppStatus.RIDE_COMPLETED.toString(),
            shouldLoading: false);
      }
    }
  }

  //
  @override
  void initState() {
    printX(Get.arguments);
    printX(widget.isInterCity);
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(RideHistoryController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller
          .initialData(
              isIntraCity: widget.isInterCity,
              status: AppStatus.RIDE_COMPLETED.toString())
          .then((v) {
        controller.getRideList(AppStatus.RIDE_COMPLETED.toString());
      });
    });
    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideHistoryController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.clearData();
          controller.getRideList(AppStatus.RIDE_COMPLETED.toString());
        },
        backgroundColor: MyColor.primaryColor,
        color: MyColor.colorWhite,
        child: controller.isLoading
            ? SingleChildScrollView(
                child: Column(
                    children:
                        List.generate(10, (index) => const RideShimmer())))
            : controller.isLoading == false && controller.rideList.isEmpty
                ? const NoDataWidget(
                    fromRide: true, text: MyStrings.noCompletedRideFound)
                : ListView.separated(
                    controller: scrollController,
                    itemCount: controller.rideList.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
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
    });
  }
}
