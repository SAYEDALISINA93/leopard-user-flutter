import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/global/user/global_user_model.dart';
import 'package:leoparduser/data/model/payment_history/payment_history_response_model.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../core/utils/my_color.dart';
import '../../repo/payment_history/payment_history_repo.dart';

class PaymentHistoryController extends GetxController {
  PaymentHistoryRepo paymentRepo;
  PaymentHistoryController({required this.paymentRepo});

  bool isLoading = true;
  final formKey = GlobalKey<FormState>();

  List<String> transactionTypeList = ["All", "Plus", "Minus"];
  List<String> remarksList = ["All"];

  List<PaymentHistoryData> transactionList = [];
  GlobalUser user = GlobalUser();

  String? nextPageUrl;
  String trxSearchText = '';
  String currency = '';
  String currencySym = '';

  int page = 0;
  int index = 0;

  TextEditingController trxController = TextEditingController();

  String selectedRemark = "All";
  String selectedTrxType = "All";

  void initialSelectedValue() async {
    page = 0;
    selectedRemark = "All";
    selectedTrxType = "All";
    trxController.text = '';
    trxSearchText = '';
    transactionList.clear();
    isLoading = true;
    update();
    user = await paymentRepo.loadProfileInfo();
    await loadTransaction();
    isLoading = false;
    update();
  }

  Future<void> loadTransaction() async {
    page = page + 1;

    if (page == 1) {
      currency = paymentRepo.apiClient.getCurrency();
      currencySym = paymentRepo.apiClient.getCurrency(isSymbol: true);
      remarksList.clear();
      transactionList.clear();
    }

    ResponseModel responseModel = await paymentRepo.getTransactionList(
      page,
      type: selectedTrxType.toLowerCase(),
      remark: selectedRemark.toLowerCase(),
      searchText: trxSearchText,
    );

    if (responseModel.statusCode == 200) {
      PaymentHistoryResponseModel model =
          PaymentHistoryResponseModel.fromJson((responseModel.responseJson));

      nextPageUrl = model.data?.payments?.nextPageUrl;

      if (model.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        List<PaymentHistoryData>? tempDataList =
            model.data?.payments?.data ?? [];
        if (page == 1) {
          List<String>? tempRemarksList = [];

          if (tempRemarksList.isNotEmpty) {
            for (var element in tempRemarksList) {
              printE("Temp Remarks: $element");
            }
          }
        }

        if (tempDataList.isNotEmpty) {
          transactionList.addAll(tempDataList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    update();
  }

  void changeSelectedRemark(String remarks) {
    selectedRemark = remarks;
    update();
  }

  void changeSelectedTrxType(String trxType) {
    selectedTrxType = trxType;
    update();
  }

  bool filterLoading = false;

  Future<void> filterData() async {
    trxSearchText = trxController.text;
    page = 0;
    filterLoading = true;
    update();
    transactionList.clear();

    await loadTransaction();

    filterLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null &&
            nextPageUrl!.isNotEmpty &&
            nextPageUrl != 'null'
        ? true
        : false;
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();
    if (!isSearch) {
      initialSelectedValue();
    }
  }

  Color changeTextColor(String trxType) {
    return trxType == MyStrings.plusText
        ? MyColor.greenSuccessColor
        : MyColor.colorRed;
  }

  int expandIndex = -1;
  void changeExpandIndex(int index) {
    expandIndex = expandIndex == index ? -1 : index;
    update();
  }
}
