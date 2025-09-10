import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/global/user/global_driver_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';
import 'package:leoparduser/data/model/review/review_response_history_model.dart';
import 'package:leoparduser/data/model/ride/ride_details_response_model.dart';
import 'package:leoparduser/data/repo/review/review_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class ReviewController extends GetxController {
  ReviewRepo repo;
  ReviewController({required this.repo});

  bool isLoading = true;
  List<Review> reviews = [];
  String driverImagePath = "";
  String userImagePath = "";
  GlobalUser? rider;
  GlobalDriverInfo? driver;

  Future<void> getReview(String id) async {
    isLoading = true;
    update();
    try {
      final responseModel = await repo.getReviews(id: id);
      if (responseModel.statusCode == 200) {
        ReviewHistoryResponseModel model =
            ReviewHistoryResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          reviews.addAll(model.data?.reviews ?? []);
          driver = model.data?.driver;
          rider = model.data?.rider;
          driverImagePath =
              "${UrlContainer.domainUrl}/${model.data?.driverImagePath}";
          userImagePath =
              "${UrlContainer.domainUrl}/${model.data?.userImagePath}";
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getMyReview() async {
    isLoading = true;
    update();
    try {
      final responseModel = await repo.getMyReviews();
      if (responseModel.statusCode == 200) {
        ReviewHistoryResponseModel model =
            ReviewHistoryResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          reviews.addAll(model.data?.reviews ?? []);
          rider = model.data?.rider;
          driverImagePath =
              "${UrlContainer.domainUrl}/${model.data?.driverImagePath}";
          userImagePath =
              "${UrlContainer.domainUrl}/${model.data?.userImagePath}";
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    } finally {
      isLoading = false;
      update();
    }
  }

  // initialize
  String currency = "";
  String currencySym = "";
  String serviceImagePath = "";
  String brandImagePath = "";
  String rideId = "";
  RideModel? ride;

  Future<void> initialData(String id) async {
    currency = repo.apiClient.getCurrency();
    currencySym = repo.apiClient.getCurrency(isSymbol: true);
    rideId = id;
    update();
    getRideDetails();
  }

  Future<void> getRideDetails() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.getRideDetails(rideId);
    if (responseModel.statusCode == 200) {
      RideDetailsResponseModel model =
          RideDetailsResponseModel.fromJson((responseModel.responseJson));
      if (model.status == MyStrings.success) {
        RideModel? tempRide = model.data?.ride;
        if (tempRide != null) {
          ride = tempRide;
        }
        serviceImagePath =
            '${UrlContainer.domainUrl}/${model.data?.serviceImagePath ?? ''}';
        brandImagePath =
            '${UrlContainer.domainUrl}/${model.data?.brandImagePath ?? ''}';
        driverImagePath =
            '${UrlContainer.domainUrl}/${model.data?.driverImagePath}';
        loggerX('Service image path : ${model.data?.serviceImagePath}');
        loggerX('Brand image path : ${model.data?.brandImagePath}');
        loggerX('User image path : ${model.data?.driverImagePath}');
        update();
      } else {
        Get.back();
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  TextEditingController reviewMsgController = TextEditingController();
  double rating = 0.0;

  void updateRating(double rate) {
    rating = rate;
    update();
  }

  bool isReviewLoading = false;
  Future<void> reviewRide() async {
    isReviewLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.reviewRide(
        rideId: rideId,
        rating: rating.toString(),
        review: reviewMsgController.text,
      );
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson((responseModel.responseJson));

        if (model.status == MyStrings.success) {
          printX(model.status);
          reviewMsgController.text = '';
          rating = 0.0;
          update();

          Get.offNamed(RouteHelper.dashboard);
          CustomSnackBar.success(successList: model.message ?? []);
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isReviewLoading = false;
    update();
  }
}
