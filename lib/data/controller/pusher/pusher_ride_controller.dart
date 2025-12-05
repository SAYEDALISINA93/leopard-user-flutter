import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'dart:convert';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/audio_utils.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:leoparduser/data/model/general_setting/general_setting_response_model.dart';
import 'package:leoparduser/data/model/global/pusher/pusher_event_response_model.dart';
import 'package:leoparduser/data/services/pusher_service.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_bid_toast.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:leoparduser/data/services/api_client.dart';

class PusherRideController extends GetxController {
  ApiClient apiClient;
  RideMessageController controller;
  RideDetailsController detailsController;

  PusherRideController({
    required this.apiClient,
    required this.controller,
    required this.detailsController,
  });

  @override
  void onInit() {
    super.onInit();
    PusherManager().addListener(onEvent);
  }

  PusherConfig pusherConfig = PusherConfig();

  final events = [
    "pickup_ride", // (start ride)
    "message", // (for message)
    "live_location", // (update location)-> user/driver both
    "payment_complete", // (payment complete)
    "ride_end", // (ride end)
  ];

  void onEvent(PusherEvent event) {
    try {
      loggerX(event.channelName);
      loggerX(event.eventName);
      if (event.data == null) return;
      PusherResponseModel model = PusherResponseModel.fromJson(
        jsonDecode(event.data),
      );
      final modify = PusherResponseModel(
        eventName: event.eventName,
        channelName: event.channelName,
        data: model.data,
      );
      updateEvent(modify);
    } catch (e) {
      printX(e);
    }
  }

  void updateEvent(PusherResponseModel event) {
    printX('event.eventName ${event.eventName}');
    if (event.eventName.toString().toLowerCase() ==
        "ONLINE_PAYMENT_RECEIVED".toLowerCase()) {
      printX('event.eventName ${event.data?.rideId}');
      Get.offAndToNamed(
        RouteHelper.rideReviewScreen,
        arguments: event.data?.rideId ?? '',
      );
    } else if (event.eventName.toString().toLowerCase() ==
        "MESSAGE_RECEIVED".toLowerCase()) {
      if (event.data?.message != null) {
        loggerX('update msg <<<<< ${event.data?.rideId ?? ''}');
        controller.addEventMessage(event.data!.message!);
      }
    } else if (event.eventName.toString().toLowerCase() ==
        "LIVE_LOCATION".toLowerCase()) {
      if (detailsController.ride.status == AppStatus.RIDE_ACTIVE.toString()) {
        detailsController.mapController.updateDriverLocation(
          latLng: LatLng(
            StringConverter.formatDouble(
              event.data?.driverLatitude ?? '0',
              precision: 10,
            ),
            StringConverter.formatDouble(
              event.data?.driverLongitude ?? '0',
              precision: 10,
            ),
          ),
          isRunning: false,
        );
      }
    } else if (event.eventName.toString().toLowerCase() ==
        "NEW_BID".toLowerCase()) {
      if (event.data?.bid != null) {
        AudioUtils.playAudio(apiClient.getNotificationAudio());
        MyUtils.vibrate();
        CustomBidToast.newBid(
          bid: event.data!.bid!,
          currency: detailsController.currencySym,
          driverImagePath:
              '${detailsController.driverImagePath}/${event.data?.bid?.driver?.avatar}',
          serviceImagePath:
              '${detailsController.serviceImagePath}/${event.data?.service?.image}',
          totalRideCompleted: event.data?.driverTotalRide ?? '0',
          accepted: () {
            detailsController.acceptBid(event.data?.bid?.id ?? '');
          },
        );
      }
      detailsController.updateBidCount(false);
    } else if (event.eventName.toString().toLowerCase() ==
        "BID_REJECT".toLowerCase()) {
      detailsController.updateBidCount(true);
    } else if (event.eventName.toString().toLowerCase() ==
        "CASH_PAYMENT_RECEIVED".toLowerCase()) {
      detailsController.updatePaymentRequested(isRequested: false);
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
    } else if (event.eventName.toString().toLowerCase() ==
            "PICK_UP".toLowerCase() ||
        event.eventName.toString().toLowerCase() == "RIDE_END".toLowerCase() ||
        event.eventName.toString().toLowerCase() ==
            "BID_ACCEPT".toLowerCase()) {
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
    } else {
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
    }
  }

  bool isRidePage() {
    return Get.currentRoute == RouteHelper.rideDetailsScreen;
  }

  @override
  void onClose() {
    PusherManager().removeListener(onEvent);
    super.onClose();
  }

  Future<void> ensureConnection({String? channelName}) async {
    try {
      var userId = apiClient.sharedPreferences
              .getString(SharedPreferenceHelper.userIdKey) ??
          '';
      await PusherManager()
          .checkAndInitIfNeeded(channelName ?? "private-rider-user-$userId");
    } catch (e) {
      printX("Error ensuring connection: $e");
    }
  }
}
