import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/audio_utils.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:leoparduser/data/model/general_setting/general_setting_response_model.dart';
import 'package:leoparduser/data/model/global/pusher/pusher_event_response_model.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_bid_toast.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:leoparduser/data/services/api_service.dart';

class PusherRideController extends GetxController {
  ApiClient apiClient;
  RideMessageController controller;
  RideDetailsController detailsController;

  PusherRideController(
      {required this.apiClient,
      required this.controller,
      required this.detailsController});
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  bool isPusherLoading = false;
  String appKey = '';
  String cluster = '';
  String token = '';
  String userId = '';
  String rideId = '';

  PusherConfig pusherConfig = PusherConfig();

  final events = [
    "pickup_ride", // (start ride)
    "message", // (for message)
    "live_location", // (update location)-> user/driver both
    "payment_complete", // (payment complete)
    "ride_end", // (ride end)
  ];

  void subscribePusher({required String rideId}) async {
    isPusherLoading = true;
    pusherConfig = apiClient.getPushConfig();
    appKey = pusherConfig.appKey ?? '';
    cluster = pusherConfig.cluster ?? '';
    token = apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.accessTokenKey) ??
        '';
    userId = apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.userIdKey) ??
        '';
    rideId = rideId;
    update();

    printx('appKey ${pusherConfig.toJson()}');
    printx('appKey $appKey');
    printx('appKey $cluster');

    configure("private-ride-$rideId");
    isPusherLoading = false;
    update();
  }

  Future<void> configure(String channelName) async {
    loggerI(appKey);
    loggerI(cluster);
    try {
      await pusher.init(
        apiKey: appKey,
        cluster: cluster,
        // apiKey: "9335da1978421f021993",
        // cluster: "ap2",
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onConnectionStateChange: onConnectionStateChange,
        onMemberAdded: (channelName, member) {},
        onAuthorizer: onAuthorizer,
      );

      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      loggerX(e);
    }
  }

  Future<Map<String, dynamic>?> onAuthorizer(
      String channelName, String socketId, options) async {
    try {
      String authUrl =
          "${UrlContainer.baseUrl}${UrlContainer.pusherAuthenticate}$socketId/$channelName";
      http.Response result = await http.post(
        Uri.parse(authUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          "dev-token":
              "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
        },
      );
      if (result.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(result.body);
        loggerX(json);
        return json;
      } else {
        return null; // or throw an exception
      }
    } catch (e) {
      return null; // or throw an exception
    }
  }

  void onConnectionStateChange(
      dynamic currentState, dynamic previousState) async {
    printx("on connection state change $previousState $currentState");
  }

  void onEvent(PusherEvent event) {
    try {
      loggerX(event.eventName);
      PusherResponseModel model =
          PusherResponseModel.fromJson(jsonDecode(event.data));
      loggerX(event.channelName);
      final modify = PusherResponseModel(
          eventName: event.eventName,
          channelName: event.channelName,
          data: model.data);
      if (event.data == null) return;

      updateEvent(modify);
    } catch (e) {
      printx(e);
    }
  }

  void onError(String message, int? code, dynamic e) {
    printx("onError: $message");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {}

  void onSubscriptionError(String message, dynamic e) {
    printx("onSubscriptionError: $message");
  }

//   --------------------------------Pusher Response --------------------------------

  updateEvent(PusherResponseModel event) {
    printx('event.eventName ${event.eventName}');
    if (event.eventName == "online-payment-received") {
      Get.offAllNamed(RouteHelper.dashboard);
    } else if (event.eventName == "message-received") {
      if (event.data?.message != null) {
        controller.addEventMessage(event.data!.message!);
      }
    } else if (event.eventName == "live_location") {
      //   if (detailsController.ride.status == AppStatus.RIDE_ACTIVE.toString()) {
      detailsController.mapController.updateDriverLocation(
        latLng: LatLng(
            Converter.formatDouble(event.data?.driverLatitude ?? '0',
                precision: 10),
            Converter.formatDouble(event.data?.driverLongitude ?? '0',
                precision: 10)),
        // isRunning: detailsController.ride.status == AppStatus.RIDE_RUNNING.toString() ? true : false,
        isRunning: false,
      );
      // }
    } else if (event.eventName == "new_bid") {
      if (event.data?.bid != null) {
        printx(
            '${detailsController.driverImagePath}/${event.data?.bid?.driver?.avatar}');
        AudioUtils.playAudio(apiClient.getNotificationAudio());
        MyUtils.vibrate();
        CustomBidToast.newBid(
          bid: event.data!.bid!,
          currency: detailsController.currencySym,
          imagePath:
              '${detailsController.driverImagePath}/${event.data?.bid?.driver?.avatar}',
          accepted: () {
            Get.back();
            detailsController.acceptBid(event.data?.bid?.id ?? '');
          },
        );
      }
      detailsController.updateBidCount(false);
    } else if (event.eventName == "bid_reject") {
      detailsController.updateBidCount(true);
    } else if (event.eventName == "cash-payment-request") {
      detailsController.updatePaymentRequested();
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
    } else if (event.eventName == "pick_up" ||
        event.eventName == "ride_end" ||
        event.eventName == "bid_accept" ||
        event.eventName == "ride_start" ||
        event.eventName == "ride_cancel" ||
        event.eventName == "ride_finished") {
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
      if (event.eventName == "pick_up") {
        printx('from pusher ${event.data!.ride?.id ?? ''}');
      }
    } else {
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
    }
  }

  void clearData() {
    closePusher();
  }

  void closePusher() async {
    await pusher.unsubscribe(channelName: "private-ride-$rideId");
    await pusher.disconnect();
  }
}
