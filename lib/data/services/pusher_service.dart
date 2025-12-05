import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/method.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherManager {
  static final PusherManager _instance = PusherManager._internal();
  factory PusherManager() => _instance;
  PusherManager._internal();
  ApiClient apiClient = ApiClient(sharedPreferences: Get.find());
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final List<void Function(PusherEvent)> _listeners = [];

  Future<void> init(
    String channelName, {
    required String apiKey,
    required String cluster,
    required Future<dynamic> Function(
            String channelName, String socketId, dynamic options)
        onAuthorizer,
    Function(String message, int? code, dynamic e)? onError,
    Function(String message, dynamic e)? onSubscriptionError,
    Function(String channelName, dynamic data)? onSubscriptionSucceeded,
  }) async {
    await pusher.init(
      apiKey: apiKey,
      cluster: cluster,
      onConnectionStateChange: (_, __) {},
      onEvent: _dispatchEvent,
      onError: onError,
      onSubscriptionError: onSubscriptionError,
      onSubscriptionSucceeded: onSubscriptionSucceeded,
      onAuthorizer: onAuthorizer,
      onDecryptionFailure: (_, __) {},
      onMemberAdded: (_, __) {},
      onMemberRemoved: (_, __) {},
    );

    await pusher.subscribe(channelName: channelName);
    await pusher.connect();
  }

  void _dispatchEvent(PusherEvent event) {
    for (var listener in _listeners) {
      listener(event);
    }
  }

  void addListener(void Function(PusherEvent) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
      printX("👂 Listener added. Total: ${_listeners.length}");
    }
  }

  void removeListener(void Function(PusherEvent) listener) {
    _listeners.remove(listener);
  }

  bool isConnected() => pusher.connectionState != 'disconnected';

  Future<void> checkAndInitIfNeeded(String channelName) async {
    printE(channelName);
    final state = pusher.connectionState;
    printE(state);
    if (state.toLowerCase() == 'disconnected' ||
        state == 'disconnecting' ||
        state == 'connecting') {
      printX("🔄 Pusher state: $state. Reinitializing...");

      final apiKey = apiClient.getPushConfig().appKey ?? "";
      final cluster = apiClient.getPushConfig().cluster ?? "";

      await init(
        channelName,
        apiKey: apiKey,
        cluster: cluster,
        onAuthorizer: onAuthorizer,
        onError: (msg, code, e) => printX("Pusher Error: $msg"),
        onSubscriptionError: (msg, e) => printX("Sub Error: $msg"),
        onSubscriptionSucceeded: (channel, data) =>
            printX("✅ Subscribed: $channel"),
      );
    } else {
      printX("✅ Pusher already connected: $state");

      // Check if channel is already subscribed
      final isSubscribed = pusher.getChannel(channelName) != null;
      if (!isSubscribed) {
        printX("📡 Subscribing to new channel: $channelName");
        await pusher.subscribe(channelName: channelName);
      } else {
        printX("🔁 Already subscribed to: $channelName");
      }
    }
  }

  Future<Map<String, dynamic>?> onAuthorizer(
    String channelName,
    String socketId,
    options,
  ) async {
    try {
      String authUrl =
          "${UrlContainer.baseUrl}${UrlContainer.pusherAuthenticate}$socketId/$channelName";

      ResponseModel response = await apiClient.request(
        authUrl,
        Method.postMethod,
        null,
        passHeader: true,
      );

      printX("Pusher result<< ${response.responseJson}");
      if (response.statusCode == 200) {
        Map<String, dynamic> json = response.responseJson;
        printX("json ${json.toString()}");
        return json;
      } else {
        return null; // or throw an exception
      }
    } catch (e) {
      printX("error<< $e");
      return null; // or throw an exception
    }
  }
}
