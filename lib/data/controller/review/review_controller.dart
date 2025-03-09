import 'dart:convert';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/model/global/user/global_driver_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';
import 'package:leoparduser/data/model/review/review_response_history_model.dart';
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
        ReviewHistoryResponseModel model = ReviewHistoryResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
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
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
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
        ReviewHistoryResponseModel model = ReviewHistoryResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          reviews.addAll(model.data?.reviews ?? []);
          rider = model.data?.rider;
          driverImagePath =
              "${UrlContainer.domainUrl}/${model.data?.driverImagePath}";
          userImagePath =
              "${UrlContainer.domainUrl}/${model.data?.userImagePath}";
        } else {
          CustomSnackBar.error(
              errorList: model.message ?? [MyStrings.somethingWentWrong]);
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
}
