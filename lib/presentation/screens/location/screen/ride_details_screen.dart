import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_animation.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/data/controller/map/ride_map_controller.dart';
import 'package:leoparduser/data/controller/pusher/pusher_ride_controller.dart';
import 'package:leoparduser/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:leoparduser/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:leoparduser/data/repo/meassage/meassage_repo.dart';
import 'package:leoparduser/data/repo/ride/ride_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/screens/location/widgets/poly_line_map.dart';
import 'package:leoparduser/presentation/screens/location/widgets/ride_details_map_widget.dart';

class RideDetailsScreen extends StatefulWidget {
  final String rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    Get.put(RideMapController());
    Get.put(MessageRepo(apiClient: Get.find()));
    Get.put(RideMessageController(repo: Get.find()));
    final controller = Get.put(
        RideDetailsController(repo: Get.find(), mapController: Get.find()));
    Get.put(PusherRideController(
        apiClient: Get.find(),
        controller: Get.find(),
        detailsController: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData(widget.rideId);
      Get.find<PusherRideController>().subscribePusher(rideId: widget.rideId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    Get.find<PusherRideController>().clearData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(builder: (controller) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, d) async {
            if (didPop) return;
            if (Get.previousRoute == RouteHelper.rideScreen) {
              Get.back();
            } else {
              Get.offAllNamed(RouteHelper.dashboard);
            }
          },
          child: Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                controller.isLoading
                    ? SizedBox(
                        height: context.height,
                        width: double.infinity,
                        child: LottieBuilder.asset(
                            MyAnimation.rideDetailsLoadingAnimation))
                    : const PolyLineMapScreen(),
                Positioned(
                  top: 0,
                  child: SafeArea(
                    child: InkWell(
                      onTap: () {
                        if (Get.previousRoute == RouteHelper.rideScreen) {
                          Get.back();
                        } else {
                          Get.offAllNamed(RouteHelper.dashboard);
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10),
                        decoration: BoxDecoration(
                            color: MyColor.primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: MyColor.colorWhite, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: controller.isLoading
                ? Container(
                    color: MyColor.colorWhite,
                    height: context.height / 4,
                    child: const SizedBox.shrink())
                : AnimatedPadding(
                    padding: EdgeInsetsDirectional.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                    child: DraggableScrollableSheet(
                      controller: draggableScrollableController,
                      snap: true,
                      shouldCloseOnMinExtent: true,
                      expand: false,
                      initialChildSize:
                          0.5, // initial height (percentage of screen height)
                      minChildSize: 0.4, // minimum height when fully collapsed
                      maxChildSize: 0.65, // maximum height when fully expanded
                      snapSizes: [0.4, 0.5, 0.6],
                      snapAnimationDuration: Duration(milliseconds: 500),
                      builder: (context, scrollController) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return RideDetailsMapWidget(
                              scrollController: scrollController,
                              constraints: constraints,
                              draggableScrollableController:
                                  draggableScrollableController,
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
