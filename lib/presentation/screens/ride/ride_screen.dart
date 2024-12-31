import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/ride/ride_screen_settings/ride_screen_settings_controller.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/screens/ride/section/new_ride_section.dart';
import 'package:leoparduser/presentation/screens/ride/section/all_ride_section.dart';
import 'package:leoparduser/presentation/screens/ride/section/running_ride_section.dart';
import 'package:leoparduser/presentation/screens/ride/section/complete_ride_section.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool isCity = true;
  @override
  void initState() {
    isCity =
        Get.arguments != null && Get.arguments.toString() == MyStrings.city;
    Get.put(RideScreenSettingsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
          title: isCity ? MyStrings.city.tr : MyStrings.interCity.tr),
      body: GetBuilder<RideScreenSettingsController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.space20),
            child: Column(
              children: [
                Container(
                  color: MyColor.colorWhite,
                  child: DefaultTabController(
                    length: 4,
                    initialIndex: controller.selectedTab,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: MyColor.colorWhite))),
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            dividerColor: MyColor.borderColor,
                            indicator: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: MyColor.primaryColor, width: 2)),
                            ),
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                            labelColor: MyColor.primaryColor,
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            unselectedLabelColor: MyColor.colorBlack,
                            physics: const BouncingScrollPhysics(),
                            onTap: (i) {
                              controller.changeTab(i);
                            },
                            tabs: [
                              Tab(text: MyStrings.allRides.tr),
                              Tab(text: MyStrings.newRide.tr),
                              Tab(text: MyStrings.runningRide.tr),
                              Tab(text: MyStrings.completeRides.tr),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.space10),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space10),
                    child: Builder(
                      builder: (_) {
                        if (controller.selectedTab == 0) {
                          return AllRideSection(isCity: isCity);
                        }
                        if (controller.selectedTab == 1) {
                          return NewRideSection(isInterCity: isCity);
                        } else if (controller.selectedTab == 2) {
                          return RunningRideSection(isInterCity: isCity);
                        }
                        {
                          return CompleteRideSection(isInterCity: isCity);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
